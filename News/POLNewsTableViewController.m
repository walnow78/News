//
//  POLNewsTableViewController.m
//  News
//
//  Created by Pawel Walicki on 1/5/15.
//  Copyright (c) 2015 Pawel Walicki. All rights reserved.
//

#import "POLNewsTableViewController.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "POLNews.h"
#import "POLNewsViewController.h"
#import "POLCollection.h"

@interface POLNewsTableViewController ()

@property (nonatomic,strong) MSClient *client;

@property (nonatomic, strong) NSMutableArray* newsFiltered;

@property (nonatomic,strong) NSMutableArray *news;

@property BOOL isFiltered;


@end

@implementation POLNewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Asigno los delegados.
    
    self.mitabla.dataSource = self;
    self.mitabla.delegate = self;
    self.searchBar.delegate = self;
    
    self.client = [MSClient clientWithApplicationURLString:@"https://platformnews.azure-mobile.net/"
                                            applicationKey:@"DgCbXtEpDMUPZQokWzMbygKpJPeJeJ14"];
    
   
    
    self.isFiltered = NO;
    
    self.newsFiltered = [[NSMutableArray alloc] init];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    if ([ud objectForKey:@"userId"]) {
        self.toolbarNews.hidden = NO;
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                      target:self
                                      action:@selector(addNews:)];
        
        
        self.navigationItem.rightBarButtonItem = addButton;
     
    }else{
        self.toolbarNews.hidden = YES;
    }
    
    // Muestro solamente las noticias publicadas por azure
    
    [self downloadNewsWithType:@"publishedAzure"];
}

#pragma mark - Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"";
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.isFiltered) {
        return [self.newsFiltered count];
    }else{
        return [self.news count];
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    POLNews *news;
    
    if (self.isFiltered) {
        news = [self.newsFiltered objectAtIndex:indexPath.row];
    }else{
        news = [self.news objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = news.title;
    
    if (news.status == [NSNumber numberWithInt:2]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Valoración media: %@ ptos.", news.userRanking];
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Pendiente de valorar"];
    }
   
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    POLNews *news;
    
    if (self.isFiltered) {
        news = [self.newsFiltered objectAtIndex:indexPath.row];
    }else{
        news = [self.news objectAtIndex:indexPath.row];
    }

    POLNewsViewController *vc = [[POLNewsViewController alloc] initWithNews:news];
    
    [self.navigationController pushViewController:vc
                                         animated:YES];
    
}

#pragma mark - Utils

-(void) downloadNewsWithType:(NSString*) type{
    
    NSPredicate *predicate;
    
    MSTable *table = [self.client tableWithName:@"news"];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [self.news removeAllObjects];
    
    if ([type isEqualToString:@"published"]) {
        
        // Noticias publicadas
        
        predicate = [NSPredicate predicateWithFormat:@"author == %@ && status = 1", [ud objectForKey:@"userId"]];
        
    }else if ([type isEqualToString:@"unpublished"]){
        
        // Noticias no publicadas
        
        predicate = [NSPredicate predicateWithFormat:@"author == %@ && status = 0", [ud objectForKey:@"userId"]];
        
    }else{
        
        // Published Azure
        
        predicate = [NSPredicate predicateWithFormat:@"status = 2"];
        
    }
    
    MSQuery *query = [table queryWithPredicate:predicate];
    
    query.includeTotalCount = YES;
    
    query.selectFields = @[@"id", @"__createdAt", @"title", @"text", @"image", @"latitude2", @"longitude2", @"status", @"userRanking"];
    
    [query orderByAscending:@"__createdAt"];
    [query orderByDescending:@"title"];
    
    // Descarga de la noticia
    
    [query readWithCompletion:^(MSQueryResult *result, NSError *error) {
        
        if (error) {
            NSLog(@"Error query: %@", error);
        }else{
            
            self.news = [[NSMutableArray alloc] initWithCapacity:result.totalCount];
            
            for (NSDictionary* each in result.items) {
                
                POLNews *news = [[POLNews alloc] initWithDictionary:each];
                
                // Voy guardando las noticias
                
                [self.news addObject:news];
                
            }
            
            [self.mitabla reloadData];
        }
        
    }];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", searchText];
    
    if (searchText.length > 0) {
        
        self.newsFiltered = [[NSMutableArray alloc] initWithArray:self.news];
        
        [self.newsFiltered filterUsingPredicate:predicate];
        
        self.isFiltered = YES;
        
    }else{
        self.isFiltered = NO;
    }
    
    [self.mitabla reloadData];
    
}

- (IBAction)showAllNews:(id)sender {
    
    [self downloadNewsWithType:@"publishedAzure"];

}

- (IBAction)showPublishedNews:(id)sender {
    
    [self downloadNewsWithType:@"published"];
    
}

- (IBAction)showUnpublishedNews:(id)sender {
    
    [self downloadNewsWithType:@"unpublished"];

}

-(void) addNews:(id) sender{
    
    POLNewsViewController *vc =[[POLNewsViewController alloc] initWithNewNews];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
