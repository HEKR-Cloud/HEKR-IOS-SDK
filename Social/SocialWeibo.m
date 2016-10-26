//
//  HekrUserMgrImp.m
//  HekrSDK
//
//  Created by WangMike on 15/8/5.
//  Copyright (c) 2015年 Hekr. All rights reserved.
//

#import "socialImp.h"
#import <WeiboSDK.h>

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

@interface SocialWeibo : NSObject<socialImp>
@property (nonatomic,copy) void(^authBlock)(id,NSError*);
@end

@implementation SocialWeibo
+(id) instance{
    static id __instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [SocialWeibo new];
    });
    return __instance;
}
-(void) config:(NSDictionary *)dict{
    NSString * key = [dict objectForKey:KeyOfAppKey];
    [WeiboSDK registerApp:key];
}
-(void) auth:(UIViewController *)controller block:(void (^)(id, NSError *))block{
    self.authBlock = block;
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}
-(BOOL) openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WeiboSDK handleOpenURL:url delegate:self];
}
-(void) didReceiveWeiboResponse:(id)response{
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
                WBAuthorizeResponse* tokens = (WBAuthorizeResponse *)response;
        if (tokens.accessToken && tokens.userID) {
            [self callAuth: @{@"certificate":tokens.accessToken,@"uid":tokens.userID} error:nil];
        }else{
            [self callAuth:nil error:nil];
        }
    }
}
-(void) callAuth:(id) token error:(NSError*) error{
    typeof(self.authBlock) block = self.authBlock;
    self.authBlock = nil;
    if (block!=nil) {
        block(token,error);
    }
}
@end