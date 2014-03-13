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

#pragma mark - Table view data source



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

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

        
        // Create config progile for key chain
        KeychainProfile *profile = [[KeychainProfile alloc] initWithName:name andthreshold:threshold andBDaddr:bd_addr andOutofRangeAlert:out_of_range_alert_on andDisconnectionAlert:disconnection_alert_on];
        
        // Create key chain instance
        Keychain *keychain = [[Keychain alloc] initWithKeyProfile:profile andPeripheral:sprintron_peripheral.peripheral];
        
        // Add new key chain to list.
        [BLECentralSingleton addObjectToBLERegistered_peripheral_list:keychain];
        
        // Start RSSI Reading.
        [keychain set_notification];
        
        // Read remote TX Power.
        [keychain read_remote_TX_power];
        
        // Connection update to 1s interval.
        [keychain connection_updateWithdata:[Sprintron_Utility stringToHexData:@"2003f40100002000c800"]];
        
    }
}


@end
