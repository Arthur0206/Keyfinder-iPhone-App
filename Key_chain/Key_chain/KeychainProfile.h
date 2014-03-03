//
//  KeychainProfile.h
//  Key_chain
//
//  Created by Brandon Chen on 2/22/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainProfile : NSObject

@property NSUInteger peripheral_UUID;
@property NSString* name;
@property NSInteger  threshold;

-(void) initWithName:(NSString*) name;

@end
