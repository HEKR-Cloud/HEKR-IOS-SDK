//
//  HekrSDK.h
//  HekrSDK
//
//  Created by WangMike on 15/7/31.
//  Copyright (c) 2015年 Hekr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HekrSDK.h"

@interface Hekr (logic)
-(void) guestLogin;
-(BOOL) loginWith:(NSString*) social controller:(UIViewController*)controller block:(void(^)(NSString*,NSError*)) block;

-(BOOL) loadURL:(NSURL*) url from:(UIViewController*) controller;
-(void) backTo:(NSString*) path animation:(BOOL) animation controller:(UIViewController*) controller;
-(void) upImage:(UIViewController*) control useCamer:(BOOL) camer block:(void(^)(NSString*,NSError*)) block;
@end