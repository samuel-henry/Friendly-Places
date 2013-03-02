//
//  Friend.h
//  Friendly Places
//
//  Created by Sam on 3/2/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Checkin;

@interface Friend : NSManagedObject

@property (nonatomic, retain) NSNumber * fb_id;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSSet *checked_in;
@end

@interface Friend (CoreDataGeneratedAccessors)

- (void)addChecked_inObject:(Checkin *)value;
- (void)removeChecked_inObject:(Checkin *)value;
- (void)addChecked_in:(NSSet *)values;
- (void)removeChecked_in:(NSSet *)values;

@end
