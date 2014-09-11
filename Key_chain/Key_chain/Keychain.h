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

#define IPHONE_TX_POWER 12
#define Key_TX_POWER 0

@protocol KeychainDelegate <NSObject>

@optional
- (void) didReadConnParams;
- (void) didWriteFindMeStatus;

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
@property NSNumber* rssi;
@property NSNumber* key_chain_TX_power;
@property NSNumber* calculated_range_indicator_rssi;
@property UIImage* image;



- (id) init;
- (id) initWithKeyProfile:(KeychainProfile*) key_profile andPeripheral:(CBPeripheral*) newperipheral;
- (void) alert:(NSString*)msg;
- (void) find_key:(NSInteger)enable;
- (void) find_key_status;
- (void) set_notification;
- (void) read_remote_TX_power;
- (void) connection_updateWithdata:(NSData*)data;
- (void) read_connectionParams;
- (NSString*) connectionState;
- (void) saveimage:(UIImage*) image imageName:(NSString*)imageName;
- (void)loadImage;
- (void) set_notification:(NSString*) ServiceUUID_string andCharacteristicUUID: (NSString*) CharacteristicUUID_string;
- (void) init_notification;

@end
