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
@property(assign)NSInteger count;
@property(strong)GCDAsyncUdpSocket *udpSocket;
@property(copy)NSString *msg;
@property(copy)NSString *ssid;
@property(copy)NSString *pwd;
@property(assign)NSTimeInterval mtime;
@property(strong)NSMutableData *data;
@property(assign)BOOL finishFlag;

@property(assign)long tag;

@property (nonatomic,strong) NSString* deviceToken;
@end

@implementation ScanDevice
-(instancetype) initWithToken:(NSString *)token ssid:(NSString *)ssid password:(NSString *)password{
    self = [super init];
    if (self) {
        self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        self.mtime=0.005;
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
    self.msg =[NSString stringWithFormat:@"%@\x00%@\x00",self.ssid,self.pwd];
    
    NSError *error = nil;
    if ([self.udpSocket enableBroadcast:YES error:&error] &&[self.udpSocket bindToPort:10000 error:&error] && [self.udpSocket beginReceiving:&error]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self  scanDevice];
        });
    }else{
        !self.block?:self.block(NO);
    }
}
-(void) cancel{
    self.block = nil;
    [self stopSend];
    [self.udpSocket close];
}


//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        
//        self.scandBroadcast = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scanBroadcastFunc) userInfo:nil repeats:YES];
//        self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//
//        NSError *error = nil;
//        
//        if (![self.udpSocket bindToPort:10000 error:&error])
//        {
//            NSLog(@"Error binding:%@",error);
//            
//        }
//        if (![self.udpSocket beginReceiving:&error])
//        {
//            NSLog(@"Error receiving: %@",error);
//        }
//        self.mtime=0.005;
//    }
//    return self;
//}

-(void)scanDevice
{
    //    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    self.finishFlag = NO;
    NSString *address1 = [NSString stringWithFormat:@"224.127.%lu.255",(unsigned long)self.msg.length];
    NSData *data1 = [@"hekrconfig" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data2 = [@"merci" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data3 = [[NSString stringWithFormat:@"(ak \"%@\")",self.deviceToken] dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"start");
    NSDate * startTime = [NSDate date];
    while ([[NSDate date] timeIntervalSinceDate:startTime] < 60) {
        for (int i =0;i<4;i++) {
            for (int i =0;i<self.msg.length;i++) {
                NSString *address = [NSString stringWithFormat:@"224.%d.%d.255",i,[self.msg characterAtIndex:i]];
                //            NSLog(@"send to address :%@ index :%d",address, j);
                [self.udpSocket sendData:data1 toHost:address port:7001 withTimeout:-1 tag:self.tag];
                self.tag++;
                sleep(0.02);
                if (self.finishFlag)
                {
                    break;
                }
            }
            
            [self.udpSocket sendData:data2 toHost:address1 port:7001 withTimeout:-1 tag:self.tag++];
            sleep(0.1);
        }
        [self.udpSocket sendData:data3 toHost:@"255.255.255.255" port:10000 withTimeout:-1 tag:self.tag++];
        if (self.finishFlag)
        {
            break;
        }
        sleep(1);
    }
    NSLog(@"end");
    [self.udpSocket close];
    typeof(self.block) block = self.block;
    self.block = nil;
    !block?:block(self.finishFlag);
}

- (void)stopSend
{
    self.block = nil;
    self.finishFlag = YES;
}

//-(void)sendPasswordToSSID:(NSString *)passowrd ssidName:(NSString *)name Mtime:(NSInteger)mtime
//{
//    NSString *string = @"";
//    if (passowrd.length >0) {
//        string = [NSString stringWithFormat:@"%@\x00%@\x00",name,passowrd];
//    }else{
//        string = [NSString stringWithFormat:@"%@\x00\x00",name,passowrd];
//    }
//  
//    self.mtime=mtime * 1000;
//    self.ssid=name;
////    self.pwd=passowrd;
////    if ([self.pwd length] == 0)
////    {
////        NSLog(@"Message required");
////        return;
////    }
//    self.msg =string;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self  scanDevice];
//    });
//   
//
//}
//-(void)scanBroadcastFunc
//{
////    NSData *data1 = [@"(discover \"\ \"\ \"\ \"\)" dataUsingEncoding:NSUTF8StringEncoding];
////    [self.udpSocket enableBroadcast:YES error:nil];
////    [self.udpSocket sendData:data1 toHost:@"255.255.255.255" port:10000 withTimeout:-1 tag:self.tag];
////    self.tag++;
//}
//-(void)cancelAllScan
//{
//    [self.scanTimer invalidate];
//    self.scanTimer = nil;
//    [self.scandBroadcast invalidate];
//    self.scandBroadcast=nil;
//}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    // You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    // You could add checks here
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

        if (self.count == 0) {
            NSLog(@"RECV: %@", msg);
            NSString *host = nil;
            uint16_t port = 0;
            [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
            NSString *fd = [NSString stringWithFormat:@"(ak \"%@\")",self.deviceToken];
            NSData *data = [fd dataUsingEncoding:NSUTF8StringEncoding];
            [self.udpSocket sendData:data toHost:host port:10000 withTimeout:-1 tag:self.tag];
            self.count++;
        }
        if ([msg rangeOfString:@"deviceACK"].location != NSNotFound){
            NSLog(@"RECV: %@", msg);
            self.count=0;
            NSLog(@"配置成功");
            self.finishFlag=YES;
            [self.udpSocket close];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_SUCCESS" object:nil];
            
            typeof(self.block) block = self.block;
            self.block = nil;
            !block?:block(self.finishFlag);
        }
    }
    else
    {
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
       
        NSLog(@"RECV: Unknown message from: %@:%hu", host, port);
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
