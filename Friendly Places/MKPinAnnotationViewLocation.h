//
//  MKPinAnnotationViewLocation.h
//  Friendly Places
//
//  Created by Sam on 3/20/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//
//  Description: Adds a website property to a MKPointAnnotationView
//

#import <MapKit/MapKit.h>

@interface MKPinAnnotationViewLocation : MKPinAnnotationView
@property (weak, nonatomic) NSString *website;
@end
