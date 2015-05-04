//
//  POLPhotoDetailViewController.m
//  HackerBookPro
//
//  Created by Pawel Walicki on 26/4/15.
//  Copyright (c) 2015 Pawel Walicki. All rights reserved.
//

#import "POLPhotoDetailViewController.h"
#import "POLNews.h"

@interface POLPhotoDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@end

@implementation POLPhotoDetailViewController

-(instancetype) initWithModel:(POLNews*) model{
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        _model = model;
        
    }
    
    return self;
}


#pragma mark - View lifeCycle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.photoView.image = self.model.image;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.model.image = self.photoView.image;
}

#pragma mark - Actions

- (IBAction)photoButtonItem:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    // Miro si existe la cámara
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    
    picker.delegate = self;
    
    picker.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (IBAction)deleteButtonItem:(id)sender {
    
    CGRect oldBounds = self.photoView.bounds;
    
    [UIView animateWithDuration:0.6
                          delay:0
                        options:0 animations:^{
                            
                            self.photoView.bounds = CGRectZero;
                            self.photoView.alpha = 0;
                            
                            self.photoView.transform = CGAffineTransformMakeRotation(M_2_PI);
                            
                        } completion:^(BOOL finished) {
                            
                            self.photoView.image = nil;
                            self.photoView.alpha = 1;
                            self.photoView.bounds = oldBounds;
                            self.photoView.transform = CGAffineTransformIdentity;
                            
                            
                        }];
    
    self.model.image = nil;
    
}

#pragma mark - UIImagePickerControllerDelegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.model.image = image;
    
    image = nil;
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}

@end
