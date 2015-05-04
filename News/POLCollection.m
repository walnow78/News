//
//  POLCollection.m
//  News
//
//  Created by Pawel Walicki on 2/5/15.
//  Copyright (c) 2015 Pawel Walicki. All rights reserved.
//

#import "POLCollection.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "POLNews.h"

@interface POLCollection()

@property (nonatomic,strong) MSClient *client;

@end


@implementation POLCollection

-(id) init{
    
    self.client = [MSClient clientWithApplicationURLString:@"https://platformnews.azure-mobile.net/"
                                            applicationKey:@"DgCbXtEpDMUPZQokWzMbygKpJPeJeJ14"];
    
    return self;
    
}

#pragma mark - Public methods

-(void) downloadNewsPublished{
    
    [self downloadNewsWithType:@"published"];
}

-(void) downloadNewsUnpublished{
    
    [self downloadNewsWithType:@"unpublished"];

}

-(void) downloadNewsPublishedAzure{
    
    [self downloadNewsWithType:@"publishedAzure"];

}

#pragma mark - Utils

-(void) downloadNewsWithType:(NSString*) type{
    
    NSPredicate *predicate;
    
    MSTable *table = [self.client tableWithName:@"news"];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if ([type isEqualToString:@"published"]) {
        
        // Vacio el array
        
        [self.newsPublished removeAllObjects];
        
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
    
    query.selectFields = @[@"id", @"__createdAt", @"title", @"text", @"image", @"latitude", @"longitude", @"status", @"userRanking"];
    
    [query orderByAscending:@"__createdAt"];
    [query orderByDescending:@"title"];
    
    // Descarga de la noticia
    
    [query readWithCompletion:^(MSQueryResult *result, NSError *error) {
        
        if (error) {
            NSLog(@"Error query: %@", error);
        }else{
            
            // Inicializo el array correspondiente
            
            if ([type isEqualToString:@"published"]) {
                self.newsPublished = [[NSMutableArray alloc] initWithCapacity:result.totalCount];
            }else if ([type isEqualToString:@"unpublished"]){
                self.newsUnpublished = [[NSMutableArray alloc] initWithCapacity:result.totalCount];
            }else{
                self.newsPublishedAzure = [[NSMutableArray alloc] initWithCapacity:result.totalCount];
            }
            
            for (NSDictionary* each in result.items) {
                
                POLNews *news = [[POLNews alloc] initWithDictionary:each];
                
                // Voy guardando las noticias
                
                if ([type isEqualToString:@"published"]) {
                    [self.newsPublished addObject:news];
                }else if ([type isEqualToString:@"unpublished"]){
                    [self.newsUnpublished addObject:news];
                }else{
                    [self.newsPublishedAzure addObject:news];
                }

            }
        }
        
    }];
    
}

@end
