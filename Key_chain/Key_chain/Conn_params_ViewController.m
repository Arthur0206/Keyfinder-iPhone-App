//
//  Conn_params_ViewController.m
//  Key_chain
//
//  Created by Brandon Chen on 3/9/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import "Conn_params_ViewController.h"
#import "Sprintron_Utility.h"

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
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)WriteAction:(id)sender {
    
    NSString *connupdate = conn_params.text;
    
    NSData* data = [Sprintron_Utility stringToHexData:connupdate];
    
    NSLog(@"%@",data);
    [keychain connection_updateWithdata:data];
}
@end
