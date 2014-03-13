//
//  Sprintron_Utility.m
//  Key_chain
//
//  Created by Brandon Chen on 3/9/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import "Sprintron_Utility.h"

@implementation Sprintron_Utility

//
// Decodes an NSString containing hex encoded bytes into an NSData object
//
+ (NSData *) stringToHexData:(NSString*) input
{
    int len = [input length] / 2;    // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    for (i=0; i < [input length] / 2; i++) {
        byte_chars[0] = [input characterAtIndex:i*2];
        byte_chars[1] = [input characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    
    NSData *data = [NSData dataWithBytes:buf length:len];
    free( buf );
    return data;
}

+ (NSNumber *) NSDataToNSNumber:(NSData*) input
{
    
    char *bytePtr = (char *)[input bytes];
    int len = [input length];
    int  output = 0;
    
    for(int i = 0 ; i < len; i++) {
        output = (output << 8)  + bytePtr[i];
    }
    
    return [NSNumber numberWithInt:output];
}

+ (NSNumber *) sprintron_MaxNSNumber:(NSMutableArray*) array {
    if ([array count] == 0){
        return nil;
    }
    NSNumber *max = [array objectAtIndex:0];
    
    for(NSNumber* num in array){
        if ([max integerValue] < [num integerValue]){
            max = num;
        }
    }
    
    return max;
}
@end
