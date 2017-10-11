//
//  HekrUser.h
//  HekrSDK
//
//  Created by WangMike on 15/7/31.
//  Copyright (c) 2015年 Hekr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HekrUserToken : NSObject
@property (nonatomic,strong,readonly) NSString * uid;
@property (nonatomic,strong,readonly) NSString * access_token;
@property (nonatomic,strong,readonly) NSString * ezviz_token;
@end
