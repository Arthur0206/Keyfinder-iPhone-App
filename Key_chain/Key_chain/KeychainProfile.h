//
//  KeychainProfile.h
//  Key_chain
//
//  Created by Brandon Chen on 2/22/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface KeychainProfile : NSObject

@property NSData* BDaddress;
@property NSString* name;
@property NSInteger threshold;
@property BOOL out_of_range_alert;
@property BOOL disconnection_alert;
@property CLLocation* location;

-(id) initWithName:(NSString*)s_name andthreshold:(NSInteger) thres andBDaddr: (NSData*)BDaddr
andOutofRangeAlert:(BOOL)out_of_range_alert_on andDisconnectionAlert:(BOOL)disconnection_alert_on;

@end
