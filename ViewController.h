//
//  ViewController.h
//  Friendly Places
//
//  Created by Sam on 3/2/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
- (IBAction)loginClicked:(UIButton *)sender;
- (IBAction)getDataClicked:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;



@end
