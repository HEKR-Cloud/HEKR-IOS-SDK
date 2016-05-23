//
//  HekrUserMgrImp.m
//  HekrSDK
//
//  Created by WangMike on 15/8/5.
//  Copyright (c) 2015年 Hekr. All rights reserved.
//

#import "socialImp.h"
#import <Google/SignIn.h>
#import <GoogleSignIn/GoogleSignIn.h>

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

@interface SocialGoogle : NSObject<socialImp>
@property (nonatomic,copy) void(^authBlock)(id,NSError*);
@property (nonatomic,weak) UIViewController *controller;
@end

@implementation SocialGoogle
+(id) instance{
    static id __instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [SocialGoogle new];
    });
    return __instance;
}
-(void) config:(NSDictionary *)dict{
    NSError * err = nil;
    [[GGLContext sharedInstance] configureWithError: &err];
    [[GIDSignIn sharedInstance] setDelegate:self];
    [[GIDSignIn sharedInstance] setUiDelegate:self];
    
}
-(void) auth:(UIViewController *)controller block:(void (^)(id, NSError *))block{
    self.authBlock = block;
    self.controller = controller;
    [[GIDSignIn sharedInstance] signIn];
}
-(BOOL) openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
}
- (void)signIn:(id)signIn presentViewController:(UIViewController *)viewController{
    [self.controller presentViewController:viewController animated:YES completion:nil];
}
- (void)signIn:(id)signIn dismissViewController:(UIViewController *)viewController{
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}
- (void)signIn:(id)signIn didSignInForUser:(GIDGoogleUser*)user withError:(NSError *)error{
    if (user && !error){
        [self callAuth:@{@"certificate":user.authentication.accessToken,@"uid":user.userID} error:nil];
    }else{
        [self callAuth:nil  error:nil];
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
