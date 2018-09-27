//
//  HekrWebView.h
//  CocoaAsyncSocket
//
//  Created by 叶文博 on 2018/9/26.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol HekrWebViewDelegate <NSObject>

-(void)viewBodyUpdate;
-(void)setStateBarColor:(UIColor *)color;
-(void)screenShot:(id)body;
-(void)hekrWebViewDidFail;
-(void)hekrWebViewDidFinish;
-(void)callFunc:(NSString *)callFunc body:(id)body;

@end

@interface HekrWebView : UIView

@property (nonatomic,weak,readonly) WKWebView * webView;

+ (HekrWebView *)viewWithDevice:(NSDictionary *)device language:(NSString *)language protocol:(NSDictionary *)protocol controller:(id<HekrWebViewDelegate>)controller;

+ (HekrWebView *)viewWithGroup:(NSDictionary *)group language:(NSString *)language protocol:(NSDictionary *)protocol controller:(id<HekrWebViewDelegate>)controller;

-(void)startLoad;
-(void)reload;

@end
