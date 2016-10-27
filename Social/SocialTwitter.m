//
//  HekrUserMgrImp.m
//  HekrSDK
//
//  Created by WangMike on 15/8/5.
//  Copyright (c) 2015年 Hekr. All rights reserved.
//

#import "socialImp.h"
#import <TwitterCore/TwitterCore.h>
#import <TwitterKit/TwitterKit.h>

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

@interface SocialTwitter : NSObject<socialImp>

@end

@implementation SocialTwitter
+(id) instance{
    static id __instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [SocialTwitter new];
    });
    return __instance;
}
-(void) config:(NSDictionary *)dict{
    [[Twitter sharedInstance] startWithConsumerKey:[dict objectForKey:KeyOfAppKey] consumerSecret:[dict objectForKey:KeyOfAppSecurit]];
}
-(void) auth:(UIViewController *)controller block:(void (^)(id, NSError *))block{
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            
            !block?:block(@{@"certificate":session.authToken,@"uid":session.userID,@"certificateSecret":session.authTokenSecret},nil);
        } else {
            !block?:block(nil,error);
        }
    }];
}
-(BOOL) openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return NO;
}

@end