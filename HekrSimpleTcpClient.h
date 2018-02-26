//
//  HekrSimpleTcpClient.h
//  AFNetworking
//
//  Created by 叶文博 on 2018/2/26.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@interface HekrSimpleTcpClient : NSObject

@property (nonatomic ,assign) NSUInteger timeout;//每次连接tcp的超时时间，默认3秒
@property (nonatomic ,assign) NSUInteger connectCount;//每次连接tcp失败后重连次数，默认1次

-(void)createTcpSocket:(NSString *) host onPort:(uint16_t)port connect:(void(^)(HekrSimpleTcpClient *client ,BOOL isConnect)) connect successCallback:(void(^)(HekrSimpleTcpClient *client, NSDictionary *data)) callback;
-(void)reConnectTcpSocket:(NSString *) host onPort:(uint16_t)port;

-(void)writeString:(NSString *)str;
-(void)writeDict:(NSDictionary *)dict;
-(void)disconnect;

@end
