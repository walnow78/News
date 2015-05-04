//
//  POLPhotoDetailViewController.h
//  HackerBookPro
//
//  Created by Pawel Walicki on 26/4/15.
//  Copyright (c) 2015 Pawel Walicki. All rights reserved.
//

#import <UIKit/UIKit.h>
@class POLNews;

@interface POLPhotoDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@property (nonatomic,strong) POLNews* model;

-(instancetype) initWithModel:(POLNews*) model;


- (IBAction)photoButtonItem:(id)sender;
- (IBAction)deleteButtonItem:(id)sender;

@end
