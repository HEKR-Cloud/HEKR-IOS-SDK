//
//  HekrSDK.h
//  HekrSDK
//
//  Created by WangMike on 15/7/31.
//  Copyright (c) 2015年 Hekr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HekrSDK.h"
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger, HekrLocalControl) {
    HekrLocalControlOn,
    HekrLocalControlOff,
};

@interface Hekr ()

@end

@interface Hekr(Cloud)
-(AFNetworkReachabilityManager*) reachability;
-(AFHTTPSessionManager*) sessionWithDefaultAuthorization;
//-(AFHTTPSessionManager*) sessionWithAuthorization:(NSString*) headerValue;
@end

@interface Hekr(User)
-(void) loginWithSetToken:(NSString *)token callbcak:(void(^)(id user,NSError*)) block;
-(void) login:(NSString*)userName password:(NSString*) password callbcak:(void(^)(id user,NSError*)) block;
-(void) logout;
@end

@interface Hekr(Net)
-(void) send:(id) json to:(id) dev callback:(void(^)(id data,NSError*)) block;
-(void) send:(id) json to:(id) dev withoutComplate:(BOOL)complate callback:(void(^)(id data,NSError*)) block;
/**
 监听json

 @param filter 需要监听的json
 @param obj 销毁对象
 @param block 回调
 */
-(void) recv:(id) filter obj:(id) obj callback:(void(^)(id obj,id data,NSError*)) block;

/**
 向云端发送数据

 @param json json数据
 @param dev 设备tid
 @param timeout 超时时间
 @param block 回调
 */
-(void) sendNet:(id)json to:(id)dev timeout:(NSTimeInterval) timeout callback:(void (^)(id, NSError *))block;
-(void)removeRecvOfObj:(id)content;
-(void) setRecvCallBack:(void(^)(id pro)) recvCallBack;

@end

@interface Hekr(Config)

/**
 配网

 @param ssid ssid
 @param pwd pwd
 @param refreshPin 是否需要刷新发送的数据
 @param block 回调
 */
-(void) configSearch:(NSString*) ssid pwd:(NSString*) pwd refreshPin:(BOOL)refreshPin callback:(void(^)(id, NSError*)) block; // block 会被调用多次
/**
 停止配网
 */
-(void) stopConfig;
/**
 2g配网

 @param info 获取到的devTid和bindKey的参数
 @param block 回调
 */
-(void) bindDevice:(id) info callback:(void(^)(id,NSError*)) block;
@end

@interface Hekr(Tool)
//-(void) pickImage:(UIViewController*) control useCamer:(BOOL) camer uploadBlock:(void(^)(NSString*,NSError*)) block;
-(void) scanQRCode:(UIViewController*)controller title:(NSString*) title block:(void(^)(id,id)) block;
-(void) setLocalControl:(HekrLocalControl)control;
-(void) setLocalControl:(HekrLocalControl)control block:(void(^)(HekrLocalControl control))block;
-(HekrLocalControl) getLocalControl;
@end

@interface Hekr (DeviceFilter)//由外部传入设备数据，用于局域网使用
-(void) onInsertDevices:(NSArray *)devices;
-(void) onInsertDevices:(NSArray *)devices page:(NSInteger )page;
-(void) onDelDevices:(NSDictionary *)device;
-(void) callBackLocalDevicesState:(void(^)(NSString *devTid,NSArray *devices)) openState closeState:(void(^)(NSString *devTid)) closeState;
-(NSArray *) getControlDealDevs;
@end

@interface Hekr (SocialManage)
-(NSDictionary *)getSocialTypes;
@end
