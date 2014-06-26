//
//  KeyChainLocationViewController.h
//  Key_chain
//
//  Created by Brandon Chen on 3/17/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKMapView.h>
#import <MapKit/MapKit.h>
#import "Keychain.h"

@interface KeyChainLocationViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *LocationUpdateTextLabel;
@property (weak, nonatomic) IBOutlet MKMapView *KeyChainMap;
@property (strong, nonatomic) Keychain* keychain;
@property (strong, nonatomic) CLLocationManager* locationManager;

@end
