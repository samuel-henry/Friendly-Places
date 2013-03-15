//
//  FriendlyLocation.m
//  Friendly Places
//
//  Created by Sam on 3/15/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//

#import "FriendlyLocation.h"

@implementation FriendlyLocation
NSString *name;
CLLocationCoordinate2D *coordinate;

- (id)initWithName:(NSString *)name coordinate:(CLLocationCoordinate2D )coordinate {
    if (self = [super init]) {
        name = [name copy];
        coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return name;
}

@end
