//
//  SprintronBLECentral.h
//  Key_chain
//
//  Created by Brandon Chen on 2/17/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface SprintronBLECentral : CBCentralManager <CBCentralManagerDelegate>


- (void) startScan;
- (void) stopScan;
- (void) initConnectionToPeripheral:(CBPeripheral*) peripheral withServices:(NSArray*)UUID_strings;
- (void) stopConnectionToPeripheral:(CBPeripheral*) peripheral;

@end
