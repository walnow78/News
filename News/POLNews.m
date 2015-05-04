//
//  POLNews.m
//  News
//
//  Created by Pawel Walicki on 30/4/15.
//  Copyright (c) 2015 Pawel Walicki. All rights reserved.
//

#import "POLNews.h"

@implementation POLNews

+(instancetype) newsWithTitle:(NSString*) title
                         text:(NSString*) text
                        image:(UIImage*) image
                     latitude:(NSNumber*) latitude
                    longitude:(NSNumber*) longitude
                       status:(NSNumber*) status
                   userRanking:(NSNumber*) userRanking
                     createAt:(NSDate*) createAt
                       idNews:(NSString*) idNews{
    
    return [[POLNews alloc] initWithTitle:title
                                     text:text
                                    image:image
                                 latitude:latitude
                                longitude:longitude
                                   status:status
                               userRanking:userRanking
                                 createAt:createAt
                                   idNews:idNews];
    
}



-(instancetype) initWithTitle:(NSString*) title
                         text:(NSString*) text
                        image:(UIImage*) image
                     latitude:(NSNumber*) latitude
                    longitude:(NSNumber*) longitude
                       status:(NSNumber*) status
                   userRanking:(NSNumber*) userRanking
                     createAt:(NSDate*) createAt
                       idNews:(NSString*) idNews{
    
    if (self = [super init]) {
        
        _title = title;
        _text = text;
        _image = image;
        _latitude = latitude;
        _longitude = longitude;
        _status = status;
        _userRanking = userRanking;
        _createAt = createAt;
        _idNews = idNews;
    }
    
    return self;
    
}


-(instancetype) initWithTitle:(NSString*) title
                         text:(NSString*) text
                        image:(UIImage*) image
                     latitude:(NSNumber*) latitude
                    longitude:(NSNumber*) longitude
                       status:(NSNumber*) status
                   userRanking:(NSNumber*) userRanking{
    
    return [self initWithTitle:title
                          text:text
                         image:image
                      latitude:latitude
                     longitude:longitude
                        status:status
                    userRanking:userRanking
                      createAt:nil
                        idNews:nil];
}





#pragma mark - Utils

-(NSDictionary*) newsAsDictionary{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [ud objectForKey:@"userId"];
    
    NSDictionary *dic = @{@"title" : self.title,
                          @"text" : self.text,
                          @"latitude2" : self.latitude,
                          @"longitude2" : self.longitude,
                          @"status" : self.status,
                          @"author" : userId,
                          @"id" : self.idNews};
    
    return dic;
    
}

-(NSDictionary*) newsAsDictionaryForInsert{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [ud objectForKey:@"userId"];
    
    NSDictionary *dic = @{@"title" : self.title,
                          @"text" : self.text,
                          @"latitude2" : self.latitude,
                          @"longitude2" : self.longitude,
                          @"status" : self.status,
                          @"author" : userId};
    
    return dic;
    
}

-(instancetype) initWithDictionary:(NSDictionary *)dic{
    
    return [self initWithTitle:[dic objectForKey:@"title"]
                          text:[dic objectForKey:@"text"]
                         image:nil
                      latitude:[dic objectForKey:@"latitude2"]
                     longitude:[dic objectForKey:@"longitude2"]
                        status:[dic objectForKey:@"status"]
                    userRanking:[dic objectForKey:@"userRanking"]
                      createAt:[dic objectForKey:@"__createdAt"]
                        idNews:[dic objectForKey:@"id"]
            ];
    
}



@end
