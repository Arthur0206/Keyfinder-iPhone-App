//
//  KeyChainDetailViewController.m
//  Key_chain
//
//  Created by Brandon Chen on 2/15/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import "KeyChainDetailViewController.h"
#import "Conn_params_ViewController.h"

@interface KeyChainDetailViewController ()

@end

@implementation KeyChainDetailViewController

@synthesize keychain;
@synthesize repeatingTimer;
@synthesize map;
@synthesize locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.repeatingTimer invalidate];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.name_label.text = keychain.configProfile.name;//@"key";//keychain.peripheral.name;
    self.out_of_range_alert_from_ui.on = keychain.out_of_range_alert;
    self.disconnection_alert_from_ui.on = keychain.disconnection_alert;
    self.status_label.text = keychain.connection_state?@"CONNECTED":@"NOT CONNECTED";
    self.rssi_label.text = [keychain.peripheral.RSSI stringValue];

    [self startRepeatingTimer];
    
 /*   if (!locationManager){
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    [locationManager startUpdatingLocation];*/
    
    map.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startRepeatingTimer{
    
    // Cancel a preexisting timer.
    [self.repeatingTimer invalidate];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:self selector:@selector(targetMethod:)
                                                    userInfo:[self userInfo] repeats:YES];
    self.repeatingTimer = timer;
}


- (NSDictionary *)userInfo {
    
    return @{ @"StartDate" : [NSDate date] };
}

- (void)targetMethod:(NSTimer*)theTimer {
    //NSDate *startDate = [[theTimer userInfo] objectForKey:@"StartDate"];
    //NSLog(@"Timer started on %@", startDate);
    //    NSLog(@"Read RSSI from connected Peripheral");
    
    self.status_label.text = keychain.connection_state?@"CONNECTED":@"NOT CONNECTED";
    self.rssi_label.text = [keychain.peripheral.RSSI stringValue];

    //keychain.peripheral.delegate = self;
    //[keychain.peripheral readRSSI];
    

}

- (void)invocationMethod:(NSDate *)date {
    //    NSLog(@"Invocation for timer started on %@", date);
}

-(IBAction) press_findme:(id)sender {
    
    
    [keychain find_key:1];
 
    [keychain find_key:0];

        
}

- (IBAction)out_of_rang_alert_switch:(id)sender {
    keychain.out_of_range_alert = self.out_of_range_alert_from_ui.on;
}

- (IBAction)alert_threshold_change:(id)sender {
    keychain.threshold = self.alert_threshold_from_ui.selectedSegmentIndex;
}

- (IBAction)disconnection_alert_switch:(id)sender {
    keychain.disconnection_alert = self.disconnection_alert_from_ui.on;
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    
    [map setRegion:[map regionThatFits:region] animated:YES];
    

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations lastObject];
    
    NSLog(@"Location: %f %f\n",location.coordinate.latitude,location.coordinate.longitude);
    
    keychain.location = location;

    
    [self.locationManager stopUpdatingLocation];
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([[segue identifier] isEqualToString:@"detailToConnParams"]) {
        Conn_params_ViewController* controller = [segue destinationViewController];
        controller.keychain = keychain;
    }
}

@end
