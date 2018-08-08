//
//  HekrSDK.h
//  HekrSDK
//
//  Created by WangMike on 15/7/31.
//  Copyright (c) 2015年 Hekr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HekrSDK.h"

typedef NS_ENUM(NSUInteger, ConfigDeviceType) {
    ConfigDeviceTypeNormal,
    ConfigDeviceTypeSoftAP,
};

@interface Hekr ()

@end

@interface Hekr(Config)
/**
 传入SSID和password进行配网
 
 @param ssid SSID
 @param pwd password
 @param pinCode pinCode (软AP配网必填)
 @param configType 配网的类型 ConfigDeviceTypeNormal：正常配网 ；ConfigDeviceTypeSoftAP：软AP
 @param stepCallBack 配设备时的步骤：STEP：1 获取PinCode成功；STEP：2 设备连接路由器成功；STEP：3 云端验证设备信息成功；STEP：4 设备登陆云端成功；STEP：5 绑定设备成功
 */
-(void) configSearch:(NSString *)ssid pwd:(NSString *)pwd pinCode:(NSString *)pinCode configType:(ConfigDeviceType )configType stepCallBack:(void (^)(NSDictionary *dict, NSString *address))stepCallBack;

-(void) stopConfig;

@end
