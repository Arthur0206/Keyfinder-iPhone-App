//
//  Conn_params_ViewController.h
//  Key_chain
//
//  Created by Brandon Chen on 3/9/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keychain.h"

@interface Conn_params_ViewController : UIViewController

@property Keychain* keychain;
@property (weak, nonatomic) IBOutlet UITextField *conn_params;
@property (weak, nonatomic) IBOutlet UIButton *WrtieValue;
- (IBAction)WriteAction:(id)sender;

@end
