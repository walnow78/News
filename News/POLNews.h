//
//  POLNews.h
//  News
//
//  Created by Pawel Walicki on 30/4/15.
//  Copyright (c) 2015 Pawel Walicki. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface POLNews : NSObject

@property (nonatomic,copy) NSString* title;
@property (nonatomic,copy) NSString* text;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, copy) NSString *author;
@property (nonatomic) NSNumber* latitude;
@property (nonatomic) NSNumber* longitude;
@property (nonatomic) NSNumber* status;
@property (nonatomic) NSNumber* userRanking;
@property (nonatomic,strong) NSDate *createAt;
@property (nonatomic,strong) NSString *idNews;

+(instancetype) newsWithTitle:(NSString*) title
                         text:(NSString*) text
                        image:(UIImage*) image
                     latitude:(NSNumber*) latitude
                    longitude:(NSNumber*) longitude
                       status:(NSNumber*) status
                   userRanking:(NSNumber*) userRanking
                     createAt:(NSDate*) createAt
                       idNews:(NSString*) idNews;


-(instancetype) initWithTitle:(NSString*) title
                         text:(NSString*) text
                        image:(UIImage*) image
                     latitude:(NSNumber*) latitude
                    longitude:(NSNumber*) longitude
                       status:(NSNumber*) status
                   userRanking:(NSNumber*) userRanking
                     createAt:(NSDate*) createAt
                       idNews:(NSString*) idNews;


-(instancetype) initWithTitle:(NSString*) title
                         text:(NSString*) text
                        image:(UIImage*) image
                     latitude:(NSNumber*) latitude
                    longitude:(NSNumber*) longitude
                       status:(NSNumber*) status
                   userRanking:(NSNumber*) userRanking;



-(instancetype) initWithDictionary:(NSDictionary *)dictionary;


-(NSDictionary*) newsAsDictionary;

-(NSDictionary*) newsAsDictionaryForInsert;

@end
