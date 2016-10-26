








#import "MAGCommonDefines.h"

BOOL mag_isDebugBuild() {
    BOOL result = NO;
#ifdef DEBUG
    result = YES;
#endif
    return result;
}

BOOL mag_isEqualObjects(id obj1, id obj2) {
    BOOL result;
    if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
        result = [obj1 isEqualToString:obj2];
    } else {
        result = [obj1 isEqual:obj2];
    }
    return result;
}

BOOL mag_isThisBuildDownloadedFromAppStore() {
    BOOL result = NO;
    BOOL isTestBuild = IS_DEBUG_BUILD || [[[[NSBundle mainBundle] appStoreReceiptURL] lastPathComponent] isEqualToString:@"sandboxReceipt"];//        so you can test it on sandbox apple servers when install build via Xcode or install build via apple's test flight. http://stackoverflow.com/a/27398665/3627460
    result = !isTestBuild;
    return result;
}

@implementation MAGCommonDefines

#pragma mark - DEVICE

+ (BOOL)isPhoneDevice
{
    BOOL isPhoneDevice = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
    return isPhoneDevice;
}

+ (BOOL)isPadDevice
{
    BOOL isPadDevice = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
    return isPadDevice;
}

+ (BOOL)isIphone4
{
    CGRect mainScreenBoundsPortrait = [MAGCommonDefines mainScreenBoundsPortrait];
    return ([MAGCommonDefines isRetina] && [MAGCommonDefines floatNumber:mainScreenBoundsPortrait.size.height isEqualToFloatNumber:480]);
}

+ (BOOL)isIphone5
{
    CGRect mainScreenBoundsPortrait = [MAGCommonDefines mainScreenBoundsPortrait];
    return ([MAGCommonDefines isRetina] && [MAGCommonDefines floatNumber:mainScreenBoundsPortrait.size.height isEqualToFloatNumber:568]);
}

+ (BOOL)isPhone6
{
    CGRect mainScreenBoundsPortrait = [MAGCommonDefines mainScreenBoundsPortrait];
    BOOL result = IS_PHONE && [MAGCommonDefines floatNumber:mainScreenBoundsPortrait.size.height isEqualToFloatNumber:667];
    return result;
}

+ (BOOL)isPhone6Plus
{
    CGRect mainScreenBoundsPortrait = [MAGCommonDefines mainScreenBoundsPortrait];
    BOOL result = IS_PHONE && /*[MobileUsable floatNumber:[[UIScreen mainScreen] nativeScale] isEqualToFloatNumber:3.0f] && */[MAGCommonDefines floatNumber:mainScreenBoundsPortrait.size.height isEqualToFloatNumber:736];
    return result;
}

+ (BOOL)floatNumber:(CGFloat)number1 isEqualToFloatNumber:(CGFloat)number2
{
    BOOL result = NO;
    CGFloat difference = ABS(number2 - number1);
    if (difference < 0.000001) {
        result = YES;
    }
    return result;
}

+ (BOOL)isRetina
{
    BOOL retina = NO;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        retina = [[UIScreen mainScreen] scale] == 2.0 ? YES : NO;
    return retina;
}

+ (CGRect)mainScreenBounds
{
    CGRect mainScreenBounds = [UIScreen mainScreen].bounds;
    //NSLog(@"mainScreenBounds return %@",NSStringFromCGRect(mainScreenBounds));
    return mainScreenBounds;
}

+ (CGRect)mainScreenBoundsPortrait
{
    CGRect result = [MAGCommonDefines mainScreenBounds];
    if (result.size.width > result.size.height) {
        result = [MAGCommonDefines swapFrameSizeValues:result];
    }
    return result;
}

+ (CGRect)swapFrameSizeValues:(CGRect)frame
{
    CGRect result = frame;
    CGFloat tempWidth = frame.size.width;
    result.size.width = frame.size.height;
    result.size.height = tempWidth;
    return result;
}

+ (CGRect)mainScreenBoundsLandscape
{
    CGRect result = [MAGCommonDefines mainScreenBounds];
    if (result.size.height > result.size.width) {
        result = [MAGCommonDefines swapFrameSizeValues:result];
    }
    return result;
}

#pragma mark - OTHER

@end
