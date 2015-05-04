//
//  POLNewsTableViewController.h
//  News
//
//  Created by Pawel Walicki on 1/5/15.
//  Copyright (c) 2015 Pawel Walicki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POLNews.h"

@class POLCollection;

@interface POLNewsTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mitabla;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbarNews;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)showAllNews:(id)sender;
- (IBAction)showPublishedNews:(id)sender;
- (IBAction)showUnpublishedNews:(id)sender;

@end
