

#import "JCAlertAction.h"

@implementation JCAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler color:(UIColor *)color isChecked:(BOOL)checked{
    UIAlertAction *button = [UIAlertAction actionWithTitle:title style:style handler:handler];
    [button setValue:color forKey:@"titleTextColor"];
    [button setValue:color forKey:@"imageTintColor"];
    [button setValue:[NSNumber numberWithBool:checked] forKey:@"checked"];
    
    return (JCAlertAction*) button;
}

@end
