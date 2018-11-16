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
-(void)hekrWebViewDidFail;
-(void)hekrWebViewDidFinish;

@required
/**
 需要vc自己处理的事件

 @param funcName [setStateBarColor(对于web没有把状态栏也覆盖的控制界面，需要自己维护状态栏的背景颜色),screenShot(截屏),close(pop返回上个界面)]
 @param body body
 */
-(void)callFunc:(NSString *)funcName body:(id)body;

@end

@interface HekrWebView : UIView

@property (nonatomic,weak,readonly) WKWebView * webView;

+ (HekrWebView *)viewWithDevice:(NSDictionary *)device language:(NSString *)language protocol:(NSDictionary *)protocol controller:(id<HekrWebViewDelegate>)controller;

+ (HekrWebView *)viewWithGroup:(NSDictionary *)group language:(NSString *)language protocol:(NSDictionary *)protocol controller:(id<HekrWebViewDelegate>)controller;

+ (HekrWebView *)viewWithDevice:(NSDictionary *)device group:(NSDictionary *)group language:(NSString *)language protocol:(NSDictionary *)protocol controller:(id<HekrWebViewDelegate>)controller;


-(void)startLoad;
-(void)reload;
-(void)destory;

/**
 自定义注入的js，格式请严格按照SDK内的HekrWebJSBridge.js
 
 @param js js
 */
- (void) addCustomJavaScript:(NSString *)js;

/**
 事件的返回
 
 @param event event
 @param data data
 */
-(void) evaluateJavaScript:(NSString *)event data:(NSDictionary *)data;

/**
 对addCustomJavaScript的自定义的桥接注册方法名
 需要在startLoad前注册
 
 @param funcName funcName
 @param imp imp 对于非事件处理的方法名，callback必须返回参数，否则就会闪退
 */
-(void)registerFunc:(NSString *)funcName imp:(void(^)(HekrWebView *_,id body,void(^callback)(NSString *))) imp;

@end
