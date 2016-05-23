#import <UIKit/UIKit.h>

@protocol socialImp <NSObject>
+(id) instance;
-(void) config:(NSDictionary*) dict;
-(void) auth:(UIViewController*)controller block:(void(^)(id,NSError*)) block;
-(BOOL) openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
@end