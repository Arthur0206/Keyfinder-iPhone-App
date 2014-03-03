//
//  KeyChainDetailViewController.h
//  Key_chain
//
//  Created by Brandon Chen on 2/15/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Keychain.h"

@interface KeyChainDetailViewController : UIViewController <CLLocationManagerDelegate>
@property(strong,nonatomic) Keychain *keychain;
@property (weak, nonatomic) IBOutlet UISwitch *FindMe;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak) NSTimer *repeatingTimer;
@property (strong, nonatomic) CLLocationManager *locationManager;
-(IBAction) press_findme:(id)sender;


@end
