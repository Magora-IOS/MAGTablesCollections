








#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SeparatorDisplayingMode) {
	SeparatorDisplayingModeBottom = 0,
	SeparatorDisplayingModeNone = 1,
	SeparatorDisplayingModeTop = 2,
	SeparatorDisplayingModeTopAndBottom = 3,
};

/**
		@brief With this cell you can calculate height of cell. For doing it you have to not set any layouts of subviews to superview's bottom. So, distance to bottom will free. Then you can set bottomMarginEqualToTopViewMargin to YES to calculate height where distance from most bottom subview to superview's bottom will equal to distance from superview's top to most top subview. Or you can set your own bottomMargin value.
*/

@interface MAGBaseCell : UITableViewCell

@property (nonatomic) IBInspectable CGFloat bottomMargin;
@property (nonatomic) IBInspectable BOOL bottomMarginEqualToTopViewMargin;

@property (strong, nonatomic) UIColor *selectedBackgroundColor;
@property (strong, nonatomic) UIColor *nonselectedBackgroundColor;

@property (nonatomic) SeparatorDisplayingMode separatorDisplayingMode;
@property (nonatomic) SeparatorDisplayingMode selectedStateSeparatorDisplayingMode;
@property (strong, nonatomic) UIColor *separatorColor;

@property (strong, nonatomic) id item;

+ (void)setDefaultSelectionColor:(UIColor *)color;//       do it on start of application :)

- (CGFloat)requiredHeight;

@end
