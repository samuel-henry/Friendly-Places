//
//  MKPointAnnotationLocation.h
//  Friendly Places
//
//  Created by Sam on 3/21/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//
//  Description: Adds a website property to a MKPointAnnotation
//

#import <MapKit/MapKit.h>

@interface MKPointAnnotationLocation : MKPointAnnotation
@property (weak, nonatomic) NSString *website;

@end
