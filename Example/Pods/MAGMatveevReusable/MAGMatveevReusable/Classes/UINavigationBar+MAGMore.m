








#import "UINavigationBar+MAGMore.h"

@implementation UINavigationBar (MAGMore)

+ (void)mag_globallyDisableTranslucent {
    [[UINavigationBar appearance] setTranslucent:NO];
}

+ (void)mag_globallySetTitleFontWithFont:(UIFont *)font {
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                              NSFontAttributeName:font }];
}

+ (void)mag_globallySetBackgroundColor:(UIColor *)color {
    [[UINavigationBar appearance] setBarTintColor:color];
}

+ (void)mag_globallySetControlsColor:(UIColor *)color {
    [[UINavigationBar appearance] setTintColor:color];
}

@end
