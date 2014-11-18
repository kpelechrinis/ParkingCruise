//
//  ParkingCruiseViewController.m
//  ParkingCruise
//
//  Created by Konstantinos Pelechrinis on 11/17/14.
//  Copyright (c) 2014 edu.telesis. All rights reserved.
//

#import "ParkingCruiseViewController.h"

@interface ParkingCruiseViewController ()

@end

@implementation ParkingCruiseViewController{
    CLLocationManager *locationManager;
    NSString *fullTraj;
    NSString *plat;
    NSString *plon;
    NSString *ptime;
    NSString *sspeed;
    NSString *pspeed;
    NSInteger no;
    NSString *nos;
    NSString *pno;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    locationManager = [[CLLocationManager alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showEmail:(id)sender {
    // Email Subject
    NSString *emailTitle = @"Park Data Report";
    // Email Content
    NSString *messageBody=@"Type of Parking (on/off/garage): \n Final destination: \n===========\n Information for cruising start point \n===========\n Latitude: ";
    messageBody = [messageBody stringByAppendingString:_parkLat.text];
    messageBody = [messageBody stringByAppendingString:@"\n Longtitude: "];
    messageBody = [messageBody stringByAppendingString:_parkLon.text];
    messageBody = [messageBody stringByAppendingString:@"\n Speed: "];
    messageBody = [messageBody stringByAppendingString:pspeed  ];
    messageBody = [messageBody stringByAppendingString:@" m/s \n Time: "];
    messageBody = [messageBody stringByAppendingString:_parkTime.text  ];
    messageBody = [messageBody stringByAppendingString:@" \n Point number: "];
    messageBody = [messageBody stringByAppendingString:pno  ];
    messageBody = [messageBody stringByAppendingString:fullTraj];
    //NSString *messageBody = @"Type of Parking (on/off): \n Final destination: ";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"ParkingCruise@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    UIAlertView *mailConfirmAlert = [[UIAlertView alloc]
                                     initWithTitle:@"ParkingCruise" message:@"Mail Sent!" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            // Display the Mail Confirm message
            [mailConfirmAlert show];
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)getCurrentLocation:(id)sender {
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    no = -1;
    
    _parkTime.text = @"-";
    _parkLat.text = @"-";
    _parkLon.text = @"-";
    pspeed = @"-";
    pno = @"-";
    
    fullTraj = @"\n===========\n Full trajectory \n===========\n No,Time,Lat,Lon,Speed \n ";
    //[UIApplication sharedApplication].idleTimerDisabled = YES;
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    //NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d'-'MMMM'-'y 'at' HH:mm:ss"];
    
    no = no + 1;
    
    
    if (currentLocation != nil & no>0) {
        nos = [NSString stringWithFormat:@"%li", (long)no];
        _lonLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        _latLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        //_timeLabel.text = [dateFormatter stringFromDate: currentTime];
        _timeLabel.text = [dateFormatter stringFromDate: currentLocation.timestamp];
        sspeed = [NSString stringWithFormat:@"%.8f", currentLocation.speed];
        //[locationManager stopUpdatingLocation];
        // add the point to the trajectory
        fullTraj = [fullTraj stringByAppendingString: nos];
        fullTraj = [fullTraj stringByAppendingString:@","];
        fullTraj = [fullTraj stringByAppendingString:_timeLabel.text];
        fullTraj = [fullTraj stringByAppendingString:@","];
        fullTraj = [fullTraj stringByAppendingString:_latLabel.text];
        fullTraj = [fullTraj stringByAppendingString:@","];
        fullTraj = [fullTraj stringByAppendingString:_lonLabel.text];
        fullTraj = [fullTraj stringByAppendingString:@","];
        fullTraj = [fullTraj stringByAppendingString: sspeed];
        fullTraj = [fullTraj stringByAppendingString:@" m/s\n"];
        // keep track of the latest point for assigning to the park event when park button is pushed
        plat = _latLabel.text;
        plon = _lonLabel.text;
        ptime = _timeLabel.text;
        
    }
}
- (IBAction)park:(id)sender {
    _parkTime.text = ptime;
    _parkLat.text = plat;
    _parkLon.text = plon;
    pspeed = sspeed;
    pno = nos;
    
}

- (IBAction)stopTrack:(id)sender {
    [locationManager stopUpdatingLocation];
    //[UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (IBAction)resetExit:(id)sender {
    exit(0);
}

- (IBAction)aboutUS:(id)sender {
    UIAlertView *aboutUSalert = [[UIAlertView alloc]
                                 initWithTitle:@"About us" message:@"This app is part of a collaborative research project between University of Pittsburgh and Carnegie Mellon University.  For more information e-mail us at ParkingCruise@gmail.com." delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
    
    // Display the Hello World Message
    [aboutUSalert show];
}
@end
