//
//  CameraViewController.h
//  Key_chain
//
//  Created by Brandon Chen on 6/28/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyChainSettingViewController.h"

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property KeyChainSettingViewController* key_chain_setting_controller;
@end
