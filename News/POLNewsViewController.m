//
//  POLPrincipalViewController.m
//  prueba
//
//  Created by Pawel Walicki on 30/4/15.
//  Copyright (c) 2015 Pawel Walicki. All rights reserved.
//

#import "POLNewsViewController.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "POLNews.h"
#import "POLRankingViewController.h"
#import "POLPhotoDetailViewController.h"
#import "POLAnnotation.h"

@import CoreLocation;

@interface POLNewsViewController () <CLLocationManagerDelegate>

@property(nonatomic,strong) MSClient *client;
@property BOOL newNews;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLLocation *location;
@end

@implementation POLNewsViewController

-(instancetype) initWithNews:(POLNews*) model{
    
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        _model = model;
        
        self.newNews = NO;
    }
    
    return self;
    
}

-(instancetype) initWithNewNews{
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        _model = nil;
        
        self.newNews = YES;
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"News";
    
    self.client = [MSClient clientWithApplicationURLString:@"https://platformnews.azure-mobile.net/"
                                            applicationKey:@"DgCbXtEpDMUPZQokWzMbygKpJPeJeJ14"];
    
    // Al hacer click sobre la imagen,
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoDetail:)];
    
    [self.photoImage addGestureRecognizer:tap];
    
    
    [self refreshMapKit];

    if (self.model.status.intValue == 2) {
        
        // En caso de que sea noticia publicada por azure
        
        self.guardarButton.enabled = NO;
        self.statusSegmentControl.hidden = YES;
        
        // Las pueden valorar solamente los usuario registrados
        
        self.valoracionesButton.enabled = YES;
        
    }else{
       self.guardarButton.enabled = true;
        
        self.valoracionesButton.enabled = NO;
        
        
        self.statusSegmentControl.hidden = NO;
    }
    
    if (!self.newNews) {
        self.titleTextField.text = self.model.title;
        self.textTextView.text = self.model.text;
        self.ratingUsersLabel.text = [NSString stringWithFormat:@"Valoración media: %@ pts.", self.model.userRanking];
        self.statusSegmentControl.selectedSegmentIndex = self.model.status.integerValue;

    }else{
        self.ratingUsersLabel.hidden = true;
    }
    
}

- (IBAction)hideKeyboard:(id)sender {
    
     [self.view endEditing:YES];
    
}

- (IBAction)sendNews:(id)sender {
    
    if (self.newNews) {
        [self createNews];
    }else{
    
    [self updateNews];
    }
    
}
- (IBAction)ratingNews:(id)sender {
    
    POLRankingViewController *vc = [[POLRankingViewController alloc] initWithModel:self.model];
    
    [self.navigationController pushViewController:vc
                                         animated:YES];
}


-(void) photoDetail:(id) sender{
    
    
    POLPhotoDetailViewController *photoVC = [[POLPhotoDetailViewController alloc] initWithModel:self.model];
    
    [self.navigationController pushViewController:photoVC animated:YES];
}


-(void) createNews{
    
    MSTable *table = [self.client tableWithName:@"news"];
    


    // *localizacion
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    
    [self.locationManager requestAlwaysAuthorization];
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
    // A los 5 seg. dejo de buscar por el gasto de batería
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"sin localización");
        [self destroyLocation];
        
        
        // Escribimos un registro en la tabla.
                
        POLNews *news = [[POLNews alloc] initWithTitle:self.titleTextField.text
                                                  text:self.textTextView.text
                                                 image:nil
                                              latitude:[NSNumber numberWithDouble:self.location.coordinate.latitude]
                                             longitude:[NSNumber numberWithDouble:self.location.coordinate.longitude]
                                                status:[NSNumber numberWithInteger:self.statusSegmentControl.selectedSegmentIndex]
                                           userRanking:0];
        
        [table insert:[news newsAsDictionaryForInsert] completion:^(NSDictionary *insertedItem, NSError *error) {
            
            NSString *alertTitle;
            NSString *alertText;
            
            if (error) {
                
                alertTitle = @"Error";
                alertText = error.localizedDescription;
            } else {
                alertText =  [NSString stringWithFormat:@"La noticia ha sido creada con éxito. El Id asociado es el \n%@", [insertedItem objectForKey:@"id"]];
                alertTitle = @"Creación de la noticia finalizada";
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:alertText
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Done", nil];
            
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            
            [alert show];
            
        }];
        
        
    });
}

-(void) updateNews{
    
    
    MSTable *table = [self.client tableWithName:@"news"];
    
    POLNews *news = self.model;
    
    news.title = self.titleTextField.text;
    news.text = self.textTextView.text;
    news.status = [NSNumber numberWithInteger:self.statusSegmentControl.selectedSegmentIndex];

    [table update:[self.model newsAsDictionary] completion:^(NSDictionary *item, NSError *error) {
        
        NSString *alertTitle;
        NSString *alertText;
        
        if (error) {
            
            alertTitle = @"Error";
            alertText = error.localizedDescription;
        } else {
            alertText =  @"Enhorabuena, la noticia ha sido actualizado en su cloud";
            alertTitle = @"Actualización completada";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertText
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Aceptar", nil];
        
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        
        [alert show];

        
    }];
    
}

#pragma mark - CLLocationManagerDelegate
-(void) locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    
    // Ya me ha dado alguna localización así que destruyo la localización.
    
    [self destroyLocation];
    
    // Recupero la última localización
    self.location = [locations lastObject];
    
    NSLog(@"%f, %f", self.location.coordinate.latitude, self.location.coordinate.longitude);
    
}

-(void) destroyLocation{
    
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    self.locationManager = nil;
    
    NSLog(@"gps cerrado");
    
    
}

#pragma mark - mapkit
-(void)refreshMapKit {
    
    // pin
    CLLocationCoordinate2D location;
    
    
    
    location.latitude = self.model.latitude.doubleValue;
    location.longitude = self.model.longitude.doubleValue;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 150, 150);
    
    [self.mapView setRegion:region animated:YES];
    
     POLAnnotation *point = [[POLAnnotation alloc] initWithTitle:@"Ubicación de la noticia"
                                                                             subtitle:self.model.title
                                                                        andCoordinate:location];
    
    
    
    [self.mapView addAnnotation:point];
}

@end
