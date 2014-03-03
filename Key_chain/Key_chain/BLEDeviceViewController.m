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
#import "CoreBluetooth/CBService.h"
#import "CoreBluetooth/CBCharacteristic.h"
#import "CoreBluetooth/CBUUID.h"


@interface BLEDeviceViewController ()

@end

@implementation BLEDeviceViewController

@synthesize BLECentralManager;
@synthesize Peripheral_list;
//@synthesize Peripheral_cell_list;
@synthesize Connected_Peripheral_list;
//@synthesize Connected_Peripheral_cell_list;
@synthesize BLEPeripheral;
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
    [BLECentralManager scanForPeripheralsWithServices:nil options:nil];
 

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 1)
        return [Peripheral_list count];
    else if(section == 0)
        return [Connected_Peripheral_list count];
    
    return 0;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    if (section == 1)
        return @"Discovered Devices";
    else if (section == 0)
        return @"Connected Devices";
    else
        return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CBPeripheral *tmp_peripheral;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell==nil){
        
        cell = [ [UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
 
    if (indexPath.section == 0){
        tmp_peripheral = [Connected_Peripheral_list objectAtIndex:indexPath.row];

    }
    else {
       // Configure the cell...
        tmp_peripheral = [Peripheral_list objectAtIndex:indexPath.row];

    }
    
    UILabel *label;
        
    label = (UILabel *)[cell viewWithTag:1];
    
    label.text = tmp_peripheral.name;
    
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
        // Scanned list.
        // Select a device to connect.
        
        CBPeripheral *peripheral = [Peripheral_list objectAtIndex:indexPath.row];
       
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        // make connection.
        peripheral.delegate = self;
        
        NSDictionary* options = @{CBConnectPeripheralOptionNotifyOnConnectionKey: @YES,
                                  CBConnectPeripheralOptionNotifyOnDisconnectionKey: @YES,
                                  CBConnectPeripheralOptionNotifyOnNotificationKey: @YES};
        
        [BLECentralManager cancelPeripheralConnection:peripheral];
        [BLECentralManager connectPeripheral:peripheral options: options];
        NSLog(@"Start connecting");

        // deselect the cell after doing connection
        [tableView deselectRowAtIndexPath:indexPath animated:false];
    }
    
}


@end







