








#import "MAGCommonDefines.h"

BOOL rc_isDebugBuild() {
    BOOL result = NO;
#ifdef DEBUG
    result = YES;
#endif
    return result;
}

BOOL rc_isEqualObjects(id obj1, id obj2) {
    BOOL result;
    if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
        result = [obj1 isEqualToString:obj2];
    } else {
        result = [obj1 isEqual:obj2];
    }
    return result;
}

@implementation MAGCommonDefines

@end
