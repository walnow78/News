//
//  POLAnnotation.m
//  News
//
//  Created by Pawel Walicki on 3/5/15.
//  Copyright (c) 2015 Pawel Walicki. All rights reserved.
//

#import "POLAnnotation.h"

@implementation POLAnnotation

@synthesize title, subtitle, coordinate;

- (id)initWithTitle:(NSString *)aTitle
           subtitle:(NSString*)aSubtitle
      andCoordinate:(CLLocationCoordinate2D)coord {
    
    self = [super init];
    
    title = aTitle;
    subtitle = aSubtitle;
    coordinate = coord;
    
    return self;
}

@end
