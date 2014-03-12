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
static NSMutableArray* Peripheral_list;
static NSMutableArray* connected_peripheral_list;

// List of Key Chains.
static NSMutableArray* registered_peripheral_list;


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

+ (id)getBLEConnected_peripheral_list {
    
    if(connected_peripheral_list == nil) {
        connected_peripheral_list = [[NSMutableArray alloc] init];
    }
    
    return connected_peripheral_list;
    
}

+ (id)getBLERegistered_peripheral_list {
    
    if(registered_peripheral_list == nil) {
        registered_peripheral_list = [[NSMutableArray alloc] init];
    }
    
    return registered_peripheral_list;
    
}

+ (BOOL)addObjectToBLERegistered_peripheral_list:(id)object {
    if (registered_peripheral_list == nil){
        return NO;
    }
    else {
        [registered_peripheral_list addObject:object];
        return YES;
    }
}


@end