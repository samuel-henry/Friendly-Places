//
//  Checkin.h
//  Friendly Places
//
//  Created by Sam on 3/2/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Checkin : NSManagedObject

@property (nonatomic, retain) NSNumber * fb_checkin_id;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSManagedObject *checkin_location;

@end
