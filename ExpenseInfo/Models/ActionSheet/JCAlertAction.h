

#import <UIKit/UIKit.h>

@interface JCAlertAction : UIAlertAction
+ (nonnull instancetype)actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)( UIAlertAction * _Nullable action))handler color:(nonnull UIColor *)color isChecked:(BOOL)checked;
@end
