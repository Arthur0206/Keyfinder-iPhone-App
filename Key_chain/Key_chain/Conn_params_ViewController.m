//
//  Conn_params_ViewController.m
//  Key_chain
//
//  Created by Brandon Chen on 3/9/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import "Conn_params_ViewController.h"

@interface Conn_params_ViewController ()

@end

@implementation Conn_params_ViewController

@synthesize  keychain;
@synthesize conn_params;
@synthesize WrtieValue;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",keychain.conn_params);
    NSMutableString *result = [NSMutableString string];
    const char *bytes = [keychain.conn_params bytes];
    for (int i = 0; i < [keychain.conn_params length]; i++)
    {
        [result appendFormat:@"%02hhx", (unsigned char)bytes[i]];
    }
    NSLog(@"Data =%@",result);
    
    conn_params.text = result ;
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
// Decodes an NSString containing hex encoded bytes into an NSData object
//
- (NSData *) stringToHexData:(NSString*) input
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


- (IBAction)WriteAction:(id)sender {
    
    NSString *connupdate = conn_params.text;
    
    NSData* data = [self stringToHexData:connupdate];
    
    NSLog(@"%@",data);
    [keychain connection_updateWithdata:data];
}
@end
