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
        // get the name from input.
        NSString* name = name_input_from_ui.text;
        NSInteger threshold = self.threshold_setting_from_ui.selectedSegmentIndex;
        
        KeychainProfile *key_profile = [[KeychainProfile alloc] initWithName:name andthreshold: threshold andBDaddr:[self.sprintron_peripheral.advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey]];
        for(Keychain* key_chain in [BLECentralSingleton getBLERegistered_peripheral_list]){
            if (key_chain.peripheral == sprintron_peripheral.peripheral){
                key_chain.configProfile = key_profile;
                //key_chain.connection_state = CONNECTED;
                key_chain.configProfile.out_of_range_alert = self.out_of_range_alert_setting_from_ui.on;
                key_chain.configProfile.threshold = self.threshold_setting_from_ui.selectedSegmentIndex;
                key_chain.configProfile.disconnection_alert = self.disconnection_alert_setting_from_ui.on;
                [key_chain set_notification];
                [key_chain read_connectionParams];
                break;
            }
        }
    }
}


@end
