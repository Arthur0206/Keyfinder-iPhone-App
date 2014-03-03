//
//  GlucoseMeterViewController.m
//  Glucosmeter_phase1
//
//  Created by Brandon Chen on 11/30/13.
//  Copyright (c) 2013 Brandon Chen. All rights reserved.
//

#import "GlucoseMeterViewController.h"
#import "BLECentralSingleton.h"

@interface GlucoseMeterViewController ()

@end

@implementation GlucoseMeterViewController

@synthesize BLECentralManager;


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
	// Do any additional setup after loading the view.
    BLECentralManager = [BLECentralSingleton getBLECentral];
    BLECentralManager.delegate = nil;

    
    
    
    
    NSLog(@"Glucose did load");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Back from device list");
}
@end
