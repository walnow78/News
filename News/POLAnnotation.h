//
//  POLAnnotation.h
//  News
//
//  Created by Pawel Walicki on 3/5/15.
//  Copyright (c) 2015 Pawel Walicki. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface POLAnnotation : NSObject <MKAnnotation> {

NSString *title;
NSString *subtitle;
CLLocationCoordinate2D coordinate;

}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)aTitle
           subtitle:(NSString*)aSubtitle
      andCoordinate:(CLLocationCoordinate2D)coord;

@end
