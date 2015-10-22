//
//  ScanDevice.h
//  Hekr
//
//  Created by Michael Scofield on 2015-06-30.
//  Copyright (c) 2015 Michael Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanDevice : NSObject
@property (nonatomic,copy) void(^block)(BOOL);
-(instancetype) initWithToken:(NSString*) token ssid:(NSString*) ssid password:(NSString*) password;
-(void) start;
-(void) cancel;
@end
