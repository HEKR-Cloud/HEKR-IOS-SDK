//
//  HekrConfig.m
//  HekrConfig
//
//  Created by WangMike on 15/8/3.
//  Copyright (c) 2015年 Hekr. All rights reserved.
//

#import "HekrConfig.h"
#import "ScanDevice.h"
#import <SystemConfiguration/CaptiveNetwork.h>

NSString * currentWifiSSID() { // Does not work on the simulator.
    NSString *ssid = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"SSID"]) {
            ssid = info[@"SSID"];
        }
    }
    return ssid;
}
NSInteger convertSSID(NSString* ssidName){
    if (ssidName) {
        NSArray *array = [ssidName.lowercaseString componentsSeparatedByString:@"_"];
        if ([array containsObject:@"open"]) {
            return 0;
        }else if ([array containsObject:@"wep"])
        {
            return 1;
        }
        else if ([array containsObject:@"psk2"] ||[array containsObject:@"psk"] )
        {
            return 2;
        }
        else if ([array containsObject:@"eap"])
        {
            return 1;
        }
    }
    return 999;
}

@interface HekrConfig()
@property (nonatomic,copy) NSString * token;
@property (nonatomic,strong) ScanDevice * scaner;
@end

@implementation HekrConfig
+(instancetype) sharedInstance{
    static id __instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [HekrConfig new];
    });
    return __instance;
}
-(void) setDeviceToken:(NSString*) deviceToken{
    self.token = deviceToken;
}
#pragma mark -- wifi
-(void) hekrConfig:(NSString*)ssid password:(NSString*)password callback:(void(^)(BOOL)) block{
    self.scaner = [[ScanDevice alloc] initWithToken:self.token ssid:ssid password:password];
    __weak typeof(self) wself = self;
    self.scaner.block = ^(BOOL ret){
        typeof(self) sself = wself;
        sself.scaner = nil;
        !block?:block(ret);
    };
    [self.scaner start];
}
-(void) cancelConfig{
    [self.scaner cancel];
    self.scaner = nil;
}
#pragma mark -- softAP
-(BOOL) isDeviceConnectedSoftAP{
    return [currentWifiSSID() hasPrefix:@"Hekr_"];
}
-(void) softAPList:(void(^)(NSArray*)) block{
    __weak typeof(self) wself = self;
    [self setAK:self.token callback:^(BOOL ret) {
        typeof(self) sself = wself;
        if (ret) {
            [sself getAPList:block];
        }else{
            !block?:block(nil);
        }
    }];
}
-(void) setAK:(NSString*) token callback:(void(^)(BOOL)) block{
    if ([self isDeviceConnectedSoftAP]) {
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.10.1/t/set_ak?ak=%@",token]]];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                NSError * error = nil;
                id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                if ([json isKindOfClass:[NSDictionary class]]) {
                    if([json objectForKey:@"code"] && [[json objectForKey:@"code"] integerValue] == 0){
                        return !block?:block(YES);
                    }
                }
            }
            !block?:block(NO);
        }];
    }else{
        !block?:block(NO);
    }
}
-(void) getAPList:(void(^)(NSArray*)) block{
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.10.1/t/get_aplist"]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSError * error = nil;
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if ([json isKindOfClass:[NSArray class]]) {
                return !block?:block(json);
            }
        }
        !block?:block(nil);
    }];
}
-(void) softAPSetBridge:(id)AP password:(NSString*)password callback:(void (^)(BOOL))block{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:AP];
    [dict setObject:password forKey:@"key"];
    __weak typeof(self) wself = self;
    [self setAK:self.token callback:^(BOOL ret) {
        typeof(self) sself = wself;
        if (ret) {
            [sself hekrConfig:dict callback:block];
        }else{
            !block?:block(NO);
        }
    }];
}
-(void) hekrConfig:(id)AP callback:(void (^)(BOOL))block{
    NSString *ssid = [AP objectForKey:@"ssid"];
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)ssid, NULL, (CFStringRef)@"!*’();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    NSString *bssid = [AP objectForKey:@"bssid"];
    NSInteger encryption = convertSSID([AP objectForKey:@"auth_suites"]);
    NSString *channel = [AP objectForKey:@"channel"];
    NSString * password = [AP objectForKey:@"key"];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.10.1/t/set_bridge?ssid=%@&bssid=%@&key=%@&channel=%@&encryption=%ld",encodedString,bssid,password,channel,(long)encryption]]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSError * error = nil;
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if ([json isKindOfClass:[NSDictionary class]]) {
                if([json objectForKey:@"code"] && [[json objectForKey:@"code"] integerValue] == 0){
                    return !block?:block(YES);
                }
            }
        }
        !block?:block(NO);
    }];
}
@end