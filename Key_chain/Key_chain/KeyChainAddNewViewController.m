//
//  KeyChainAddNewViewController.m
//  Key_chain
//
//  Created by Brandon Chen on 6/20/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import "BLECentralSingleton.h"
#import "KeyChainAddNewViewController.h"
#import "Keychain.h"
#import "KeyChainSettingViewController.h"

@interface KeyChainAddNewViewController ()

@end

@implementation KeyChainAddNewViewController

@synthesize BLECentralManager;
@synthesize Peripheral_list;
@synthesize Connected_Peripheral_list;
@synthesize repeatingTimer;
@synthesize registeredPeripherallist;
@synthesize WaitingForBond;
@synthesize intended_peripheral;
@synthesize intended_advData;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    [WaitingForBond startAnimating];
    
	// Do any additional setup after loading the view.
    BLECentralManager = [BLECentralSingleton getBLECentral];
    BLECentralManager.delegate = self;
    registeredPeripherallist = [BLECentralSingleton getBLERegistered_peripheral_list];
    
    // Start scan.
    [BLECentralManager stopScan];
    [BLECentralManager scanForPeripheralsWithServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"0xffa1"]] options:nil];


}

- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"Peripheral %@ connected",[peripheral.identifier UUIDString]);
//    peripheral.delegate = self;
//    [peripheral discoverServices:[NSArray arrayWithObjects:[CBUUID UUIDWithString:@"0x1804"],[CBUUID UUIDWithString:@"0xffa1"],[CBUUID UUIDWithString:@"0xffa5"],[CBUUID UUIDWithString:@"0xffa6"],nil ]];
    peripheral.delegate = self;
    [peripheral discoverServices:[NSArray arrayWithObjects:[CBUUID UUIDWithString:@"0x1804"],[CBUUID UUIDWithString:@"0xffa0"],[CBUUID UUIDWithString:@"0xffa1"],[CBUUID UUIDWithString:@"0xffa5"],[CBUUID UUIDWithString:@"0xffa6"],nil ]];
    
    
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discovered %@ %@ %@", peripheral.name, peripheral.identifier, advertisementData);
    NSLog(@"Discovered %@", RSSI.stringValue);
    
    
    // If this is in scan list, then skip it.
    for (Keychain* key in registeredPeripherallist){
        if ([key.configProfile.BDaddress isEqual:[advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey]]) {
            return;
        }
    }
    
    // If this is a new device, establish connection.
    NSDictionary* options = @{CBConnectPeripheralOptionNotifyOnConnectionKey: @YES,
                              CBConnectPeripheralOptionNotifyOnDisconnectionKey: @YES,
                              CBConnectPeripheralOptionNotifyOnNotificationKey: @YES};
    
    [BLECentralManager cancelPeripheralConnection:peripheral];
    [BLECentralManager connectPeripheral:peripheral options: options];
    
    intended_peripheral = peripheral;
    intended_advData = advertisementData;
    
    NSLog(@"Start connecting");
    
    
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {

    NSLog(@"Discovered %@ %@", peripheral.name, peripheral.identifier);
    NSLog(@"Diconnected");
    
    // Start scan.
    [BLECentralManager stopScan];
    [BLECentralManager scanForPeripheralsWithServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"0xffa1"]] options:nil];


}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"%@ has services:\n",peripheral.name);
    for(CBService * service in peripheral.services) {
        
        NSLog(@"%@ \n",service.UUID);
        peripheral.delegate = self;;
        [peripheral discoverCharacteristics:nil forService:service];
    }
    
    
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"This service: %@  has those characteristics:\n", service.UUID);
    for(CBCharacteristic* characteristic in service.characteristics)
    {
        NSLog(@"%@ \n",characteristic.UUID.data);
        
        if([[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"0xffc0"]]) {
            //[activityIndicator stopAnimating];
            //[self performSegueWithIdentifier:@"BLEScanToSetting" sender:self];
            [intended_peripheral readValueForCharacteristic:characteristic];
        }
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    if ( [[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"0xffc0"]]){
        
        if(characteristic.value) {
            // If the values are valid, it means the pairing is successful.
            NSLog(@"Characteristic:%@",characteristic.value);
            // Successfully bonded, Proceed to Setting and add this peripheral to registered list.
            [WaitingForBond stopAnimating];
            [self performSegueWithIdentifier:@"AddDeviceToSetting" sender:self];
            
        }
        else {
            // Paring fails.
            NSLog(@"Characteristic:%@",characteristic.value);
            NSLog(@"Pairing Fails");
        }
    }

}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"AddDeviceToSetting"]) {
        KeyChainSettingViewController *settingViewController = [segue destinationViewController];
        SprintronCBPeripheral* sprintronPeripheral = [SprintronCBPeripheral alloc];
        sprintronPeripheral.peripheral = intended_peripheral;
        sprintronPeripheral.advertisementData = intended_advData;
        settingViewController.sprintron_peripheral = sprintronPeripheral;

    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
