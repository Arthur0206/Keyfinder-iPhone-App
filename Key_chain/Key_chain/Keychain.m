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
#import "Sprintron_Utility.h"

@interface Keychain ()

@end


@implementation Keychain
{
    NSMutableArray* rssi_entry;
    NSMutableArray* slave_rssi_entry;
}


@synthesize threshold_detail;
@synthesize peripheral;
@synthesize range_state;
@synthesize configProfile;
@synthesize findme_status;
@synthesize conn_params;
@synthesize delegate;
@synthesize key_rssi_value;
@synthesize rssi;
@synthesize key_chain_TX_power;



- (id) init {
    //self.threshold = DEFAULT_THRESHOLD;
    self.range_state = NO_ALERT;
    self.findme_status = false;
    self.threshold_detail = [NSArray arrayWithObjects:[NSNumber numberWithInt:HIGH_THRESHOLD],[NSNumber numberWithInt:MID_THRESHOLD],[NSNumber numberWithInt:LOW_THRESHOLD],nil];
    
    NSNumber *super_small = [NSNumber numberWithInt:SUPER_SMALL];
    rssi_entry = [NSMutableArray arrayWithObjects:super_small, super_small, super_small, nil];
    slave_rssi_entry = [NSMutableArray arrayWithObjects:super_small, super_small, super_small, nil];
    return self;
}

- (id) initWithKeyProfile:(KeychainProfile*) key_profile andPeripheral:(CBPeripheral*) newperipheral {
    
    self = [self init];
    self.configProfile = key_profile;
    self.peripheral = newperipheral;
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
        self.peripheral.delegate = self;
        [self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
    }
}

-(void) read_remote_TX_power {
    CBCharacteristic *characteristic = [self findCharacteristicWithServiceUUID:@"0x1804" andCharacteristicUUID:@"0x2a07"];
    if (characteristic){
        self.peripheral.delegate = self;
        [self.peripheral readValueForCharacteristic:characteristic];
    }
}

- (void) find_key:(NSInteger)enable{
    
    	
    CBCharacteristic *characteristic = [self findCharacteristicWithServiceUUID:@"0xffa5" andCharacteristicUUID:@"0xffc5"];

    if (characteristic)
	{
        if (enable){
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
        NSLog(@"REMOTE RSSI update:%@",characteristic.value);
        self.key_rssi_value = [Sprintron_Utility NSDataToNSNumber:characteristic.value];
        [self key_rssi_window_proceed_with_newRSSI:self.key_rssi_value];
        peripheral.delegate = self;
        [peripheral readRSSI];
    }
    else if ( [[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"0xffc5"]]){
        /*
        NSLog(@"AV Alert%@", characteristic.value);
        
        unsigned char *status = [characteristic.value bytes];
        
        
        if(status[0] == 0x01){
            self.findme_status = YES;
        }
        else{
            self.findme_status = NO;
        }*/
    }
    else if([[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"0xffc6"]]){
        self.conn_params = characteristic.value;
        NSLog(@"didUpdateValue:%@\n",characteristic.UUID.data);
        NSLog(@"Value:%@\n",characteristic.value);
        conn_params = characteristic.value;
        [[self delegate] didReadConnParams];
    }
    else if([[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"0x2a07"]]){
        NSLog(@"TX_POWER = %@ dbm",characteristic.value);
        self.key_chain_TX_power = [Sprintron_Utility NSDataToNSNumber:characteristic.value];
    }

}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if([[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"0xffc6"]]){
        //[self read_connectionParams];
    }
    else if([[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"0xffc5"]]){
        //[self find_key_status];
        [[self delegate] didWriteFindMeStatus];
    }
}

- (void) rssi_window_proceed_with_newRSSI:(NSNumber*)new_rssi {
    static NSInteger rssi_array_index = 0 ;
    
    // RSSI_m = rawRSSI_m – TxPwr_s
    NSNumber* master_cal_rssi = [NSNumber numberWithInteger:[new_rssi integerValue] - Key_TX_POWER];
    
    [rssi_entry replaceObjectAtIndex:rssi_array_index withObject:master_cal_rssi];
    
    rssi_array_index++;
    if(rssi_array_index > 2){
        rssi_array_index = 0;
    }
    
    //return [Sprintron_Utility sprintron_MaxNSNumber:rssi_entry];
    
}

- (void) key_rssi_window_proceed_with_newRSSI:(NSNumber*)new_rssi {
    static NSInteger slave_rssi_array_index = 0 ;
    
    // RSSI_m = rawRSSI_s – TxPwr_m
    NSNumber* slave_cal_rssi = [NSNumber numberWithInteger:[new_rssi integerValue] - IPHONE_TX_POWER];
    self.key_rssi_value = slave_cal_rssi;
    [slave_rssi_entry replaceObjectAtIndex:slave_rssi_array_index withObject:slave_cal_rssi];
    
    slave_rssi_array_index++;
    if(slave_rssi_array_index > 2){
        slave_rssi_array_index = 0;
    }
    
    //return [Sprintron_Utility sprintron_MaxNSNumber:rssi_entry];
    
}

- (NSNumber*) cal_rssi{
    /*
    At any given time, we will take the max of the past 3 RSSI values:
    maxRSSI_m (k) = MAX( RSSI_m(k),  RSSI_m(k-1),  RSSI_m(k-2) );
    maxRSSI_s (k) = MAX( RSSI_s(k),  RSSI_s(k-1),  RSSI_s(k-2) );
    
    and the RSSI to use is:
    RSSI_max (k) = MAX(maxRSSI_m(k), maxRSSI_s(k))
    */
    
    NSNumber* m_range_rssi = [Sprintron_Utility sprintron_MaxNSNumber:rssi_entry];
    NSNumber* s_range_rssi = [Sprintron_Utility sprintron_MaxNSNumber:slave_rssi_entry];
    
    if([m_range_rssi integerValue] > [s_range_rssi integerValue]) {
        return m_range_rssi;
    }
    else{
        return s_range_rssi;
    }
}


- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    
    
    NSLog(@"RSSI:%d",[peripheral.RSSI intValue]);
    
    self.rssi = peripheral.RSSI;
    
    [self rssi_window_proceed_with_newRSSI:peripheral.RSSI];
    self.calculated_range_indicator_rssi = [self cal_rssi];
    
    if(configProfile.out_of_range_alert){
        
        NSInteger threshold_int = [[threshold_detail objectAtIndex:configProfile.threshold] intValue];
        if ([self.calculated_range_indicator_rssi intValue] < threshold_int && range_state < RED_ALERT) {
            [self alert:@"out of range"];
            range_state = RED_ALERT;
        }
        else if( range_state == RED_ALERT && [self.calculated_range_indicator_rssi intValue] > threshold_int + 20) {
            range_state = NO_ALERT;
        }
        
    }
    
    NSLog(@"Filtered RSSI:%d",[self.calculated_range_indicator_rssi integerValue]);

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
        
        if([[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"0xffc1"]]) {
            NSLog(@"Set RSSI update indication");
            [self set_notification];
        }
        else if([[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"0x2a07"]]) {
            NSLog(@"Read remote TX Power.");
            // Read remote TX Power.
            [self read_remote_TX_power];
        }
        else if([[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"0xffc6"]]) {
            // Connection update to 1s interval.
            [self connection_updateWithdata:[Sprintron_Utility stringToHexData:@"2003f40100002000c800"]];
        }
        
        
        //[peripheral discoverDescriptorsForCharacteristic:characteristic];
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    for(CBDescriptor* descriptor in characteristic.descriptors) {
        NSLog(@"descriptor:%@ \n",descriptor);
        [peripheral readValueForDescriptor:descriptor];
    }
    
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    
    NSLog(@"update descriptor");
    NSLog(@"descriptor:%@  value:%@",descriptor, descriptor.value);

}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //[peripheral setNotifyValue:YES forCharacteristic:]
    // RSSI periodic update
    
    //CBCharacteristic *rssi_update_characteristic = [self findCharacteristicWithServiceUUID:@"0xffa1" andCharacteristicUUID:@"0xffc1"];
    NSLog(@"Updated Nofitication state");
    
    //[self set_notification];
    
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

- (NSString*) connectionState {
    if(self.peripheral){
        switch (self.peripheral.state) {
            case CBPeripheralStateConnected:
                return @"Connected";
            case CBPeripheralStateConnecting:
                return @"Connecting";
            default:
                return @"Not Connected";
        }
    }
    return @"Not Connected";
}




@end


