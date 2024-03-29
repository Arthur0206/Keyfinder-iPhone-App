//
//  AppDelegate.m
//  Key_chain
//
//  Created by Brandon Chen on 1/7/14.
//  Copyright (c) 2014 Brandon Chen. All rights reserved.
//

#import "AppDelegate.h"
#import "BLECentralSingleton.h"

@implementation AppDelegate

@synthesize audioPlayer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //load the array
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"key_profile"];
    NSMutableArray* key_profile_list = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray* registerList = [BLECentralSingleton getBLERegistered_peripheral_list];
    
    for (KeychainProfile* key_profile in  key_profile_list) {
        
        Keychain* keychain = [[Keychain alloc] initWithKeyProfile:key_profile andPeripheral:nil];
        [keychain loadImage];
        [registerList addObject: keychain];
        
        
        
    }
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSMutableArray *key_chain_config_profile = [[NSMutableArray alloc] init];
    //KeychainProfile *key_config;

    
    for (Keychain* key in [BLECentralSingleton getBLERegistered_peripheral_list]) {
        [key_chain_config_profile addObject:key.configProfile];
        //key_config = key.configProfile;
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:key_chain_config_profile];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"key_profile"];
    

}


- (void) application:(UIApplication *)application didReceiveLocalNotification:    (UILocalNotification *)notification {
    //Place your code to handle the notification here.
    //Playing sound
    AudioServicesPlaySystemSound(1005);
    
    
    //alert message
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
}
    
@end
