//
//  Sprintron_Utility.h
//  Key_chain
//
//  Created by Brandon Chen on 3/9/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sprintron_Utility : NSObject

// Decodes an NSString containing hex encoded bytes into an NSData object
+ (NSData *) stringToHexData:(NSString*) input;
@end
