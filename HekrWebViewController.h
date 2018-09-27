//
//  HekrWebViewController.h
//  CocoaAsyncSocket
//
//  Created by 叶文博 on 2018/9/26.
//

#import <UIKit/UIKit.h>

@interface HekrWebViewController : UIViewController

+ (HekrWebViewController *)vcWithData:(NSDictionary *)data language:(NSString *)language protocol:(NSDictionary *)protocol isGroup:(BOOL)isGroup;

-(void)reload;

@end
