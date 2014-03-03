//
//  BLECentralSingleton.m
//  Glucosmeter_phase1
//
//  Created by Brandon Chen on 12/14/13.
//  Copyright (c) 2013 Brandon Chen. All rights reserved.
//

#import "BLECentralSingleton.h"

@implementation BLECentralSingleton

static CBCentralManager * BLECentralManager;
//static CBPeripheral * BLEPeripheral;
static NSMutableArray* Peripheral_list;

+ (id)getBLECentral {
    if (BLECentralManager == nil) {
        BLECentralManager = [[CBCentralManager alloc] initWithDelegate:nil queue:nil ];
    }
    return BLECentralManager;
}

+ (id)getBLEPeripheral_list {
    
    if(Peripheral_list == nil){
        
        Peripheral_list = [[NSMutableArray alloc] init];
    }
    return Peripheral_list;
}

@end