//
//  POLRankingViewController.m
//  News
//
//  Created by Pawel Walicki on 2/5/15.
//  Copyright (c) 2015 Pawel Walicki. All rights reserved.
//

#import "POLRankingViewController.h"
#import "POLNews.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "POLRanking.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface POLRankingViewController ()

@property(nonatomic,strong) MSClient *client;

@property (nonatomic,strong) NSMutableArray* ranking;

@end

@implementation POLRankingViewController



-(instancetype) initWithModel:(POLNews*) model{
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        _model = model;
        
    }
    
    return self;
    
}

- (IBAction)hideKeyboard:(id)sender {
    
     [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Google Analytics
    
    self.screenName = @"Revisión de noticias";
    
    // *****************
    
    self.rankingTableView.dataSource = self;
    self.rankingTableView.delegate = self;
    
    
    self.client = [MSClient clientWithApplicationURLString:@"https://platformnews.azure-mobile.net/"
                                            applicationKey:@"DgCbXtEpDMUPZQokWzMbygKpJPeJeJ14"];

    
    self.titleNews.text = self.model.title;
    
    [self downloadRanking];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if ([ud objectForKey:@"userId"]) {
        self.valoracionbuttonItem.enabled = YES;
    }else{
        
        self.valoracionbuttonItem.enabled = NO;
    }
}

#pragma mark - Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"";
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return [self.ranking count];
  
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    POLRanking *ranking = [self.ranking objectAtIndex:indexPath.row];
    
    cell.textLabel.text = ranking.text;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Usuario: %@, %@ pts.",ranking.author,  ranking.userRanking];
    
    return cell;
}

#pragma mark - Actions

- (IBAction)sliderValueChanged:(id)sender {
    
    self.ratingNumber.text = [NSString stringWithFormat:@"Rating %ld", lround(self.slider.value)];
    
}

- (IBAction)sendRating:(id)sender {
    
    // Google Analytics
    
    id<GAITracker> tracker = [[GAI sharedInstance]defaultTracker];
    
    // Envío la noticia y la valoración.
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Valoración noticia"
                                                          action:@"Valoracion"
                                                           label:self.model.title
                                                           value:[NSNumber numberWithLong:lround(self.slider.value)]] build]];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dict = @{@"newsid":self.model.idNews,
                           @"author":[ud objectForKey:@"userName"],
                           @"text" : self.ratingText.text,
                           @"userRanking":[NSNumber numberWithLong:lround(self.slider.value)]
                           };
    
    
    [self.client invokeAPI:@"updaterating"
                            body:nil
                      HTTPMethod:@"GET"
                      parameters:dict
                         headers:nil
                      completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
        
                          NSString *alertTitle;
                          NSString *alertText;
                          
                          if (error) {
                              NSLog(@"Error: %@", error.localizedDescription);
                              alertTitle = @"Error";
                              alertText = error.localizedDescription;
                          }else{
                              alertTitle = @"OK";
                              alertText = [result objectForKey:@"message"];
                              
                             
                          }
                          
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                          message:alertText
                                                                         delegate:self
                                                                cancelButtonTitle:nil
                                                                otherButtonTitles:@"Done", nil];
                          
                          [alert setAlertViewStyle:UIAlertViewStyleDefault];
                          
                          [alert show];

                          
                         
    }];

    
}

-(void) downloadRanking{
    
    [self.ranking removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"newsid == %@", self.model.idNews];
    
    MSTable *table = [self.client tableWithName:@"ranking"];
    
    MSQuery *query = [table queryWithPredicate:predicate];
    
    query.includeTotalCount = YES;
    
    query.selectFields = @[@"id", @"__createdAt", @"newsid", @"author", @"text", @"userranking"];
    
    [query orderByAscending:@"__createdAt"];
    [query orderByDescending:@"userranking"];
    
    [query readWithCompletion:^(MSQueryResult *result, NSError *error) {
        
        if (error) {
            NSLog(@"Error query: %@", error);
        }else{
            
            self.ranking = [[NSMutableArray alloc] initWithCapacity:result.totalCount];
            
            for (NSDictionary* each in result.items) {
                
                POLRanking *ranking = [[POLRanking alloc] initWithNewsId:[each objectForKey:@"newsid"] author:[each objectForKey:@"author"] text:[each objectForKey:@"text"] userRanking:[each objectForKey:@"userranking"]];
                
                [self.ranking addObject:ranking];
                
            }
            
            [self.rankingTableView reloadData];
        }
        
    }];
    
    
    
}


@end
