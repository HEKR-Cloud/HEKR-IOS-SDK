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

extern NSString * HekrSDKUserChangeNotification;

extern NSString * KeyOfHekr;//@"Hekr"
extern NSString * KeyOfPush;//@"push"
extern NSString * KeyOfSocial;//@"Social"
extern NSString * KeyOfAppIdKey;//@"AppId"
extern NSString * KeyOfAppKey;//@"AppKey"
extern NSString * KeyOfAppSecurit;//@"AppSecurit"
extern NSString * KeyOfSocialWeibo;//@"Weibo"
extern NSString * KeyOfSocialQQ;//@"QQ"
extern NSString * KeyOfSocialWeixin;//@"Weixin"
extern NSString * KeyOfSocialFacebook;//@"Facebook"
extern NSString * KeyOfSocialGoogle;//@"Google"
extern NSString * KeyOfSocialTwitter;//@"Twitter"

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
@end