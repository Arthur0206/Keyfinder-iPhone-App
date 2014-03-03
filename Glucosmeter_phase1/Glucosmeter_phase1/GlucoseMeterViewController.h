//
//  GlucoseMeterViewController.h
//  Glucosmeter_phase1
//
//  Created by Brandon Chen on 11/30/13.
//  Copyright (c) 2013 Brandon Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface GlucoseMeterViewController : UIViewController
@property(nonatomic,strong) CBCentralManager * BLECentralManager;

@end
