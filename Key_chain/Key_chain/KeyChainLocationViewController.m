//
//  KeyChainLocationViewController.m
//  Key_chain
//
//  Created by Brandon Chen on 3/17/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import "KeyChainLocationViewController.h"


@interface KeyChainLocationViewController ()

@end

@implementation KeyChainLocationViewController
@synthesize LocationUpdateTextLabel;
@synthesize KeyChainMap;
@synthesize keychain;
@synthesize locationManager;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    /*if (!locationManager){
     locationManager = [[CLLocationManager alloc] init];
     locationManager.delegate = self;
     locationManager.distanceFilter = kCLDistanceFilterNone;
     locationManager.desiredAccuracy = kCLLocationAccuracyBest;
     }*/
    //[locationManager startUpdatingLocation];

    /*[self.KeyChainMap setMapType:MKMapTypeStandard];
    [self.KeyChainMap setZoomEnabled:YES];
    [self.KeyChainMap setScrollEnabled:YES];
    [self.KeyChainMap setCenterCoordinate:self.KeyChainMap.userLocation.location.coordinate animated:YES];*/
    
    if([[keychain connectionState] isEqualToString:@"Connected"]){
        self.KeyChainMap.showsUserLocation = YES;
        self.KeyChainMap.delegate = self;
    }
    
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    
    CLLocation* current_location = userLocation.location;
    
    NSLog(@"Location: %f %f\n",current_location.coordinate.latitude,current_location.coordinate.longitude);
    
    [self.KeyChainMap setRegion:[self.KeyChainMap regionThatFits:region] animated:YES];
    
    self.KeyChainMap.showsUserLocation = NO;
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations lastObject];
    
    NSLog(@"Location: %f %f\n",location.coordinate.latitude,location.coordinate.longitude);
    
    keychain.configProfile.location = location;
    
    
    
    //[self.locationManager stopUpdatingLocation];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
