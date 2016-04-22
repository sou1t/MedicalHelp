//
//  AppDelegate.m
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 23.11.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

#import "AppDelegate.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DataModel sharedInstance];
    
    
    [YMMYandexMetrica activateWithApiKey:@"6a6835b0-5886-4e0c-a2d2-ca292128568d"];

  
    sleep(2);
    return YES;
}

@end
