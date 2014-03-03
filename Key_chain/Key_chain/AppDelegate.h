//
//  AppDelegate.h
//  Key_chain
//
//  Created by Brandon Chen on 1/7/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BLECentralSingleton.h"
#import "Keychain.h"
#import <Foundation/NSKeyedArchiver.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AVAudioPlayer* audioPlayer;
@end
