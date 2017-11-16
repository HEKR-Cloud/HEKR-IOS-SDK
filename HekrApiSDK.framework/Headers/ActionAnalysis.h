//
//  ActionAnalysis.h
//  HekrSDKAPP
//
//  Created by 单天赛 on 16/12/21.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionAnalysis : NSObject


/**
 {Power = 1;cmdId = 2;}---->4807020602015a

 @param dataJson json数据
 @param protocolJson 协议模板数据
 @return 48串
 */
+ (NSString *)encodeWithDataJson:(NSDictionary *)dataJson protocolJson:(NSDictionary *)protocolJson;

/**
 4807020602015a----> {power:1,cmdId:1}

 @param raw 48串
 @param protocolJson 协议模板数据
 @return json数据
 */
+ (NSDictionary *)decode:(NSString *)raw protocolJson:(NSDictionary *)protocolJson;

/**
 {R = 1;G=1;B=0;cmdId = 1}---->{红:1;绿:1;蓝:0;cmdId:1}

 @param dataJson json数据
 @param protocolJson 协议模板数据
 @return 协议模板json数据
 */
+ (NSDictionary *)encodeWithDataJsonToUI:(NSDictionary *)dataJson protocolJson:(NSDictionary *)protocolJson;
@end
