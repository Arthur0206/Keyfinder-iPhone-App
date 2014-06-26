//
//  KeyChainAddNewViewController.h
//  Key_chain
//
//  Created by Brandon Chen on 6/20/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "SprintronCBPeripheral.h"


@interface KeyChainAddNewViewController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate>

@property(nonatomic,strong) CBCentralManager * BLECentralManager;
@property(nonatomic,strong) NSMutableArray* Peripheral_list;
@property(nonatomic,strong) NSMutableArray* Connected_Peripheral_list;
@property(nonatomic,strong) NSMutableArray* registeredPeripherallist;
@property(nonatomic,strong) NSDictionary* intended_advData;
@property (weak) NSTimer *repeatingTimer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *WaitingForBond;
@property(nonatomic,strong) CBPeripheral * intended_peripheral;





@end
