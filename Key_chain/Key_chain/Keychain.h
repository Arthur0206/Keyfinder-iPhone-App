//
//  Keychain.h
//  Key_chain
//
//  Created by Brandon Chen on 2/14/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBPeripheral.h>
#import <CoreLocation/CoreLocation.h>
#import "KeychainProfile.h"

#define RED_ALERT 1
#define NO_ALERT  0

#define NOT_CONNECTED 0
#define CONNECTED 1

#define DEFAULT_THRESHOLD -90


@interface Keychain : NSObject <CBPeripheralDelegate>

@property (nonatomic,strong)CBPeripheral *peripheral;
@property (nonatomic, strong)KeychainProfile *configProfile;
@property NSInteger threshold;
@property NSInteger connection_state;
@property NSInteger range_state;
@property CLLocation* location;
@property BOOL out_of_range_alert;
@property BOOL disconnection_alert;
@property BOOL findme_status;
@property NSData* conn_params;

- (id) init;
- (id) initWithKeyProfile:(KeychainProfile*) key_profile;
- (void) alert:(NSString*)msg;
- (void) find_key:(NSInteger)enable;
- (void) find_key_status;
- (void) set_notification;
- (void) connection_updateWithdata:(NSData*)data;
- (void) read_connectionParams;

@end
