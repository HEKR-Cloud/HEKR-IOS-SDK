//
//  HekrConfig.h
//  HekrConfig
//
//  Created by WangMike on 15/8/3.
//  Copyright (c) 2015年 Hekr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HekrConfig : NSObject
+(instancetype) sharedInstance;
+(NSString*) currentSSID;
@property (nonatomic,copy) NSString * APPrefix;
-(void) setDeviceToken:(NSString*) deviceToken;
//Wi-Fi一键配置
-(void) hekrConfig:(NSString*)ssid password:(NSString*)password callback:(void(^)(BOOL,NSString*)) block;
-(void) cancelConfig;

//软ap方式配置
-(BOOL) isDeviceConnectedSoftAP;
-(void) softAPList:(void(^)(NSArray*)) block;
-(void) softAPSetBridge:(id)AP password:(NSString*)password callback:(void (^)(BOOL,NSString*))block;
@end
