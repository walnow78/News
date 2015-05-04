//
//  POLAutentificacionViewController.h
//  prueba
//
//  Created by Pawel Walicki on 30/4/15.
//  Copyright (c) 2015 Pawel Walicki. All rights reserved.
//

#import <UIKit/UIKit.h>
@class POLCollection;

@interface POLAutentificacionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *photoUser;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *userName;


- (IBAction)facebookButton:(id)sender;
- (IBAction)googleButton:(id)sender;
- (IBAction)goApp:(id)sender;
- (IBAction)unlogin:(id)sender;





@property (nonatomic,strong) POLCollection* model;

-(instancetype) initWithModel:(POLCollection*) model;

@end
