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
@synthesize activityIndicator;

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
    BLECentralManager.delegate = self;
    Peripheral_list = [BLECentralSingleton getBLEPeripheral_list];
    [Peripheral_list removeAllObjects];
    registeredPeripherallist = [BLECentralSingleton getBLERegistered_peripheral_list];
    
    // Start scan.
    [BLECentralManager stopScan];
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
    
    //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    activityIndicator = (UIActivityIndicatorView *) [cell viewWithTag:4];
    [activityIndicator startAnimating];
    
    
}

- (void)centralManager:(CBCentralManager *)central
 didConnectPeripheral:(CBPeripheral *)peripheral {
 
    NSLog(@"Peripheral %@ connected",[peripheral.identifier UUIDString]);
    peripheral.delegate = self;
    [peripheral discoverServices:[NSArray arrayWithObjects:[CBUUID UUIDWithString:@"0xffa1"],[CBUUID UUIDWithString:@"0xffa5"],[CBUUID UUIDWithString:@"0xffa6"],nil ]];

}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discovered %@ %@ %@", peripheral.name, peripheral.identifier, advertisementData);
    NSLog(@"Discovered %@", RSSI.stringValue);
    
    // check if this is being discovered already.
    for(SprintronCBPeripheral* sprintron_peripheral in Peripheral_list){
        if (sprintron_peripheral.peripheral == peripheral){
            return;
        }
    }
    
    // If this is in scan list, than skip it.
    for (Keychain* key in registeredPeripherallist){
        if ([key.configProfile.BDaddress isEqual:[advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey]]) {
            return;
        }
    }
    
    SprintronCBPeripheral* sprintron_peripheral = [SprintronCBPeripheral alloc];
    sprintron_peripheral.peripheral = peripheral;
    sprintron_peripheral.advertisementData = advertisementData;
    [Peripheral_list addObject:sprintron_peripheral];
 
    [self.tableView reloadData];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"%@ has services:\n",peripheral.name);
    for(CBService * service in peripheral.services) {
        
        NSLog(@"%@ \n",service.UUID);
        peripheral.delegate = self;;
        [peripheral discoverCharacteristics:nil forService:service];
    }
    
    [activityIndicator stopAnimating];
    [self performSegueWithIdentifier:@"BLEScanToSetting" sender:self];
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
   
    for(CBCharacteristic* characteristic in service.characteristics)
    {
         NSLog(@"Service: %@  Characteristics: %@\n",service.UUID.data, characteristic.UUID.data);
        [peripheral discoverDescriptorsForCharacteristic:characteristic];
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    for(CBDescriptor* descriptor in characteristic.descriptors) {
        NSLog(@"Characteristics: %@ descriptor:%@ \n",characteristic.UUID.data,descriptor.UUID.data);
    }
    
}

- (void) done_alert{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.4];
    localNotification.alertAction = NSLocalizedString(@"View Details", nil);
    localNotification.alertBody = [NSString stringWithFormat:@"Connection Successful"];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    	
    [[UIApplication sharedApplication] 	presentLocalNotificationNow:localNotification];
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"BLEScanToSetting"]) {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        KeyChainSettingViewController *settingViewController = [segue destinationViewController];
        settingViewController.sprintron_peripheral = [Peripheral_list objectAtIndex:selectedRowIndex.row];
        // deselect the cell after doing connection
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRowIndex.row inSection:0] animated:false];

    }
    
}


@end







