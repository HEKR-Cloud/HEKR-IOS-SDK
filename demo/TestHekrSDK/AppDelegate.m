//
//  AppDelegate.m
//  TestHekrSDK
//
//  Created by 叶文博 on 2017/9/22.
//  Copyright © 2017年 ye_wenbo. All rights reserved.
//

#import "AppDelegate.h"
#import <HekrApiSDK/HekrApiSDK.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

#define LOG_LEVEL_DEF ddLogLevel
const static NSUInteger ddLogLevel = DDLogLevelAll;
@interface AppDelegate ()

@end

@implementation AppDelegate

- (id) getJsonDataFromFile:(NSString *)fileName{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    id jsonDicOrArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return jsonDicOrArray;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //配置文件{"Hekr":{"AppId":"01282585673"}}  AppId表示console上面获取到的pid
    NSDictionary *config = [self getJsonDataFromFile:@"config.json"];
    [[Hekr sharedInstance] config:config startPage:@"http://app.hekr.me/templates/home/html/index.html" launchOptions:launchOptions];
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console

    //登录
    [[Hekr sharedInstance] login:@"xxx@zhujia360.com" password:@"xxx" callbcak:^(id user, NSError *err) {
        NSLog(@"%@",user);
    }];
    
//    [[Hekr sharedInstance] loginWithSetToken:@"" callbcak:^(id user, NSError *err) {
//        NSLog(@"%@",user);
//    }];
    
    id commod = @{@"action":@"appSendResp"};
    [[Hekr sharedInstance] recv:commod obj:self callback:^(id obj, id data, NSError *err) {
        NSLog(@"%@",data);
    }];
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
