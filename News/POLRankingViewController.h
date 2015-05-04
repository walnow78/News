//
//  POLRankingViewController.h
//  News
//
//  Created by Pawel Walicki on 2/5/15.
//  Copyright (c) 2015 Pawel Walicki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class POLNews;

@interface POLRankingViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleNews;
@property (weak, nonatomic) IBOutlet UITextView *ratingText;

@property (weak, nonatomic) IBOutlet UILabel *ratingNumber;
- (IBAction)sliderValueChanged:(id)sender;

@property(nonatomic,strong) POLNews* model;
@property (weak, nonatomic) IBOutlet UISlider *slider;

- (IBAction)sendRating:(id)sender;
-(instancetype) initWithModel:(POLNews*) model;

- (IBAction)hideKeyboard:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *valoracionbuttonItem;
@property (weak, nonatomic) IBOutlet UITableView *rankingTableView;

@end
