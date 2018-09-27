//
//  HekrSDK.h
//  HekrSDK
//
//  Created by WangMike on 15/7/31.
//  Copyright (c) 2015年 Hekr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HekrUserToken.h"
#import "HekrAPI.h"

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

@interface Hekr : NSObject

@property (nonatomic,strong,readonly) HekrUserToken * user;
@property (nonatomic,copy) NSDictionary * localData;//局域网成功连上的设备数据key:设备的ctrlKey value：IP
@property (nonatomic,assign,readonly) HekrLocalControl localControlState;

+(instancetype) sharedInstance;

@end
