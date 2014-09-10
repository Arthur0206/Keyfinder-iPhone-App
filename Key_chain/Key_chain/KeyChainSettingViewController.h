//
//  KeyChainSettingViewController.h
//  Key_chain
//
//  Created by Brandon Chen on 3/5/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "SprintronCBPeripheral.h"

@interface KeyChainSettingViewController : UITableViewController 

@property (weak, nonatomic) IBOutlet UIImageView *keychainImage;


@property (weak, nonatomic) IBOutlet UITextField *name_input_from_ui;
@property (weak, nonatomic) IBOutlet UISwitch *disconnection_alert_setting_from_ui;
@property (weak, nonatomic) IBOutlet UISwitch *out_of_range_alert_setting_from_ui;
@property (weak, nonatomic) IBOutlet UISegmentedControl *threshold_setting_from_ui;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) SprintronCBPeripheral* sprintron_peripheral;
@end
