//
//  ParkingCruiseViewController.h
//  ParkingCruise
//
//  Created by Konstantinos Pelechrinis on 11/17/14.
//  Copyright (c) 2014 edu.telesis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h>

@interface ParkingCruiseViewController : UIViewController <MFMailComposeViewControllerDelegate,CLLocationManagerDelegate> // Add the delegate
- (IBAction)showEmail:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *latLabel;
@property (weak, nonatomic) IBOutlet UILabel *lonLabel;
- (IBAction)getCurrentLocation:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkTime;
@property (weak, nonatomic) IBOutlet UILabel *cruisingDistance;
- (IBAction)park:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *parkLat;
@property (weak, nonatomic) IBOutlet UILabel *parkLon;
- (IBAction)stopTrack:(id)sender;
- (IBAction)resetExit:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *distanceDriven;
- (IBAction)aboutUS:(id)sender;
@end
