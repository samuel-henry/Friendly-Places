//
//  FriendlyLocation.h
//  Friendly Places
//
//  Created by Sam on 3/15/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FriendlyLocation : NSObject <MKAnnotation>
@property (strong, nonatomic) NSString *name;

- (id)initWithName:(NSString*)name coordinate:(CLLocationCoordinate2D)coordinate;

@end
