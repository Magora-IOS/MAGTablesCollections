








#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LayoutMode) {
    LayoutModeCustomFrames = 0,
    LayoutModeSerialFrames = 1,
    LayoutModePercentDivision = 2
};

@interface MAGCustomCollectionViewLayout : UICollectionViewLayout <UICollectionViewDelegate>

@property (readonly, nonatomic) LayoutMode mode;//      it changes by methods

@property (readonly, strong, nonatomic) NSArray <NSArray <NSValue *> *> *cellFrames;//     frames of ALL CELLS!

@property (readonly, strong, nonatomic) NSArray <NSNumber *> *cellProportionalWidths;//       first cellProportionalWidths.count columns will proported between each other
@property (readonly, strong, nonatomic) NSArray <NSNumber *> *cellProportionalHeights;//       first cellProportionalHeights.count columns will proported between each other

//      here 3 different modes (one per method):
- (void)setCellFrames:(NSArray<NSArray<NSValue *> *> *)cellFrames;//        LayoutModeCustomFrames
- (void)setDefaultItemSize:(CGSize)defaultItemSize verticalSpace:(CGFloat)verticalSpace horizontalSpace:(CGFloat)horizontalSpace;//        LayoutModeSerialFrames
- (void)setDefaultItemSize:(CGSize)defaultItemSize cellProportionalHeights:(NSArray<NSNumber *> *)cellProportionalHeights cellProportionalWidths:(NSArray <NSNumber *> *)cellProportionalWidths verticalSpace:(CGFloat)verticalSpace horizontalSpace:(CGFloat)horizontalSpace;//      LayoutModePercentDivision. Count of sections must be equal to verticalSpace. Count of items at section must be equal to cellProportionalWidths. You can set cellProportionalHeights or cellProportionalWidths in nil, then default height / width will used

@end
