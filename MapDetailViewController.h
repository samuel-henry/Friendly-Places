//
//  MapDetailViewController.h
//  Friendly Places
//
//  Created by Sam on 3/20/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface MapDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) NSString *fb_page_id;
@property (weak, nonatomic) NSString *name;
@property (weak, nonatomic) NSString *description;
@property (weak, nonatomic) NSString *phone;
@property (weak, nonatomic) NSString *website;
@property (weak, nonatomic) NSString *street;
@property (weak, nonatomic) NSNumber *latitude;
@property (weak, nonatomic) NSNumber *longitude;

@end
