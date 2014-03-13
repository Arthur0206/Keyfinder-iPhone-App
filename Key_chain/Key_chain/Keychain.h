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


#import "KeychainProfile.h"

#define RED_ALERT 1
#define NO_ALERT  0

#define NOT_CONNECTED 0
#define CONNECTED 1


#define HIGH_THRESHOLD -95
#define MID_THRESHOLD -85
#define LOW_THRESHOLD -75

#define SUPER_SMALL  -10000

@protocol KeychainDelegate <NSObject>

@optional
- (void) didReadConnParams;

@end

@interface Keychain : NSObject <CBPeripheralDelegate>
{
    id <KeychainDelegate> delegate;
}
@property (strong) id delegate;

@property (nonatomic,strong)CBPeripheral *peripheral;
@property (nonatomic,strong)KeychainProfile *configProfile;
@property NSArray*  threshold_detail;
@property NSInteger range_state;
@property BOOL findme_status;
@property NSData* conn_params;
@property NSNumber* key_rssi_value;


- (id) init;
- (id) initWithKeyProfile:(KeychainProfile*) key_profile andPeripheral:(CBPeripheral*) newperipheral;
- (void) alert:(NSString*)msg;
- (void) find_key:(NSInteger)enable;
- (void) find_key_status;
- (void) set_notification;
- (void) connection_updateWithdata:(NSData*)data;
- (void) read_connectionParams;
- (NSString*) connectionState;

@end
