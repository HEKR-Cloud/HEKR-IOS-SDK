//
//  ViewController.m
//  TestHekrSDK
//
//  Created by 叶文博 on 2017/9/22.
//  Copyright © 2017年 ye_wenbo. All rights reserved.
//

#import "ViewController.h"
#import <HekrApiSDK/HekrApiSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.navigationController.navigationBar.alpha = 0;
    
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    
    

    
}

- (void)config1:(id)sender {
    //开启
    [[Hekr sharedInstance] configSearch:@"" pwd:@"" refreshPin:YES callback:^(id dev, NSError *err) {
        
    }];
    //关闭
    [[Hekr sharedInstance] stopConfig];
}

- (void)config2:(id)sender {
    //开启
    NSDictionary * sendJson = @{@"action" : @"appSend",
                                @"params" : @{
                                        @"devTid" : @"网关的xx",
                                        @"ctrlKey" : @"网关的xx",
                                        @"appTid" : @"",
                                        @"subDevTid" : [NSNull null],
                                        @"data" : @{
                                                @"cmdId" : @2,
                                                @"subMid" : @"xx",
                                                @"overtime" : @80,//表示配网时间
                                                }
                                        }
                                };
    //监听addSubDev
    NSDictionary * recvJson = @{@"action" : @"addSubDev",
                                @"params" : @{
                                        @"devTid" : @"网关的xx",
                                        @"subMid" : @"xx"
                                        }
                                };
    
    [[Hekr sharedInstance] recv:recvJson obj:self callback:^(id obj, id data, NSError *error) {
        NSLog(@"configZigbee : %@",data);
        if (data&&[data isKindOfClass:[NSDictionary class]]) {
            
        }
    }];
    
    [[Hekr sharedInstance] sendNet:sendJson to:nil timeout:100 callback:^(id data, NSError *error) {
        if (data&& [[data objectForKey:@"code"] integerValue] == 200) {
        }else{
            [[Hekr sharedInstance] removeRecvOfObj:self];
        }
    }];
    
    //关闭
    [[Hekr sharedInstance] removeRecvOfObj:self];
    NSDictionary * json = @{@"action" : @"appSend",
                                @"params" : @{
                                        @"devTid" : @"网关的xx",
                                        @"ctrlKey" : @"网关的xx",
                                        @"appTid" : @"",
                                        @"subDevTid" : [NSNull null],
                                        @"data" : @{
                                                @"cmdId" : @2,
                                                @"subMid" : @"xx",
                                                @"overtime" : @0,//关闭配网，防止停止了动画还能配上设备
                                                }
                                        }
                                };
    [[Hekr sharedInstance] sendNet:json to:nil timeout:10 callback:^(id data, NSError *error) {}];
}

- (void)device1:(id)sender {
    /*
     独立设备,和网关
     openType=push默认拼接在后面
     */
    [self jumpTo:[NSURL URLWithString:@"https://allinone-ufile.hekr.me/h5page/58198e66e4b07be12e83d63b/index.html?devTid=ESP_2M_5CCF7F2EA957&ctrlKey=9a7dd45fa23a437dbfc2b3857d0a3535&ppk=k0wfHypbzGlO+UdZZOIJqCz/T07ei7fWyBICy9divx7q23JDyKZ6LMP78Zimv/QoeZ&lang=en-US&openType=push"] currentController:self divName:@"" cidName:@""];
}

- (void)device2:(id)sender {
    /*
     //子设备:
     devTid是网关的tid，接口数据去parentDetTid
     subDevTid是子设备的tid，接口数据去devTid
     ctrlKey是网关的ctrlKey，接口数据去parentCtrlKey
     openType=push默认拼接在后面
     */
    
    [self jumpTo:[NSURL URLWithString:@"https://allinone-ufile.hekr.me/h5page/58198e66e4b07be12e83d63b/index.html?devTid=xxxxxxx&subDevTid=xxxxxxx&ctrlKey=9a7dd45fa23a437dbfc2b3857d0a3535&ppk=k0wfHypbzGlO+UdZZOIJqCz/T07ei7fWyBICy9divx7q23JDyKZ6LMP78Zimv/QoeZ&lang=en-US&openType=push"] currentController:self divName:@"" cidName:@""];
}

-(void)sceneAction:(NSString *)sceneId{
    id json = @{@"action":@"sceneTriggerSend",
                @"msgId":@"0",
                @"params":@{@"uid":[Hekr sharedInstance].user.uid,
                            @"sceneId":sceneId,
                            @"appTid":@""}};
    [[Hekr sharedInstance] sendNet:json to:nil  timeout:20 callback:^(id responseObject, NSError *error) {
        
    }];
}

-(void)qrcode:(NSDictionary*)dic{
    NSString *devTid = dic[@"devTid"];
    //    获取绑定状态 是否被绑 是否允许强绑
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:@"http://user.openapi.hekr.me/deviceBindStatus" parameters:@[dic] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"[设备是否允许强绑]：%@",responseObject);
        NSLog(@"check devices:[%@]%@",devTid,responseObject);
        id dict = [responseObject firstObject];
        if ([[dict objectForKey:@"devTid"] isEqualToString:devTid] && (![dict[@"bindToUser"] boolValue] || [dict[@"forceBind"] boolValue])) {
            //绑定
            [[Hekr sharedInstance] bindDevice:dic callback:^(id responseObject, NSError * error) {
                if (responseObject && [responseObject objectForKey:@"ctrlKey"] && [responseObject objectForKey:@"logo"]) {
//                    [self toast:@"绑定成功"];
                }else{
//                    [self toast:@"绑定失败"];
                }
            }];
        }else{
            //获取被绑定设备属主信息
            [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:@"http://user.openapi.hekr.me/queryOwner" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"[查询设备属主信息]：%@",responseObject);
//                [self toast:[NSString stringWithFormat:@"已被%@绑定",responseObject[@"message"]]];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                [self toast:@"绑定失败"];
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self toast:@"绑定失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
