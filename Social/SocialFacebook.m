
#import "socialImp.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

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

@interface  SocialFacebook: NSObject<socialImp>
@property (nonatomic,strong) FBSDKLoginManager * fbLoginMgr;
@end

@implementation SocialFacebook
+(id) instance{
    static id __instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[SocialFacebook alloc] init];
    });
    return __instance;
}
-(void) config:(NSDictionary *)dict{
    [FBSDKSettings setAppID:[dict objectForKey:KeyOfAppIdKey]];
}
-(void) auth:(UIViewController *)controller block:(void (^)(id, NSError *))block{
    self.fbLoginMgr = [[FBSDKLoginManager alloc] init];
    [self.fbLoginMgr logInWithPublishPermissions:@[] fromViewController:controller handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (!result.isCancelled && result.token){
            !block?:block(@{@"certificate":result.token.tokenString,@"uid":result.token.userID},nil);
        }else{
            !block?:block(nil,error);
        }
    }];
}
-(BOOL) openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[FBSDKApplicationDelegate sharedInstance] application:[UIApplication sharedApplication] openURL:url sourceApplication:sourceApplication annotation:annotation];
}
@end