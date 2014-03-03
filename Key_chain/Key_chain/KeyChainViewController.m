//
//  KeyChainViewController.m
//  Key_chain
//
//  Created by Brandon Chen on 1/8/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import "KeyChainViewController.h"
#import "BLECentralSingleton.h"
#import "KeyChainDetailViewController.h"
#import <Foundation/NSKeyedArchiver.h>

@interface KeyChainViewController ()



@end

@implementation KeyChainViewController

@synthesize BLECentralManager;
@synthesize registerList;
@synthesize Connected_Peripheral_list;
@synthesize Peripheral_list;
@synthesize repeatingTimer;
//@synthesize locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    registerList = [BLECentralSingleton getBLERegistered_peripheral_list];
    [self.tableView reloadData]; // to reload selected cell

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

 
    BLECentralManager = [BLECentralSingleton getBLECentral];
    BLECentralManager.delegate = self;
    Peripheral_list = [BLECentralSingleton getBLEPeripheral_list];
    Connected_Peripheral_list = [BLECentralSingleton getBLEConnected_peripheral_list];
    
    
    //load the array
    
    registerList = [BLECentralSingleton getBLERegistered_peripheral_list];
    
    // Do any additional setup after loading the view.
    [self startRepeatingTimer];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /*
     When a row is selected, the segue creates the detail view controller as the destination.
     Set the detail view controller's detail item to the item associated with the selected row.
     */
    if ([[segue identifier] isEqualToString:@"ToKeyChainDetail"]) {
        
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        KeyChainDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.keychain = [registerList objectAtIndex:selectedRowIndex.row];
    }
}


-(void)startRepeatingTimer{
    
    // Cancel a preexisting timer.
    [self.repeatingTimer invalidate];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self selector:@selector(targetMethod:)
                                                    userInfo:[self userInfo] repeats:YES];
    self.repeatingTimer = timer;
}


- (NSDictionary *)userInfo {
    
    return @{ @"StartDate" : [NSDate date] };
}

- (void)targetMethod:(NSTimer*)theTimer {
    NSDate *startDate = [[theTimer userInfo] objectForKey:@"StartDate"];
    //    NSLog(@"Timer started on %@", startDate);
    //    NSLog(@"Read RSSI from connected Peripheral");
    
    for(Keychain* key in registerList){
        key.peripheral.delegate =self;
        [key.peripheral readRSSI];
        
    }

    
}

- (void)invocationMethod:(NSDate *)date {
    //    NSLog(@"Invocation for timer started on %@", date);
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    
    for(Keychain* keychain in registerList){
        if (keychain.connection_state == CONNECTED){
            if( [keychain.peripheral.RSSI intValue] < keychain.threshold && keychain.range_state < RED_ALERT) {
                [keychain alert:@"out of range"];
                keychain.range_state = RED_ALERT;
            }
            else if( keychain.range_state == RED_ALERT && [keychain.peripheral.RSSI intValue] > keychain.threshold+10)
            {
                keychain.range_state = NO_ALERT;
            }
        }
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [registerList count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell==nil){
        
        cell = [ [UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    Keychain *keychain = [registerList objectAtIndex:indexPath.row];
    
    
    
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:1];
    
    label.text = keychain.peripheral.name;
    
    
    return cell;
    
}

- (void) startNotifyingForServiceUUID:(NSString *) serviceUUID andCharacteristicUUID:(NSString *) charUUID Peripheral:(CBPeripheral*) peripheral
{
	CBCharacteristic *characteristic = [self findCharacteristicWithServiceUUID:serviceUUID andCharacteristicUUID:charUUID Peripheral:peripheral];
	if (characteristic)
	{
		[peripheral setNotifyValue:YES forCharacteristic:characteristic];
	}
}

- (CBCharacteristic *) findCharacteristicWithServiceUUID:(NSString *) serviceUUID andCharacteristicUUID:(NSString *) charUUID Peripheral:(CBPeripheral*) peripheral
{
    for (CBService *service in [peripheral services])
	{
        if ([[service UUID] isEqual:[CBUUID UUIDWithString:serviceUUID]] )
		{
            for (CBCharacteristic *characteristic in [service characteristics])
			{
                if ( [[characteristic UUID] isEqual:[CBUUID UUIDWithString:charUUID]] )
				{
					return characteristic;
                }
            }
        }
    }
    
	return nil;
}



- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"Peripheral %@ connected",[peripheral.identifier UUIDString]);
    


    
    [self startNotifyingForServiceUUID:@"0xFFF1" andCharacteristicUUID:@"0xFFF2" Peripheral:peripheral];
    
    [Connected_Peripheral_list addObject:peripheral];
    
    NSInteger idx = [Peripheral_list indexOfObject:peripheral];
    
    if (idx != NSNotFound)
        [Peripheral_list removeObjectAtIndex:idx];
    
    
    
    Keychain *key;
    
    for(Keychain* keychain in registerList){
        if (keychain.peripheral == peripheral)
            goto SKIP;
    }
    key = [[Keychain alloc] init];
    key.configProfile = [[KeychainProfile alloc] initWithName:peripheral.name];
    key.peripheral = peripheral;
                         
    [registerList addObject:key];
SKIP:
    
    peripheral.delegate = self;
    [peripheral discoverServices:nil];

    
}

- (void)centralManager:(CBCentralManager *)central
didDisconnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error {
    
    NSLog(@"####%@ disconnected#####",peripheral.name);
    NSInteger idx = [Connected_Peripheral_list indexOfObject:peripheral];
    [Connected_Peripheral_list removeObject:peripheral];
    
    for(Keychain* key in registerList) {
        if (key.peripheral == peripheral){
            key.connection_state = NOT_CONNECTED;
//            [key alert:@"Disconnected"];
            
            NSDictionary* options = @{CBConnectPeripheralOptionNotifyOnConnectionKey: @YES,
                                      CBConnectPeripheralOptionNotifyOnDisconnectionKey: @YES,
                                      CBConnectPeripheralOptionNotifyOnNotificationKey: @YES};
            
            [BLECentralManager connectPeripheral:peripheral options: options];

            [BLECentralManager connectPeripheral:peripheral options:nil];
        }
    }
    
}


- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    // NSLog(@"Discovered %@ %@ %@", peripheral.name, peripheral.identifier, advertisementData);
    NSLog(@"Discovered %@", RSSI.stringValue);
    
    NSUInteger objIdx = [Peripheral_list indexOfObject: peripheral];
    if (objIdx == NSNotFound) {
        [Peripheral_list addObject:peripheral];
    }
    
}



- (void) centralManager:(CBCentralManager *)central
didRetrieveConnectedPeripherals:(NSArray *)peripherals {
    NSLog(@"Currently connected peripherals :");
    int i = 0;
    for(CBPeripheral *peripheral in peripherals) {
        NSLog(@"[%d] - peripheral : %@ with UUID : %@",i,peripheral,peripheral.UUID);
        //Do something on each connected peripheral.
    }
}

- (void) centralManager:(CBCentralManager *)central
 didRetrievePeripherals:(NSArray *)peripherals {
    NSLog(@"Currently known peripherals :");
    int i = 0;
    for(CBPeripheral *peripheral in peripherals) {
        NSLog(@"[%d] - peripheral : %@ with UUID : %@",i,peripheral,peripheral.UUID);
        //Do something on each known peripheral.
    }
}





- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    //self.cBReady = false;
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CoreBluetooth BLE hardware is powered off");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
            //self.cBReady = true;
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CoreBluetooth BLE hardware is resetting");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CoreBluetooth BLE state is unauthorized");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"CoreBluetooth BLE state is unknown");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
            break;
        default:
            break;
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"%@ has services:\n",peripheral.name);
    for(CBService * service in peripheral.services) {
        
        NSLog(@"%@ \n",service.UUID);
        peripheral.delegate = self;
        
        
        //[peripheral discoverCharacteristics:[NSArray arrayWithObjects:[CBUUID UUIDWithString:@"0xfff6"], nil] forService:service];
        
        
        
        
        
        
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"This service: %@  has those characteristics:\n", service.UUID);
    for(CBCharacteristic* characteristic in service.characteristics)
    {
        NSLog(@"%@ \n",characteristic.UUID);
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //[peripheral setNotifyValue:YES forCharacteristic:]
    
}



@end
