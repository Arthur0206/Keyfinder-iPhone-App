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

@interface KeyChainDetailViewController : UITableViewController <CLLocationManagerDelegate,UITableViewDelegate,KeychainDelegate>
@property(strong,nonatomic) Keychain *keychain;
@property (weak, nonatomic) IBOutlet UISwitch *FindMe;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak) NSTimer *repeatingTimer;
@property (strong, nonatomic) UIActivityIndicatorView *actView;
@property (strong, nonatomic) CLLocationManager *locationManager;
- (IBAction) press_findme:(id)sender;
- (IBAction)out_of_rang_alert_switch:(id)sender;
- (IBAction)alert_threshold_change:(id)sender;
- (IBAction)disconnection_alert_switch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *find_me_button;
@property (weak, nonatomic) IBOutlet UISwitch *out_of_range_alert_from_ui;
@property (weak, nonatomic) IBOutlet UISegmentedControl *alert_threshold_from_ui;
@property (weak, nonatomic) IBOutlet UISwitch *disconnection_alert_from_ui;
@property (weak, nonatomic) IBOutlet UILabel *status_label;
@property (weak, nonatomic) IBOutlet UILabel *rssi_label;
@property (weak, nonatomic) IBOutlet UILabel *name_label;
@property (weak, nonatomic) IBOutlet UILabel *key_rssi_label;
@property (weak, nonatomic) IBOutlet UILabel *filtered_rssi_label;
@end
