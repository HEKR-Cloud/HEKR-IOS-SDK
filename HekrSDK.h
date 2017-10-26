//
//  HekrSDK.h
//  HekrSDK
//
//  Created by WangMike on 15/7/31.
//  Copyright (c) 2015年 Hekr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HekrUserToken.h"
#import "HekrWebView.h"

extern NSString * const HekrSDKUserChangeNotification;

extern NSString * const KeyOfHekr;//@"Hekr"
extern NSString * const KeyOfPush;//@"push"
extern NSString * const KeyOfSocial;//@"Social"
extern NSString * const KeyOfAppIdKey;//@"AppId"
extern NSString * const KeyOfAppKey;//@"AppKey"
extern NSString * const KeyOfAppSecurit;//@"AppSecurit"
extern NSString * const KeyOfSocialWeibo;//@"Weibo"
extern NSString * const KeyOfSocialQQ;//@"QQ"
extern NSString * const KeyOfSocialWeixin;//@"Weixin"
extern NSString * const KeyOfSocialFacebook;//@"Facebook"
extern NSString * const KeyOfSocialGoogle;//@"Google"
extern NSString * const KeyOfSocialTwitter;//@"Twitter"

typedef UIViewController*(^HekrNativeControllerGenerator)();

@interface Hekr : NSObject
@property (nonatomic,strong,readonly) NSString * pid;
@property (nonatomic,strong,readonly) HekrUserToken * user;

+(instancetype) sharedInstance;
-(void) config:(NSDictionary*) config startPage:(NSString*) url launchOptions:(NSDictionary*) launchOptions;
-(void) didReceiveRemoteNotification:(NSDictionary*) userInfo;
-(BOOL) openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

-(HekrWebViewController*) webViewFor:(NSString*) url;
-(UIViewController*) firstPage;

-(void) didRegisterUserNotificationSettings:(UIUserNotificationSettings*) settings;
-(void) registNotificationsWithDeviceToken:(NSData*) data;
-(void) setNotificationHandle:(void(^)(id note,BOOL isUserSelected)) handle;

-(void) registNativeControll:(HekrNativeControllerGenerator)generator forTemplate:(NSString*) templateName resource:(NSString*) resource;

-(void) callwebsocketHandle:(void(^)(id data,BOOL isLoop)) handle;
-(BOOL) getWebsocketSendLoop;
-(void) callWebSocketErrorHandle:(void(^)(NSDictionary *data)) handle;

@end
