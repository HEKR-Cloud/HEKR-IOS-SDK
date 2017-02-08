//
//  HekrUserMgrImp.m
//  HekrSDK
//
//  Created by WangMike on 15/8/5.
//  Copyright (c) 2015年 Hekr. All rights reserved.
//

#import "socialImp.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

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


@interface SocialQQ : NSObject<socialImp>
@property (nonatomic,strong) id config;
@property (nonatomic,strong) TencentOAuth* tencentOAuth;
@property (nonatomic,copy) void(^authBlock)(id,NSError*);
@end

@implementation SocialQQ
+(id) instance{
    static id __instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [SocialQQ new];
    });
    return __instance;
}
-(void) config:(NSDictionary *)dict{
    self.config = dict;
}
-(void) auth:(UIViewController *)controller block:(void (^)(id, NSError *))block{
    self.authBlock = block;
    NSString * appId = [self.config objectForKey:KeyOfAppIdKey];
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:appId andDelegate:self];
    [self.tencentOAuth setRedirectURI:@"http://www.qq.com"];
    [self.tencentOAuth authorize:@[@"get_user_info",@"get_simple_userinfo"] inSafari:NO];
}
-(BOOL) openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [TencentOAuth HandleOpenURL:url];
}

- (void)tencentDidLogin {
    NSString *accessToken = self.tencentOAuth.accessToken;
    if (accessToken.length > 0) {
        [self callAuth:@{@"certificate":accessToken,@"uid":self.tencentOAuth.openId} error:nil];
    }
    else {
        [self callAuth:nil error:nil];
    }
}
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        [self callAuth:nil error:nil];
    }
}
- (void)tencentDidNotNetWork {
    [self callAuth:nil  error:nil];
}
-(void) callAuth:(id) token error:(NSError*) error{
    typeof(self.authBlock) block = self.authBlock;
    self.authBlock = nil;
    if (block!=nil) {
        block(token,error);
    }
}

-(void) shareWebView:(NSString *)shareURL devName:(NSString *)devName cidName:(NSString *)cidName captureImg:(UIImage *)captureImg type:(NSInteger)type{
    
    NSData *fData = UIImageJPEGRepresentation(captureImg, 0.5);
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareURL] title:devName description:cidName previewImageData:fData];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    if (type == 0) {
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    }
    else {
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    }
}
@end
