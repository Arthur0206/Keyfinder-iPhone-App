//
//  KeyChainViewController.h
//  Key_chain
//
//  Created by Brandon Chen on 1/8/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CBService.h>
#import "SprintronCBPeripheral.h"


@interface KeyChainViewController : UITableViewController <CBCentralManagerDelegate,UITableViewDelegate >

@property(nonatomic,strong) CBCentralManager *BLECentralManager;
@property(nonatomic,strong) NSMutableArray* registerList;
@property(nonatomic,strong) NSMutableArray* Peripheral_list;
@property(nonatomic,strong) NSTimer* repeatingTimer;
@property (weak, nonatomic) IBOutlet UIButton *Edit_Button;

- (IBAction)Enter_edit_mode:(id)sender;







//@property(nonatomic,strong) CLLocationManager *locationManager;



@end
