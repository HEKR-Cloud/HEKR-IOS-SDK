//
//  HekrAPI.h
//  CocoaAsyncSocket
//
//  Created by 叶文博 on 2018/9/25.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ConfigDeviceType) {
    ConfigDeviceTypeNormal,
    ConfigDeviceTypeSoftAP,
};

@interface HekrAPI : NSObject

+(void) startWithConfig:(NSDictionary*) config;

+(void) loginWithUser:(NSDictionary *)user;

+(void) loginWithToken:(NSString *)token;

+(void) logout;


/**
 获取第三方返回的数据
 
 @param type 第三方类型
 @param controlelr 当前vc界面
 @param block 回调
 */
+(void) oauth:(NSString *)type controller:(UIViewController *)controlelr  callback:(void(^)(NSDictionary * tokens,NSError*)) block;

/**
 获取第三方需要在AppDelegate application:openURL:sourceApplication:annotation传递数据

 @param url url
 @param sourceApplication s
 @param annotation a
 @return YES/NO
 */
+(BOOL) openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

/**
 传入SSID和password进行配网
 
 @param ssid SSID
 @param pwd password
 @param pinCode pinCode (软AP配网必填)
 @param configType 配网的类型 ConfigDeviceTypeNormal：正常配网 ；ConfigDeviceTypeSoftAP：软AP
 @param stepCallBack 配设备时的步骤：STEP：1 获取PinCode成功；STEP：2 设备连接路由器成功；STEP：3 云端验证设备信息成功；STEP：4 设备登陆云端成功；STEP：5 绑定设备成功
 */
+(void) configSearch:(NSString *)ssid pwd:(NSString *)pwd pinCode:(NSString *)pinCode configType:(ConfigDeviceType )configType stepCallBack:(void (^)(id msg, NSString *address))stepCallBack;

+(void) stopConfig;

/**
 udp发送配网过程中发送到设备的指令
 
 @param msg 指令
 @param address 地址
 */

+(void) sendConfigMsg:(id)msg address:(NSString *)address;

/**
 监听sendConfigMsg回调回来的数据
 */
+(void) setConfigContentCallBack:(void (^)(id msg, NSString *address))contentCallBack;


+(void) send:(id)json to:(NSString *)to withoutComplate:(BOOL)complate callback:(void (^)(id, NSError *))block;

+(void) sendNet:(id)json toHost:(NSString *)host timeout:(NSTimeInterval) timeout callback:(void (^)(id, NSError *))block;

+(void) sendLAN:(id)json toAddr:(NSString *)address timeout:(NSTimeInterval) timeout callback:(void (^)(id, NSError *))block;

+(void) sendLAN:(id)json toAddr:(NSString *)address port:(NSString *)port timeout:(NSTimeInterval) timeout callback:(void (^)(id, NSError *))block;


/**
 用来监听websocket或局域网返回的数据

 @param obj 标识对象 当该对象释放后将不再接收消息
 @param filter 过滤条件 如果某个key的值为NSNull表示只检查该key是否存在
 @param block 回调
 */
+(void) addRecv:(id)obj filter:(id) filter callback:(void(^)(id obj,id msg)) block;

/**
 删除接收设备信息中相应的标识对象的回调

 @param obj 标识对象
 */
+(void) removeRecv:(id)obj;

/**
 打开/关闭局域网

 @param enable true/false
 */
+(void) enableLAN:(BOOL)enable;

/**
 当前路由器下对应的设备信息列表

 @param deviceList 设备信息列表
 */
+(void) sendLanAuthDeviceList:(NSArray *)deviceList;

/**
 监听返回发送到SDK，对应设备列表的是否局域网在线
 {
 ctrlKey:xxxx,
 online:true/false,
 }
 */
+(void) onLanCallBack:(void (^)(NSArray *deviceList))callback;

+(void) setConnectHosts:(NSArray *)connectHosts;


@end
