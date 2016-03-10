# HEKR iOS SDK

## 相关介绍
HekrSDK提供了快速接入Hekr平台的方式，及基于h5页面的开发模式

## 关键词
* S表达式([SEXP](http://baike.baidu.com/link?url=D9GgI32xuN7Cr1teJSoVxHJB0bWjIlHnJ6zXq9NsiP6DBQVwOZuoxWs5TMai8bte8AvhZbo6SDNN3oKo4ng2xa))：准确地说是[lambdaTM](http://baike.baidu.com/link?url=HRBw76f8qZGTGewfUycLIcqCsla-X0fiCmPx0KqU_6mIhYeRaGTzG1JEUoWhL92Z-bRdkmB4WGiIKsDrW0VD3CDal4Iv0eomh-l8f1G8qom00STzPX0bf6jxEa6nJw0x_9WcG0Z33_sB9geCvd1Nrq#4)代码，SEXP既是代码也是数据，这对于理解指令和后续描述的一些场景非常重要
* user_token: 用户授权识别码，用户的accesskey
* device_token: 设备授权识别码，设备的accesskey
* hekr-config：Wi-Fi一键配置

## 流程说明
1. 首先通过webView进行登录，有兴趣的可以具体参考云端api [C1-1](http://docs.hekr.me/cloud/cloud-1/#c1-1)，并获取cookie
2. 通过云端api来获取列表数据，通过socket或者webSocket和设备保持通信状态，从而进行实时控制，并实时获取最新状态数据
3. LambdaTM sdk来解析sexp数据

具体流程方式详见：[demo](https://github.com/HEKR-Cloud/HEKR-IOS-APP)

## 接口说明
前置条件:配置设备授权识别码 
配置设备授权识别码之后才可以正常使用<font color=red>一键配置</font> 和<font color=red>软ap配置</font>功能

### 设置设备授权码
参数

* <font color=red>device_token</font> 设备授权识别码，设备的accesskey

``` Objective-C
import "HekrConfig.h"
[[HekrConfig sharedInstance] setDeviceToken:deviceToken];
```

### HekrConfig(Wi-Fi一键配置)
参数

* <font color=red>ssid</font> wifi ssid
* <font color=red>password</font> wifi 密码
* <font color=red>callback</font> 回调Block; <font color=red>ret</font> 回调参数 <font color=red>YES/NO</font> 成功/失败

返回参数

* 无

``` Objective-C
[[HekrConfig sharedInstance] hekrConfig:ssid password:password callback:^(BOOL ret){}];
```

### 取消Wi-Fi一键配置
参数

* 无

返回参数

* 无

``` Objective-C
[[HekrConfig sharedInstance] cancelConfig];
```

### 判断当前设备是否已连接上软AP
参数

* 无

返回参数

* <font color=red>YES/NO</font> 已连接/未连接

``` Objective-C
[[HekrConfig sharedInstance] isDeviceConnectedSoftAP];
```

### 获取wifi列表
<mark>前置条件：设备已连接上软ap</mark>

参数

* <font color=red>callback</font> 回调函数; <font color=red>list</font> 回调参数 <font color=red>NSArray/nil</font> 成功/失败

返回参数

* 无

``` Objective-C
[[HekrConfig sharedInstance] softAPList:^(NSArray* list){}];
```

### 软ap连接路由
参数

* <font color=red>AP</font> wifi信息; 获取wifi列表时返回的wifi信息
* <font color=red>password</font> wifi密码
* <font color=red>callback</font> 回调函数; <font color=red>ret</font> 回调参数 <font color=red>YES/NO</font> 成功/失败

返回参数

* 无

``` Objective-C
[[HekrConfig sharedInstance] softAPSetBridge:AP password:password callback:^(BOOL ret){}];
```

## 集成准备
### 硬件支持
macbook air, macbook pro,mac mini,mac 一体机,黑苹果..
### 账号申请
* 申请第三方平台登录账号目前支持 QQ,微信,微博,Google,Twitter,Facebook
* 申请个推账号 
* 申请Hekr平台账号，并完善相关信息 

### 下载SDK
[下载HEKR-IOS-SDK](http://daringfireball.net/projects/markdown/syntax)并解压缩
### 导入SDK
#### 代码引用
请在你的工程目录结构中，右键选择<mark>Add->Existing Files…</mark>，选择根目录下的HekrSDK目录(包含.h文件，静态库，资源文件),或者将这目录拖入XCode工程目录结构中，在弹出的界面中勾选<mark>Copy items into destination group's folder(if needed)</mark>, 并确保<mark>Add To Targets</mark>勾选相应的<mark>target</mark>。
#### 使用Cocoapods安装SDK
Cocoapods是一个很好的依赖管理工具，具体使用参考官方文档[《CocoaPods安装和使用教程》](http://code4app.com/article/cocoapods-install-usage)。 
### 配置文件
配置文件,不需要的项可以不用配置,推荐保存为JSON并加密存储，需要时再解密

``` json
{
  "Hekr":{
    "AppId":"AppId",
    "AppKey":"AppKey",
    "AppSecurit":"AppSecurit"
  },
  "Social":{
    "Weibo":{
      "AppId":"AppId",
      "AppKey":"AppKey",
      "AppSecurit":"AppSecurit"
    },
    "QQ":{
      "AppId":"AppId",
      "AppKey":"AppKey",
    },
    "Weixin":{
      "AppId":"AppId",
      "AppSecurit":"AppSecurit"
    },
    "Facebook":{
      "AppId":"AppId",
      "AppSecurit":"AppSecurit"
    },
    "Google":{
      "AppId":"AppId",
    },
    "Twitter":{
      "AppKey":"AppKey",
      "AppSecurit":"AppSecurit"
    }
  },
  "push":{
    "AppId":"AppId",
    "AppKey":"AppKey",
    "AppSecurit":"AppSecurit"
  }
}
```

## 基本功能集成
### 配置<font color=red>\*AppDelegate.m</font>  (\*代表你的工程名字）
<font color=red>\*AppDelegate.m</font>的配置主要包括账号的相关配置，起始页面两部分，代码示例如下：

``` Objective-C
- (BOOL])application:(UIApplication] *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[[Hekr sharedInstance] config:config startPage:@"**********" launchOptions:launchOptions];	
	[[Hekr sharedInstance] firstPage];
}
```

#### 账号相关配置
config:config json文件读取，转换成字典，具体配置情况可以查看集成准备

#### startPage填写
将startPage:@"**********" 中的 **********替换成自己的页面

### 推送消息配置
``` Objective-C
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [[Hekr sharedInstance] didRegisterUserNotificationSettings:notificationSettings];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[Hekr sharedInstance] registNotificationsWithDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
//    NSLog(@"application didReceiveRemoteNotification:%@",userInfo);
    [[Hekr sharedInstance] didReceiveRemoteNotification:userInfo];
}
```
### SSO配置
``` Objective-C
- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[Hekr sharedInstance] openURL:url sourceApplication:sourceApplication annotation:annotation];
}
```
#### iOS9.0中URL Scheme引入白名单
iOS9.0中必须引入白名单才可以进行第三方应用的跳转，如微信，微博登录..
具体配置方法可以查看[URL Scheme引入白名单](https://github.com/ChenYilong/iOS9AdaptationTips#5demo3---ios9-url-scheme-%E9%80%82%E9%85%8D_%E5%BC%95%E5%85%A5%E7%99%BD%E5%90%8D%E5%8D%95%E6%A6%82%E5%BF%B5)

## SDK&Demo下载
* SDK(iOS)：<https://github.com/HEKR-Cloud/HEKR-IOS-SDK>
* APP Demo(iOS):<https://github.com/HEKR-Cloud/HEKR-IOS-APP>
