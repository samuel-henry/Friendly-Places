//
//  ViewController.h
//  Friendly Places
//
//  Created by Sam on 3/2/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//
//  Description:    Main view controller. Handles FB authorization, FB data retrieval,
//                  and map view population.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
- (IBAction)loginClicked:(UIButton *)sender;
- (IBAction)getDataClicked:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CLLocationManager *locationManager;
- (IBAction)loginNavButtonTapped:(id)sender;
- (IBAction)getCheckinsNavButtonTapped:(id)sender;



@end
