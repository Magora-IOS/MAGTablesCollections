








#import <UIKit/UIKit.h>

/**      This class draws a line with minimal possible thickness for current device
 For right working you must guarantee height of it as 1 pixel always (or width as 1 pixel if it is vertical separator). Then you must set suitable contentMode for positioning separator inside of 1 pixel:
 UIViewContentModeTop - position on top (or left if it is vertical separator)
 UIViewContentModeBottom - position on bottom (or right if it is vertical separator)
 */
@interface MAGSeparatorView : UIView

@property (nonatomic, strong) IBInspectable UIColor *color;

+ (CGFloat)mostThinLineWidth;

@end
