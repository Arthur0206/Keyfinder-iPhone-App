//
//  KeychainProfile.m
//  Key_chain
//
//  Created by Brandon Chen on 2/22/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import "KeychainProfile.h"

@implementation KeychainProfile
@synthesize peripheral_UUID;
@synthesize name;
@synthesize threshold;



-(void) initWithName:(NSString*) name {
    self.name = name;
}




@end
