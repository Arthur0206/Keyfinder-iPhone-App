//
//  DeviceListViewController.h
//  Glucosmeter_phase1
//
//  Created by Brandon Chen on 11/30/13.
//  Copyright (c) 2013 Brandon Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBPeripheral.h>


@interface DeviceListViewController : UITableViewController <CBCentralManagerDelegate>

@property(nonatomic,strong) CBCentralManager * BLECentralManager;
@property(nonatomic,strong) CBPeripheral * BLEPeripheral;
@property(nonatomic,strong) NSMutableArray* Peripheral_list;

@end
