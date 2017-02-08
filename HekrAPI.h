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
    HekrLocalControlOn,
    HekrLocalControlOff,
};

typedef NS_ENUM(NSUInteger, HekrSSOType) {
    HekrSSOLogin,
    HekrSSOBind,
    HekrShareSina,
};

@interface Hekr(Cloud)
-(AFNetworkReachabilityManager*) reachability;
-(AFHTTPSessionManager*) sessionWithDefaultAuthorization;
//-(AFHTTPSessionManager*) sessionWithAuthorization:(NSString*) headerValue;
@end

@interface Hekr(User)
-(void) login:(NSString*)userName password:(NSString*) password callbcak:(void(^)(id user,NSError*)) block;
-(void) sso:(NSString*) type controller:(UIViewController*) controlelr ssoType:(HekrSSOType)ssotype callback:(void(^)(id token,id user,NSError*)) block;
-(void) logout;
@end

@interface Hekr(Net)
-(void) setLocalControl:(HekrLocalControl)control;
-(void) setLocalControl:(HekrLocalControl)control block:(void(^)(HekrLocalControl control))block;
-(HekrLocalControl) getLocalControl;
-(void) send:(id) json to:(id) dev callback:(void(^)(id data,NSError*)) block;
-(void) recv:(id) filter obj:(id) obj callback:(void(^)(id obj,id data,NSError*)) block;
-(void) sendNet:(id)json to:(id)dev timeout:(NSTimeInterval) timeout callback:(void (^)(id, NSError *))block;
@end

@interface Hekr(Config)
-(void) configSearch:(NSString*) ssid pwd:(NSString*) pwd callback:(void(^)(id, NSError*)) block; // block 会被调用多次
-(void) stopConfig;
-(void) bindDevice:(id) info callback:(void(^)(id,NSError*)) block;
@end

@interface Hekr(Tool)
//-(void) pickImage:(UIViewController*) control useCamer:(BOOL) camer uploadBlock:(void(^)(NSString*,NSError*)) block;
-(void) scanQRCode:(UIViewController*)controller title:(NSString*) title block:(void(^)(id,id)) block;
@end
