//
//  KeyChainSettingViewController.m
//  Key_chain
//
//  Created by Brandon Chen on 3/5/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import "KeyChainSettingViewController.h"
#import "BLECentralSingleton.h"
#import "Keychain.h"
#import "KeychainProfile.h"
#import "Sprintron_Utility.h"
#import "CameraViewController.h"

@interface KeyChainSettingViewController ()

@end

@implementation KeyChainSettingViewController

@synthesize name_input_from_ui;
@synthesize disconnection_alert_setting_from_ui;
@synthesize out_of_range_alert_setting_from_ui;
@synthesize threshold_setting_from_ui;
@synthesize sprintron_peripheral;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"KeyChainSettingDone"]) {
        
        // get all the infos from UI input.
        NSString* name = name_input_from_ui.text;
        NSInteger threshold = self.threshold_setting_from_ui.selectedSegmentIndex;
        NSData* bd_addr = [self.sprintron_peripheral.advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey];
        BOOL out_of_range_alert_on = self.out_of_range_alert_setting_from_ui.on;
        BOOL disconnection_alert_on = self.disconnection_alert_setting_from_ui.on;

        // Create the image file name from keychain profile name.
        NSString *imageFileName = [NSString stringWithFormat:@"%@%@", name, @".png"];
        
        // Create config profile for key chain
        KeychainProfile *profile = [[KeychainProfile alloc] initWithName:name andthreshold:threshold andBDaddr:bd_addr andOutofRangeAlert:out_of_range_alert_on andDisconnectionAlert:disconnection_alert_on andImageName:imageFileName];
        
        // Create key chain instance
        Keychain *keychain = [[Keychain alloc] initWithKeyProfile:profile andPeripheral:sprintron_peripheral.peripheral];
        
        // Add new key chain to list.
        [BLECentralSingleton addObjectToBLERegistered_peripheral_list:keychain];
        
        // Save image to Document path.
        [keychain saveimage:self.keychainImage.image imageName:imageFileName];
        
        // Start RSSI Reading.
        [keychain init_notification];
        
        // Read remote TX Power.
        [keychain read_remote_TX_power];
        
        // Connection update to 1s interval.
        [keychain connection_updateWithdata:[Sprintron_Utility stringToHexData:@"2003f40100002000c800"]];
        
        // Save image to keychain profile.
        keychain.image = self.keychainImage.image;
        
        
    }
    else if ([[segue identifier] isEqualToString:@"TakePix"]) {
        CameraViewController* camviewcontroller =[segue destinationViewController];
        camviewcontroller.key_chain_setting_controller = self;
        
    }
}




@end
