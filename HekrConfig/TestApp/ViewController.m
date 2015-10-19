//
//  ViewController.m
//  TestApp
//
//  Created by WangMike on 15/8/3.
//  Copyright (c) 2015年 Hekr. All rights reserved.
//

#import "ViewController.h"
#import "HekrConfig.h"
#import "KVNProgress.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface ViewController ()
@property (nonatomic,weak) IBOutlet UITextField * deviceToken;
@property (nonatomic,weak) IBOutlet UITextField * currentWifi;
@property (nonatomic,weak) IBOutlet UITextField * password;
@property (nonatomic,weak) IBOutlet UITextView  * apList;
@end

@implementation ViewController
-(NSString*) currentWifiSSID{ // Does not work on the simulator.
    NSString *ssid = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"SSID"]) {
            ssid = info[@"SSID"];
        }
    }
    return ssid;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [KVNProgress showProgress:0];
    self.currentWifi.text = [self currentWifiSSID];
    [self getToken:^(NSString * token) {
        self.deviceToken.text = token;
        [KVNProgress dismiss];
    }];
}
-(void) getToken:(void(^)(NSString*)) block{
    typeof(block) mainBlock = ^(NSString* t){
      dispatch_async(dispatch_get_main_queue(), ^{
          block(t);
      });
    };
    
    NSString * url = [NSString stringWithFormat:@"http://user.hekr.me/user/guestAccount.json?ver=1.0&mobileuuid=%@",[[UIDevice currentDevice] identifierForVendor].UUIDString];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * data, NSURLResponse * response, NSError *  error) {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (json) {
            NSString * csrf = [json objectForKey:@"_csrftoken_"];
            NSString * url = [NSString stringWithFormat:@"http://user.hekr.me/token/generate.json?_csrftoken_=%@&type=DEVICE",csrf];
            [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * data, NSURLResponse * response, NSError *  error) {
                id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                mainBlock([json objectForKey:@"token"]);
            }] resume];
        }else{
            mainBlock(nil);
        }
    }] resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(IBAction) onOK:(id)sender{
    if (self.deviceToken.text.length <= 0) {
        return [self showMsg:@"please set deviceToken"];
    }
    if ([self.currentWifi text].length <= 0) {
        return [self showMsg:@"please connect to a wifi"];
    }
    if (self.password.text.length <= 0) {
        return [self showMsg:@"plase set password"];
    }
    [[HekrConfig sharedInstance] setDeviceToken:self.deviceToken.text];
    if (![[HekrConfig sharedInstance] isDeviceConnectedSoftAP]) {
        [KVNProgress showProgress:0];
        [[HekrConfig sharedInstance] hekrConfig:self.currentWifi.text password:self.password.text callback:^(BOOL ret) {
            [KVNProgress dismiss];
            [self showMsg:ret?@"finish":@"fail"];
        }];
    }else{
        [KVNProgress showProgress:0];
        [[HekrConfig sharedInstance] softAPList:^(NSArray * aps) {
            self.apList.text = [aps description];
            id wifi = [aps filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                return [[evaluatedObject objectForKey:@"ssid"] isEqualToString:self.currentWifi.text];
            }]].firstObject;
            if (!wifi) {
                [KVNProgress dismiss];
                return [self showMsg:@"can't find wifi"];
            }
            
            [[HekrConfig sharedInstance] softAPSetBridge:wifi password:self.password.text callback:^(BOOL ret) {
                [KVNProgress dismiss];
                [self showMsg:ret?@"finish":@"fail"];
            }];
        }];
    }
}
-(IBAction) onTap:(id)sender{
    [self.view endEditing:YES];
}
-(void) showMsg:(NSString*) str{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"tip" message:str delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
}
@end
