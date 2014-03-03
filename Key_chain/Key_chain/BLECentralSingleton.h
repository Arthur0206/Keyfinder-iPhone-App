//
//  BLECentralSingleton.h
//  Glucosmeter_phase1
//
//  Created by Brandon Chen on 12/14/13.
//  Copyright (c) 2013 Brandon Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBPeripheral.h>

@interface BLECentralSingleton : NSObject 
+ (id)getBLECentral;
+ (id)getBLEPeripheral_list;
+ (id)getBLEConnected_peripheral_list;
+ (id)getBLERegistered_peripheral_list;
+ (void)setBLERegistered_peripheral_list:(NSMutableArray*) list ;

@end
