//
//  ScanDevice.m
//  Hekr
//
//  Created by Michael Scofield on 2015-06-30.
//  Copyright (c) 2015 Michael Hu. All rights reserved.
//

#import "ScanDevice.h"
#import "GCDAsyncUdpSocket.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface ScanDevice()
@property(strong)NSTimer *scanTimer;
@property(strong)NSTimer *scandBroadcast;
//@property(assign)NSInteger count;
@property(strong)GCDAsyncUdpSocket *udpSocket;
//@property(copy)NSString *msg;
@property(copy)NSString *ssid;
@property(copy)NSString *pwd;
//@property(assign)NSTimeInterval mtime;
//@property(strong)NSMutableData *data;
@property(assign)BOOL finishFlag;

//@property(assign)long tag;

@property (nonatomic,strong) NSArray * datas;

@property (nonatomic,strong) NSString* deviceToken;
@end

@implementation ScanDevice
-(instancetype) initWithToken:(NSString *)token ssid:(NSString *)ssid password:(NSString *)password{
    self = [super init];
    if (self) {
        self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//        self.mtime=0.005;
        self.ssid = ssid ? ssid : @"";
        self.pwd = password ? password : @"";
        self.deviceToken = token ? token : @"";
    }
    return self;
}
-(void) dealloc{
    [self cancel];
}
-(void) start{
    self.datas = [self makeDatas:[NSString stringWithFormat:@"%@\x00%@\x00",self.ssid,self.pwd]];
    
    NSError *error = nil;
    if ([self.udpSocket enableBroadcast:YES error:&error] &&[self.udpSocket bindToPort:10000 error:&error] && [self.udpSocket beginReceiving:&error]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [self sendIndex:0];
            [self sendDatas];
        });
    }else{
        NSLog(@"scan device bind error:%@",error);
        !self.block?:self.block(NO,nil);
    }
}
-(void) cancel{
    self.block = nil;
    self.block = nil;
    self.finishFlag = YES;
    [self.udpSocket close];
}
-(NSArray*) makeDatas:(NSString*) msg{
    NSMutableArray * arrs = [NSMutableArray array];
    NSData * msgData = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *address1 = [NSString stringWithFormat:@"224.127.%lu.255",(unsigned long)msgData.length];
    NSData *data1 = [@"hekrconfig" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data2 = [@"merci" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data3 = [[NSString stringWithFormat:@"(ak \"%@\")",self.deviceToken] dataUsingEncoding:NSUTF8StringEncoding];
    
    for (int i =0;i<msgData.length;i++) {
        NSString *address = [NSString stringWithFormat:@"224.%d.%d.255",i, (((unsigned char *)msgData.bytes)[i]) & 0xff];
        [arrs addObject:@{@"addr":address,@"port":@(7001),@"data":data1}];
    }
    [arrs addObject:@{@"addr":address1,@"port":@(7001),@"data":data2}];
    
    [arrs addObject:@{@"addr":@"255.255.255.255",@"port":@(10000),@"data":data3}];
    
    return arrs;
}
-(void) sendDatas{
    NSTimeInterval slp = .1f / self.datas.count;
    NSDate * date = [NSDate date];
    NSTimeInterval t;
    while ((t = [[NSDate date] timeIntervalSinceDate:date]) < 60 && !self.finishFlag) {
//        NSLog(@"send one");
        for (id data in self.datas) {
            if((![[data objectForKey:@"addr"] isEqualToString:@"255.255.255.255"]) || [[NSDate date] timeIntervalSinceDate:date] > 1){
                [self.udpSocket sendData:[data objectForKey:@"data"] toHost:[data objectForKey:@"addr"] port:[[data objectForKey:@"port"] intValue] withTimeout:1 tag:0];
            }
            [NSThread sleepForTimeInterval:slp * (1 + MAX(t - 3,0.0) / 6)];
        }
    }
    [self.udpSocket close];
    typeof(self.block) block = self.block;
    self.block = nil;
    !block?:block(self.finishFlag,nil);
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
//    [self sendIndex:++tag];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
//    [self sendIndex:tag];
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    NSString *host = nil;
    uint16_t port = 0;
    [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
    NSArray *array = [host componentsSeparatedByString:@":"];
    NSString *host1 = [[self class] getAddress];
    if ([host1 isEqualToString:[array lastObject]]) {
        return;
    }
    
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (msg)
    {
        NSLog(@"RECV: %@", msg);
        if ([msg rangeOfString:@"deviceACK"].location != NSNotFound){
            NSString * tid = nil;
            NSScanner * scanner = [NSScanner scannerWithString:msg];
            [scanner scanString:@"(" intoString:nil];
            [scanner scanString:@"deviceACK" intoString:nil];
            [scanner scanString:@"\"" intoString:nil];
            [scanner scanUpToString:@"\"" intoString:&tid];
            NSLog(@"配置成功");
            self.finishFlag=YES;
            [self.udpSocket close];
            
            typeof(self.block) block = self.block;
            self.block = nil;
            !block?:block(YES,tid);
        }
    }
}

+(NSString*)getAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
@end
