//
//  HekrWebViewController.h
//  CocoaAsyncSocket
//
//  Created by 叶文博 on 2018/9/26.
//

#import <UIKit/UIKit.h>

@interface HekrWebViewController : UIViewController

+ (HekrWebViewController *)vcWithData:(NSDictionary *)data language:(NSString *)language protocol:(NSDictionary *)protocol isGroup:(BOOL)isGroup;
+ (HekrWebViewController *)vcWithDevice:(NSDictionary *)device language:(NSString *)language protocol:(NSDictionary *)protocol group:(NSDictionary *)group;

-(void)reload;

@end
