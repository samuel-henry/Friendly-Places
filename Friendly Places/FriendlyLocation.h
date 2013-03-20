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
@property (strong, nonatomic) NSString* fb_about;
@property (strong, nonatomic) NSString* fb_description;
@property (strong, nonatomic) NSString* phone;
@property (strong, nonatomic) NSString* street;
@property (strong, nonatomic) NSString* website;
@property (strong, nonatomic) NSSet* checkers;

- (id)initWithName:(NSString*)name coordinate:(CLLocationCoordinate2D)coordinate;

@end
