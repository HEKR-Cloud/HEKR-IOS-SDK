//
//  HekrWebView.h
//  HekrSDK
//
//  Created by WangMike on 15/8/4.
//  Copyright (c) 2015年 Hekr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HekrWebView : UIWebView
@end

@protocol HekrViewController <NSObject>
@property (nonatomic,readonly) NSDictionary * param;
@property (nonatomic,readonly) NSURL * templateURL;
-(void) jumpTo:(NSURL*) url currentController:(UIViewController *)controller divName:(NSString *)divName cidName:(NSString *)cidName;
-(void) backTo:(NSString*) path animation:(BOOL) animation;
@end

@interface UIViewController (Hekr)<HekrViewController>

@end

@interface HekrWebViewController : UIViewController
@property (nonatomic,weak,readonly) HekrWebView * webView;
-(void)share:(NSString *)info divName:(NSString *)divName cidName:(NSString *)cidName;
-(void)fingerprintIdentification:(void(^)(BOOL))block;
-(void)viewBodyUpdate;
@end
