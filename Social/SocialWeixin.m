//
//  HekrUserMgrImp.m
//  HekrSDK
//
//  Created by WangMike on 15/8/5.
//  Copyright (c) 2015年 Hekr. All rights reserved.
//

#import "socialImp.h"
#import <WeixinSDK/WXApi.h>

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

@interface SocialWeixin : NSObject<socialImp>
@property (nonatomic,copy) void(^authBlock)(id,NSError*);
@end

@implementation SocialWeixin
+(id) instance{
    static id __instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [SocialWeixin new];
    });
    return __instance;
}
-(void) config:(NSDictionary *)dict{
    [WXApi registerApp:[dict objectForKey:KeyOfAppIdKey]];
}
-(void) auth:(UIViewController *)controller block:(void (^)(id, NSError *))block{
    self.authBlock = block;
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        SendAuthReq *baseResp = [[SendAuthReq alloc] init];
        baseResp.scope = @"snsapi_userinfo";
        [WXApi sendReq:baseResp];
    }
    else{
        [self callAuth:nil error:nil];
    }
}
-(BOOL) openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self];
}
-(void) onResp:(id)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *auth = (SendAuthResp *)resp;
        if(auth.code){
            return [self callAuth:@{@"certificate":auth.code} error:nil];
        }
        else{
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

-(void)shareWebView:(NSString *)shareURL devName:(NSString *)devName cidName:(NSString *)cidName captureImg:(UIImage *)captureImg type:(NSInteger)type{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = devName;
    message.description = cidName;
    [message setThumbImage:captureImg];
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = shareURL;
    message.mediaObject = webpageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = type==2?WXSceneSession:WXSceneTimeline;
    [WXApi sendReq:req];
}

@end
