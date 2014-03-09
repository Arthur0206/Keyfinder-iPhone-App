//
//  BLEDeviceViewController.m
//  Key_chain
//
//  Created by Brandon Chen on 1/8/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import "BLEDeviceViewController.h"
#import "BLECentralSingleton.h"
#import <AVFoundation/AVFoundation.h>
#import "Keychain.h"
#import "KeyChainSettingViewController.h"
#import "CoreBluetooth/CBService.h"
#import "CoreBluetooth/CBCharacteristic.h"
#import "CoreBluetooth/CBUUID.h"


@interface BLEDeviceViewController ()

@end

@implementation BLEDeviceViewController

@synthesize BLECentralManager;
@synthesize Peripheral_list;
@synthesize Connected_Peripheral_list;
@synthesize repeatingTimer;
@synthesize DeviceTableView;
@synthesize registeredPeripherallist;

UITableViewCell *connecting_cell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    BLECentralManager = [BLECentralSingleton getBLECentral];
    Peripheral_list = [BLECentralSingleton getBLEPeripheral_list];
    [Peripheral_list removeAllObjects];
    Connected_Peripheral_list = [BLECentralSingleton getBLEConnected_peripheral_list];
    registeredPeripherallist = [BLECentralSingleton getBLERegistered_peripheral_list];
    
    // Start timer.
    [self startRepeatingTimer];
    
    // Start scan.
    [BLECentralManager scanForPeripheralsWithServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"0xffa1"]] options:nil];
 

}

-(void)startRepeatingTimer{
    
    // Cancel a preexisting timer.
    [self.repeatingTimer invalidate];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                      target:self selector:@selector(targetMethod:)
                                                    userInfo:[self userInfo] repeats:YES];
    self.repeatingTimer = timer;
}


- (NSDictionary *)userInfo {
    
    return @{ @"StartDate" : [NSDate date] };
}

- (void)targetMethod:(NSTimer*)theTimer {
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [Peripheral_list count];


}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    return @"Discovered Devices";
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell==nil){
        
        cell = [ [UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
 

    SprintronCBPeripheral* sprintron_peripheral = [Peripheral_list objectAtIndex:indexPath.row];

    
    UILabel *label;
        
    label = (UILabel *)[cell viewWithTag:1];
    
    if ([sprintron_peripheral.peripheral.name length] >0){
        label.text = sprintron_peripheral.peripheral.name;
    }
    else {
        label.text = @"~~~No Name~~~~";
    }
    
    
    return cell;

}


/*- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"Peripheral %@ connected",[peripheral.identifier UUIDString]);
    NSInteger idx;
    
    //NSMutableArray* registerList = [BLECentralSingleton getBLERegistered_peripheral_list];
    
    [peripheral discoverServices:nil];
    
    
    
    for(SprintronCBPeripheral* sprintron_peripheral in Peripheral_list) {
        if (sprintron_peripheral.peripheral == peripheral)
        {
            idx = [Peripheral_list indexOfObject:sprintron_peripheral];
            break;
        }
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
    
    
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *) [cell viewWithTag:4];
    [activityIndicator stopAnimating];


}*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Scanned list.
    // Select a device to connect.
    
    SprintronCBPeripheral *sprintron_peripheral = [Peripheral_list objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    // make connection.
    //sprintron_peripheral.peripheral.delegate = self;
    
    NSDictionary* options = @{CBConnectPeripheralOptionNotifyOnConnectionKey: @YES,
                              CBConnectPeripheralOptionNotifyOnDisconnectionKey: @YES,
                              CBConnectPeripheralOptionNotifyOnNotificationKey: @YES};
 
    [BLECentralManager cancelPeripheralConnection:sprintron_peripheral.peripheral];
    [BLECentralManager connectPeripheral:sprintron_peripheral.peripheral options: options];
    NSLog(@"Start connecting");
    
    
   /* UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *) [cell viewWithTag:4];
    [activityIndicator startAnimating];*/
    
    
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"scan_to_setting"]) {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        KeyChainSettingViewController *settingViewController = [segue destinationViewController];
        settingViewController.sprintron_peripheral = [Peripheral_list objectAtIndex:selectedRowIndex.row];
        // deselect the cell after doing connection
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRowIndex.row inSection:0] animated:false];

    }
    
    
}


@end







