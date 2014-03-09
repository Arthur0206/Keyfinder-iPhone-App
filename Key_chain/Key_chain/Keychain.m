//
//  Keychain.m
//  Key_chain
//
//  Created by Brandon Chen on 2/14/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import "Keychain.h"
#import "CoreBluetooth/CBService.h"
#import "CoreBluetooth/CBCharacteristic.h"
#import "CoreBluetooth/CBUUID.h"
#import "BLECentralSingleton.h"

@interface Keychain ()

@end

@implementation Keychain

@synthesize threshold;
@synthesize threshold_detail;
@synthesize peripheral;
@synthesize connection_state;
@synthesize range_state;
@synthesize out_of_range_alert;
@synthesize disconnection_alert;
@synthesize location;
@synthesize configProfile;
@synthesize findme_status;
@synthesize conn_params;

- (id) init {
    //self.threshold = DEFAULT_THRESHOLD;
    self.connection_state = NOT_CONNECTED;
    self.range_state = NO_ALERT;
    self.findme_status = false;
    self.threshold_detail = [NSArray arrayWithObjects:[NSNumber numberWithInt:HIGH_THRESHOLD],[NSNumber numberWithInt:MID_THRESHOLD],[NSNumber numberWithInt:LOW_THRESHOLD],nil];
    return self;
}

- (id) initWithKeyProfile:(KeychainProfile *)key_profile {
    
    self = [self init];
    self.configProfile = key_profile;
    return self;
}

- (void) alert:(NSString*)msg{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    localNotification.alertBody = [NSString stringWithFormat:@"%@,%@", peripheral.name, msg];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] 	presentLocalNotificationNow:localNotification];
}

- (CBCharacteristic *) findCharacteristicWithServiceUUID:(NSString *) serviceUUID andCharacteristicUUID:(NSString *) charUUID
{
    for (CBService *service in self.peripheral.services)
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


- (void) set_notification {
    CBCharacteristic *characteristic = [self findCharacteristicWithServiceUUID:@"0xffa1" andCharacteristicUUID:@"0xffc1"];
    if (characteristic){
        [self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
    }
}

- (void) find_key:(NSInteger)enable{
    
    	
    CBCharacteristic *characteristic = [self findCharacteristicWithServiceUUID:@"0xffa5" andCharacteristicUUID:@"0xffc5"];

    if (characteristic)
	{
        if (self.findme_status){
            unsigned char bytes = 0x1;
            NSData *data = [NSData dataWithBytes:&bytes length:1];
            [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        }
        else {
            unsigned char bytes = 0x0;
            NSData *data = [NSData dataWithBytes:&bytes length:1];
            [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        }
    }
    [self find_key_status];

}

- (void)find_key_status {
    
    
    CBCharacteristic *characteristic = [self findCharacteristicWithServiceUUID:@"0xffa5" andCharacteristicUUID:@"0xffc5"];
    
    
    if (characteristic)
	{
        peripheral.delegate = self;
		[self.peripheral readValueForCharacteristic:characteristic];
    
	}
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{

    if ( [[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"0xffc1"]]){
        //NSLog(@"rssi:%@", characteristic.value);
    }
    else if ( [[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"0xffc5"]]){
        self.findme_status = characteristic.value ;
    }
    else if([[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"0xffc6"]]){
        self.conn_params = characteristic.value;
        NSLog(@"didUpdateValue:%@\n",characteristic.UUID.data);
        NSLog(@"Value:%@\n",characteristic.value);
        conn_params = characteristic.value;
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if([[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"0xffc6"]]){
        [self read_connectionParams];
    }
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
        /*(for(Keychain* keychain in registerList){
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
     }*/
    
    NSLog(@"RSSI:%d",[peripheral.RSSI intValue]);
    if(out_of_range_alert){
        
        NSInteger threshold_int = [[threshold_detail objectAtIndex:threshold] intValue];
        if ([peripheral.RSSI intValue] < threshold_int && range_state < RED_ALERT) {
            [self alert:@"out of range"];
            range_state = RED_ALERT;
        }
        else if( range_state == RED_ALERT && [peripheral.RSSI intValue] > threshold_int + 20) {
            range_state = NO_ALERT;
        }
        
    }
    //NSLog([peripheral.RSSI stringValue]);
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
        NSLog(@"%@ \n",characteristic.UUID.data);
        //[peripheral discoverDescriptorsForCharacteristic:characteristic];
    }
    
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    
    NSLog(@"update descriptor");
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //[peripheral setNotifyValue:YES forCharacteristic:]
    // RSSI periodic update
    
    //CBCharacteristic *rssi_update_characteristic = [self findCharacteristicWithServiceUUID:@"0xffa1" andCharacteristicUUID:@"0xffc1"];
    //NSLog(@"RSSI UPDATE");
//    NSLog(@"RSSI update:%@",characteristic.value);
    [self.peripheral readRSSI];
    [self set_notification];
    
}
- (void) connection_updateWithdata:(NSData*)data{
    CBCharacteristic *characteristic = [self findCharacteristicWithServiceUUID:@"0xffa6" andCharacteristicUUID:@"0xffc6"];
    
    if (characteristic) {
        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}
    
- (void) read_connectionParams{
    CBCharacteristic *characteristic = [self findCharacteristicWithServiceUUID:@"0xffa6" andCharacteristicUUID:@"0xffc6"];

    if (characteristic)
    {
        [self.peripheral readValueForCharacteristic:characteristic];
    }
}




@end


