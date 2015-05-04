//
//  POLPrincipalViewController.h
//  prueba
//
//  Created by Pawel Walicki on 30/4/15.
//  Copyright (c) 2015 Pawel Walicki. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@class POLNews;

@interface POLNewsViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSegmentControl;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *textTextView;
@property (weak, nonatomic) IBOutlet UILabel *ratingUsersLabel;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (nonatomic,strong) POLNews* model;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

-(instancetype) initWithNews:(POLNews*) model;
-(instancetype) initWithNewNews;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *guardarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *valoracionesButton;

- (IBAction)ratingNews:(id)sender;
- (IBAction)sendNews:(id)sender;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
