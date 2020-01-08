//
//  HekrSDK.h
//  HekrSDK
//
//  Created by WangMike on 15/7/31.
//  Copyright (c) 2015年 Hekr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>
#import "HekrSDK.h"

typedef NS_ENUM(NSUInteger, HekrLocalControl) {
    HekrLocalControlOff,
    HekrLocalControlOn,
};

typedef NS_ENUM(NSUInteger, HekrSSOType) {
    HekrSSOLogin,
    HekrSSOBind,
    HekrShareSina,
};

typedef NS_ENUM(NSUInteger, ConfigDeviceStep) {
    ConfigDeviceStepFirst,
    ConfigDeviceStepSecond,
    ConfigDeviceStepThird,
    ConfigDeviceStepFourth,
    ConfigDeviceStepFinish,
};

typedef NS_ENUM(NSUInteger, ConfigDeviceType) {
    ConfigDeviceTypeNormal,
    ConfigDeviceTypeSoftAP,
};

@interface Hekr ()

@end

@interface Hekr(Cloud)
-(AFNetworkReachabilityManager*) reachability;
-(AFHTTPSessionManager*) sessionWithDefaultAuthorization;
//-(AFHTTPSessionManager*) sessionWithAuthorization:(NSString*) headerValue;
@end

@interface Hekr(User)
-(void) setOnlineSite:(NSString* )dom;
-(void) login:(NSString*)userName password:(NSString*) password callbcak:(void(^)(id user,NSError*)) block;
-(void) refreshToken:(void (^)(id, NSError *))block;
-(void) sso:(NSString*) type controller:(UIViewController*) controlelr ssoType:(HekrSSOType)ssotype callback:(void(^)(id token,id user,NSError*)) block;
-(void) sso:(NSString*) type controller:(UIViewController*) controlelr ssoType:(HekrSSOType)ssotype anonymous:(BOOL)anonymous callback:(void(^)(id token,id user,NSError*)) block;
-(void) logout;
@end

@interface Hekr(Net)
-(void) send:(id) json to:(id) dev callback:(void(^)(id data,NSError*)) block;
-(void) send:(id)json to:(NSString *)to withoutComplate:(BOOL)complate callback:(void (^)(id, NSError *))block;
-(void) recv:(id) filter obj:(id) obj callback:(void(^)(id obj,id data,NSError*)) block;
-(void) sendNet:(id)json to:(id)dev timeout:(NSTimeInterval) timeout callback:(void (^)(id, NSError *))block;
-(void) sendNet:(id)json toHost:(NSString *)host timeout:(NSTimeInterval) timeout callback:(void (^)(id, NSError *))block;
-(void)removeRecvOfObj:(id)content;
-(void) sendLan:(id)json to:(id)dev timeout:(NSTimeInterval) timeout callback:(void (^)(id, NSError *))block;
-(void) sendLan:(id)json address:(id)address timeout:(NSTimeInterval) timeout callback:(void (^)(id, NSError *))block;

@end

@interface Hekr(Config)
/**
 传入SSID和password进行配网
 
 @param ssid SSID
 @param pwd password
 @param refreshPin 是否需要刷新pinCode
 @param block 配置到新设备后，block会回调设备信息。配网出错原因:1.拉取PinCode失败 2.拉取增量设备列表失败。
 */
-(void) configSearch:(NSString*) ssid pwd:(NSString*) pwd refreshPin:(BOOL)refreshPin callback:(void(^)(id, NSError*)) block; // block 会被调用多次
/**
 传入SSID和password进行配网
 
 @param ssid SSID
 @param pwd password
 @param pinCode pinCode (软AP配网必填)
 @param configType 配网的类型 ConfigDeviceTypeNormal：正常配网 ；ConfigDeviceTypeSoftAP：软AP
 @param block 配置到新设备后，block会回调设备信息。配网出错原因:1.拉取PinCode失败 2.拉取增量设备列表失败
 @param stepBlock 配设备时的步骤：STEP：1 获取PinCode成功；STEP：2 设备连接路由器成功；STEP：3 云端验证设备信息成功；STEP：4 设备登陆云端成功；STEP：5 绑定设备成功
 */
-(void) configSearch:(NSString *)ssid pwd:(NSString *)pwd pinCode:(NSString *)pinCode configType:(ConfigDeviceType )configType callback:(void (^)(id, NSError*))block stepCall:(void (^)(NSDictionary *))stepBlock;
/**
获取pinCode

@param ssid SSID
@param block 回调
*/
- (void)getPINCode:(NSString *)ssid callback:(void (^)(NSString *pin, NSError*err))block;

-(void) stopConfig;
-(void) bindDevice:(id) info callback:(void(^)(id,NSError*)) block;
@end

@interface Hekr(Tool)
//-(void) pickImage:(UIViewController*) control useCamer:(BOOL) camer uploadBlock:(void(^)(NSString*,NSError*)) block;
-(void) scanQRCode:(UIViewController*)controller title:(NSString*) title block:(void(^)(id,id)) block;
-(void) setLocalControl:(HekrLocalControl)control;
-(void) setLocalControl:(HekrLocalControl)control block:(void(^)(HekrLocalControl control))block;
-(HekrLocalControl) getLocalControl;

-(void) setCloudControlWithGlobals:(NSArray *)globals;

@end

@interface Hekr (DeviceFilter)//由外部传入设备数据，用于局域网使用
-(void) onInsertDevices:(NSArray *)devices;
-(void) onInsertDevices:(NSArray *)devices page:(NSInteger )page;
-(void) onDelDevices:(NSDictionary *)device;
-(void) callBackLocalDevicesState:(void(^)(NSString *devTid,NSArray *devices)) openState closeState:(void(^)(NSString *devTid)) closeState;
-(NSArray *) getLanDevcies;
@end

@interface Hekr (SocialManage)
-(NSDictionary *)getSocialTypes;
@end
