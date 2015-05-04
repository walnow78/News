//
//  POLCollection.h
//  News
//
//  Created by Pawel Walicki on 2/5/15.
//  Copyright (c) 2015 Pawel Walicki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POLCollection : NSObject

@property (nonatomic,strong) NSMutableArray *newsPublished;
@property (nonatomic,strong) NSMutableArray *newsUnpublished;
@property (nonatomic,strong) NSMutableArray *newsPublishedAzure;

-(void) downloadNewsPublished;
-(void) downloadNewsUnpublished;
-(void) downloadNewsPublishedAzure;



@end
