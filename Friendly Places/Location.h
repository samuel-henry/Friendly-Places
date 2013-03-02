//
//  Location.h
//  Friendly Places
//
//  Created by Sam on 3/2/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Friend;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSNumber * city;
@property (nonatomic, retain) NSNumber * country;
@property (nonatomic, retain) NSString * fb_about;
@property (nonatomic, retain) id fb_categories;
@property (nonatomic, retain) NSNumber * fb_checkins;
@property (nonatomic, retain) NSString * fb_description;
@property (nonatomic, retain) NSNumber * fb_fan_count;
@property (nonatomic, retain) NSNumber * fb_is_published;
@property (nonatomic, retain) NSNumber * fb_page_id;
@property (nonatomic, retain) NSString * fb_pic_square;
@property (nonatomic, retain) NSNumber * fb_were_here_count;
@property (nonatomic, retain) id hours;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSSet *checkers;
@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addCheckersObject:(Friend *)value;
- (void)removeCheckersObject:(Friend *)value;
- (void)addCheckers:(NSSet *)values;
- (void)removeCheckers:(NSSet *)values;

@end
