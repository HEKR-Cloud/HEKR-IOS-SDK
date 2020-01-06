//
//  HekrWebView.h
//  HekrSDK
//
//  Created by WangMike on 15/8/4.
//  Copyright (c) 2015年 Hekr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface HekrWebView : WKWebView
@end

@protocol HekrViewController <NSObject>
@property (nonatomic,readonly) NSDictionary * param;
@property (nonatomic,readonly) NSURL * templateURL;
-(void) jumpTo:(NSURL*) url currentController:(UIViewController *)controller devData:(NSDictionary *)data devProtocol:(NSDictionary *)protocol;
-(void) jumpTo:(NSURL*) url currentController:(UIViewController *)controller devData:(NSDictionary *)data devProtocol:(NSDictionary *)protocol domain:(NSString *)domain;

-(void) groupJumpTo:(NSURL*) url currentController:(UIViewController *)controller devData:(NSDictionary *)data devProtocol:(NSDictionary *)protocol domain:(NSString *)domain deviceList:(NSArray *)deviceList;

-(void) backTo:(NSString*) path animation:(BOOL) animation;
@end

@interface UIViewController (Hekr)<HekrViewController>

@end

@interface HekrWebViewController : UIViewController
@property (nonatomic,weak,readonly) HekrWebView * webView;
- (instancetype)initDevData:(NSDictionary *)data devProtocol:(NSDictionary *)protocol;
-(void)share:(NSString *)info;
-(void)fingerprintIdentification:(void(^)(BOOL))block;
-(void)viewBodyUpdate;
-(void)resetDevice:(NSDictionary *)device;

@end
