








#import "UITextView+MAGMore.h"

@implementation UITextView (MAGMore)

- (void)mag_nullifyMargins {
    [self setTextContainerInset:UIEdgeInsetsZero];
    self.textContainer.lineFragmentPadding = 0;
}

@end
