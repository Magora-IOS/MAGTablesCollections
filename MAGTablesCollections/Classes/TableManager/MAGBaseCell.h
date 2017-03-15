








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

@property (strong, nonatomic) id item;

- (CGFloat)requiredHeight;



@property (strong, nonatomic) UIColor *selectedBackgroundColor;//		for using by MAGTableManager. Not use by yourself!
@property (strong, nonatomic) UIColor *nonselectedBackgroundColor;//		for using by MAGTableManager. Not use by yourself!

@property (nonatomic) SeparatorDisplayingMode separatorDisplayingMode;//		for using by MAGTableManager. Not use by yourself!
@property (nonatomic) SeparatorDisplayingMode selectedStateSeparatorDisplayingMode;//		for using by MAGTableManager. Not use by yourself!
@property (strong, nonatomic) UIColor *separatorColor;//		for using by MAGTableManager. Not use by yourself!

@end
