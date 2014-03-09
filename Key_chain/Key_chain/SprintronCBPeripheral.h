//
//  SprintronCBPeripheral.h
//  Key_chain
//
//  Created by Brandon Chen on 3/5/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBPeripheral.h>

@interface SprintronCBPeripheral : NSObject 

@property(strong, nonatomic) CBPeripheral* peripheral;
@property(strong, nonatomic) NSDictionary* advertisementData;

@end
