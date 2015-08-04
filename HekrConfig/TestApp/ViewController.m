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
    self.currentWifi.text = [self currentWifiSSID];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(IBAction) onOK:(id)sender{
    if (self.deviceToken.text.length <= 0) {
        return [self showMsg:@"please set deviceToken"];
    }
    if ([self currentWifiSSID].length <= 0) {
        return [self showMsg:@"please connect to a wifi"];
    }
    if (self.password.text.length <= 0) {
        return [self showMsg:@"plase set password"];
    }
    [[HekrConfig sharedInstance] setDeviceToken:self.deviceToken.text];
    if (![[HekrConfig sharedInstance] isDeviceConnectedSoftAP]) {
        [KVNProgress showProgress:0];
        [[HekrConfig sharedInstance] hekrConfig:[self currentWifiSSID] password:self.password.text callback:^(BOOL ret) {
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
