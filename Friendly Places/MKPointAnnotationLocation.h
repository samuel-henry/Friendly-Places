//
//  MKPointAnnotationLocation.h
//  Friendly Places
//
//  Created by Sam on 3/21/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKPointAnnotationLocation : MKPointAnnotation
@property (weak, nonatomic) NSString *description;
@property (weak, nonatomic) NSString *phone;
@property (weak, nonatomic) NSString *street;
@property (weak, nonatomic) NSString *website;
@end
