//
//  KeychainProfile.m
//  Key_chain
//
//  Created by Brandon Chen on 2/22/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import "KeychainProfile.h"

@implementation KeychainProfile
@synthesize BDaddress;
@synthesize name;
@synthesize threshold;
@synthesize out_of_range_alert;
@synthesize disconnection_alert;
@synthesize location;



-(id) initWithName:(NSString*)s_name andthreshold:(NSInteger) thres andBDaddr: (NSString*)BDaddr {
    self.name = s_name;
    self.threshold = thres;
    self.BDaddress = BDaddr;
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:BDaddress forKey:@"BLTH address"];
    [encoder encodeInteger:threshold forKey:@"threshold"];
    [encoder encodeObject:name forKey:@"name"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self) {
        BDaddress = [decoder decodeObjectForKey:@"BLTH address"];
        threshold = [decoder decodeIntegerForKey:@"threshold"];
        name = [decoder decodeObjectForKey:@"name"];
    }

    return self;
}




@end
