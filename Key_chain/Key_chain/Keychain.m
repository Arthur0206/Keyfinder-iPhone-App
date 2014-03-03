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


@implementation Keychain
@synthesize threshold;
@synthesize peripheral;
@synthesize connection_state;
@synthesize range_state;
@synthesize location;
@synthesize configProfile;

- (id) init {
    self.threshold = DEFAULT_THRESHOLD;
    self.connection_state = CONNECTED;
    self.range_state = NO_ALERT;
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

- (void) find_key:(NSInteger)enable{
    unsigned char bytes = 0x0;
    
    if (enable)
    {
        bytes = 0x1;
    
    }
    NSData *data = [NSData dataWithBytes:&bytes length:1];
    
    CBCharacteristic *characteristic = [self findCharacteristicWithServiceUUID:@"0xfff1" andCharacteristicUUID:@"0xfff6"];
	   
    //CBCharacteristic *characteristic = [[CBCharacteristic alloc] init];

    if (characteristic)
	{
		[self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
	}


}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.location forKey:@"location"];
    [encoder encodeObject:self.peripheral forKey:@"peripheral"];
    [encoder encodeInteger:self.threshold forKey:@"threshold"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        location = [coder decodeObjectForKey:@"location"];
        peripheral = [coder decodeObjectForKey:@"peripheral"];
        threshold = [coder decodeFloatForKey:@"threshold"];
    }
    return self;
}


@end


