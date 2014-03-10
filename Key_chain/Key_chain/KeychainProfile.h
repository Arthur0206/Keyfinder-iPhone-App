//
//  KeychainProfile.h
//  Key_chain
//
//  Created by Brandon Chen on 2/22/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainProfile : NSObject

@property NSString* BDaddress;
@property NSString* name;
@property NSInteger threshold;

-(id) initWithName:(NSString*)s_name andthreshold:(NSInteger) thres andBDaddr: (NSString*)BDaddr;

@end
