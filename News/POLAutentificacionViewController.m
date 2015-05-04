//
//  POLAutentificacionViewController.m
//  prueba
//
//  Created by Pawel Walicki on 30/4/15.
//  Copyright (c) 2015 Pawel Walicki. All rights reserved.
//

#import "POLAutentificacionViewController.h"
#import "POLNewsViewController.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "POLNewsTableViewController.h"


@interface POLAutentificacionViewController ()

@property(nonatomic,strong) MSClient *client;

@end

@implementation POLAutentificacionViewController

-(instancetype) initWithModel:(POLCollection*) model{
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        _model = model;
        
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityIndicator.hidden = YES;
    
    self.client = [MSClient clientWithApplicationURLString:@"https://platformnews.azure-mobile.net/"
                                            applicationKey:@"DgCbXtEpDMUPZQokWzMbygKpJPeJeJ14"];
    
    // En el caso de que tenga el login.
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if ([ud objectForKey:@"userId"]) {
        [self showUserInfo];
    }
    
}

#pragma mark - Actions

- (IBAction)facebookButton:(id)sender {
    
    [self loginWithProvider:@"facebook" api:@"getuserinfofacebook"];
}

- (IBAction)googleButton:(id)sender {
    
    [self loginWithProvider:@"google" api:@"getuserinfogoogle"];
}

- (IBAction)goApp:(id)sender {
    
    POLNewsTableViewController *vc = [[POLNewsTableViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:NO];

}

- (IBAction)unlogin:(id)sender {
    
    [self saveUserInfoWithUserId:nil userName:nil userPhoto:nil];
    
    [self showUserInfo];
    
}

#pragma mark - Utils

- (void) loginWithProvider:(NSString*) provider api:(NSString*) api{
    
    [self.client loginWithProvider:provider controller:self animated:YES completion:^(MSUser *user, NSError *error) {
        
        if(error) {
            
            NSLog(@"Error: %@", error);
            
        } else {
            
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
            
            [self.client invokeAPI:api
                              body:nil
                        HTTPMethod:@"GET"
                        parameters:nil
                           headers:nil
                        completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                            
                            NSString *photo;
                            
                            if ([provider isEqualToString:@"facebook"]) {
                                photo = result[@"picture"][@"data"][@"url"];
                            }else{
                                photo = result[@"picture"];
                            }
                            
                            [self saveUserInfoWithUserId:self.client.currentUser.userId
                                                userName:result[@"name"]
                                               userPhoto:photo];
                            
                            [self showUserInfo];
                            
                            self.activityIndicator.hidden = YES;
                            [self.activityIndicator stopAnimating];
                            
                        }];
        }
        
    }];
}

-(void) saveUserInfoWithUserId:(NSString*) userId
                      userName:(NSString*) userName
                     userPhoto:(NSString*) userPhoto {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setObject:userId forKey:@"userId"];
    [ud setObject:userName forKey:@"userName"];
    [ud setObject:userPhoto forKey:@"userPhoto"];
    
    [ud synchronize];
    
}





-(void) showUserInfo{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSURL *urlPhoto = [NSURL URLWithString:[ud objectForKey:@"userPhoto"]];
    NSData *data = [NSData dataWithContentsOfURL:urlPhoto];
    UIImage *image = [UIImage imageWithData:data];
    
    self.photoUser.layer.cornerRadius = self.photoUser.frame.size.width / 2;
    self.photoUser.clipsToBounds = YES;
    self.photoUser.image = image;
    
    self.userName.text = [ud objectForKey:@"userName"];
    
}

@end
