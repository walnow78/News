//
//  POLRanking.m
//  News
//
//  Created by Pawel Walicki on 3/5/15.
//  Copyright (c) 2015 Pawel Walicki. All rights reserved.
//

#import "POLRanking.h"

@implementation POLRanking

-(instancetype) initWithNewsId:(NSString*) newsId author:(NSString*) author text:(NSString*) text userRanking:(NSNumber*) userRanking{
    
    if (self = [super init]) {
        
        _newsId = newsId;
        _author = author;
        _text = text;
        _userRanking = userRanking;
        
    }
    
    return self;
}


@end
