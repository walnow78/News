//
//  POLRanking.h
//  News
//
//  Created by Pawel Walicki on 3/5/15.
//  Copyright (c) 2015 Pawel Walicki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POLRanking : NSObject

@property (nonatomic,strong) NSString* newsId;
@property (nonatomic,strong) NSString* author;
@property (nonatomic,strong) NSString* text;
@property (nonatomic,strong) NSNumber* userRanking;

-(instancetype) initWithNewsId:(NSString*) newsId author:(NSString*) author text:(NSString*) text userRanking:(NSNumber*) userRanking;

@end
