








#import <CoreGraphics/CoreGraphics.h>

#import "MAGCustomCollectionViewLayout.h"
#import "UIView+MAGMore.h"

@interface MAGCustomCollectionViewLayout ()

@property (nonatomic) CGSize defaultItemSize;
@property (nonatomic) CGFloat horizontalSpace;
@property (nonatomic) CGFloat verticalSpace;

@property (nonatomic) CGFloat summaryWidthPoints;
@property (nonatomic) CGFloat summaryHeightPoints;

@property (strong, nonatomic) NSMutableDictionary *cachedFramesDict;//      TODO cut this code if possible

@property (nonatomic) NSValue *lastCalculatedContentSizeValue;

@property (strong, nonatomic) NSArray *calculatedCellWidths;
@property (strong, nonatomic) NSArray *calculatedCellHeights;

@property (strong, nonatomic) NSArray *calculatedCellXs;
@property (strong, nonatomic) NSArray *calculatedCellYs;

@end

@implementation MAGCustomCollectionViewLayout

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self prepareAll];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self prepareAll];
    }
    return self;
}

- (void)setCellFrames:(NSArray<NSArray<NSValue *> *> *)cellFrames {
    _cellFrames = cellFrames;
    _mode = LayoutModeCustomFrames;
}

- (void)setDefaultItemSize:(CGSize)defaultItemSize verticalSpace:(CGFloat)verticalSpace horizontalSpace:(CGFloat)horizontalSpace  {
    CGSize newItemSize = defaultItemSize;
    if (CGSizeEqualToSize(newItemSize, CGSizeZero)) {
        newItemSize = CGSizeMake(50, 50);//     for avoid warning into console about CGSizeZero size is not supported. With right configuration this situation isn't possible
    };
    _defaultItemSize = newItemSize;
    _verticalSpace = verticalSpace;
    _horizontalSpace = horizontalSpace;
    _mode = LayoutModeSerialFrames;
}

- (void)setDefaultItemSize:(CGSize)defaultItemSize cellProportionalHeights:(NSArray<NSNumber *> *)cellProportionalHeights cellProportionalWidths:(NSArray <NSNumber *> *)cellProportionalWidths verticalSpace:(CGFloat)verticalSpace horizontalSpace:(CGFloat)horizontalSpace {
    CGSize newItemSize = defaultItemSize;
    if (CGSizeEqualToSize(newItemSize, CGSizeZero)) {
        newItemSize = CGSizeMake(50, 50);//     for avoid warning into console about CGSizeZero size is not supported
    };
    _defaultItemSize = defaultItemSize;
    _cellProportionalHeights = cellProportionalHeights;
    _cellProportionalWidths = cellProportionalWidths;
    _verticalSpace = verticalSpace;
    _horizontalSpace = horizontalSpace;
    _mode = LayoutModePercentDivision;
}

- (void)prepareAll {
    self.cachedFramesDict = [@{} mutableCopy];
}

- (NSInteger)sectionCount {
    NSInteger result = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    return result;
}

- (NSInteger)itemCountAtSection:(NSInteger)section {
    NSInteger result = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
    return result;
}

- (NSInteger)collectionMaxItemsAtSectionCount {
    NSInteger result = 0;
    for (NSInteger i = 0; i < [self sectionCount]; ++i) {
        NSInteger rowCount = [self itemCountAtSection:i];
        if (rowCount > result) {
            result = rowCount;
        }
    }
    return result;
}

#pragma mark - Overridden

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !(CGSizeEqualToSize(newBounds.size, self.collectionView.frame.size));
}

- (void)invalidateLayout {
    [super invalidateLayout];
}

- (void)prepareLayout {
    [super prepareLayout];
    
    self.lastCalculatedContentSizeValue = nil;
    
//    NSLog(@"collection view frame before layout %@",NSStringFromCGRect(self.collectionView.frame));
    [self.cachedFramesDict removeAllObjects];
    
    self.summaryHeightPoints = 0;
    for (NSNumber *heightNumber in self.cellProportionalHeights) {
        self.summaryHeightPoints += heightNumber.doubleValue;
    }
    self.summaryWidthPoints = 0;
    for (NSNumber *widthNumber in self.cellProportionalWidths) {
        self.summaryWidthPoints += widthNumber.doubleValue;
    }
    [self convertProportionsToRealValues];
}

- (CGSize)collectionViewContentSize {
    CGSize result = CGSizeZero;
    if (self.lastCalculatedContentSizeValue) {
        result = [self.lastCalculatedContentSizeValue CGSizeValue];
    }
    else if (self.mode == LayoutModeCustomFrames) {
        CGFloat maxHeight = 0;
        CGFloat maxWidth = 0;
        for (NSInteger i = 0; i < self.cellFrames.count; ++i) {
            NSArray *sectionItems = self.cellFrames[i];
            for (NSInteger k = 0; k < sectionItems.count; ++k) {
                NSValue *frameValue = sectionItems[k];
                CGRect frame = [frameValue CGRectValue];
                if (CGRectGetMaxY(frame) > maxHeight) {
                    maxHeight = CGRectGetMaxY(frame);
                }
                if (CGRectGetMaxX(frame) > maxWidth) {
                    maxWidth = CGRectGetMaxX(frame);
                }
            }
        }
        result = CGSizeMake(maxWidth, maxHeight);
        self.lastCalculatedContentSizeValue = [NSValue valueWithCGSize:result];
    }
    else if (self.mode == LayoutModeSerialFrames) {
        CGFloat sectionsCount = [self sectionCount];
        CGFloat maxRowCount = [self collectionMaxItemsAtSectionCount];
        
        CGFloat contentHeight = (sectionsCount * self.defaultItemSize.height) + (sectionsCount - 1)*self.verticalSpace;
        CGFloat contentWidth = (maxRowCount * self.defaultItemSize.width) + (maxRowCount - 1)*self.horizontalSpace;
        result = CGSizeMake(contentWidth, contentHeight);
        self.lastCalculatedContentSizeValue = [NSValue valueWithCGSize:result];
    }
    else if (self.mode == LayoutModePercentDivision) {
        result = self.collectionView.size;
        self.lastCalculatedContentSizeValue = [NSValue valueWithCGSize:result];
    }
    return result;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)bounds {
    NSMutableArray *result = [@[] mutableCopy];
    
    if (!self.cachedFramesDict.allKeys.count) {
        for (NSInteger i = 0; i < [self sectionCount]; ++i) {
            for (NSInteger k = 0; k < [self itemCountAtSection:i]; k++) {
                NSIndexPath *path = [NSIndexPath indexPathForItem:k inSection:i];
                [self calculateAndCacheFrameForIndexPath:path];
            }
        }
    }
    
    NSArray *allCachedIndexPaths = self.cachedFramesDict.allKeys;
    NSArray *allCachedFrames = self.cachedFramesDict.allValues;
    if (self.mode == LayoutModeCustomFrames) {
        for (NSInteger i = 0; i < self.cellFrames.count; ++i) {
            NSArray *sectionItems = self.cellFrames[i];
            for (NSInteger k = 0; k < sectionItems.count; k++) {
                NSIndexPath *cachedFrameIndexPath = [NSIndexPath indexPathForRow:k inSection:i];
                UICollectionViewLayoutAttributes *cachedFrameLayoutAttributes = [self layoutAttributesForItemAtIndexPath:cachedFrameIndexPath];
                if (cachedFrameLayoutAttributes) {
                    [result addObject:cachedFrameLayoutAttributes];
                }
            }
        }
    }
    else if (self.mode == LayoutModeSerialFrames) {
        NSInteger minColumnIndex = (bounds.origin.x / (self.defaultItemSize.width + self.horizontalSpace)) - 1;
        NSInteger maxColumnIndex = (CGRectGetMaxX(bounds) / (self.defaultItemSize.width + self.horizontalSpace)) + 1;
        if (minColumnIndex < 0) {
            minColumnIndex = 0;
        }
        if (maxColumnIndex > [self collectionMaxItemsAtSectionCount]) {
            maxColumnIndex = [self collectionMaxItemsAtSectionCount];
        }
        NSInteger minRowIndex = (bounds.origin.y / (self.defaultItemSize.height + self.verticalSpace)) - 1;
        NSInteger maxRowIndex = (CGRectGetMaxY(bounds) / (self.defaultItemSize.height + self.verticalSpace)) + 1;
        
        if (minRowIndex < 0) {
            minRowIndex = 0;
        }
        if (maxRowIndex > [self sectionCount]) {
            maxRowIndex = [self sectionCount];
        }
        
        for (NSInteger i = minColumnIndex; i <= maxColumnIndex; ++i) {
            for (NSInteger k = minRowIndex; k < maxRowIndex; ++k) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:k];
                CGRect cachedFrame = [self calculateAndCacheFrameForIndexPath:indexPath];
                if (CGRectIntersectsRect(cachedFrame, bounds)) {
                    UICollectionViewLayoutAttributes *cachedFrameLayoutAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
                    if (cachedFrameLayoutAttributes) {
                        [result addObject:cachedFrameLayoutAttributes];
                    }
                }
            }
        }
    }
    else if (self.mode == LayoutModePercentDivision) {//        assumed small count of columns / rows
        for (NSInteger i = 0; i < allCachedFrames.count; ++i) {
            NSValue *cachedFrameValue = allCachedFrames[i];
            CGRect cachedFrame = [cachedFrameValue CGRectValue];
            if (CGRectIntersectsRect(cachedFrame, bounds)) {
                NSIndexPath *cachedFrameIndexPath = allCachedIndexPaths[i];
                UICollectionViewLayoutAttributes *cachedFrameLayoutAttributes = [self layoutAttributesForItemAtIndexPath:cachedFrameIndexPath];
                if (cachedFrameLayoutAttributes) {
                    [result addObject:cachedFrameLayoutAttributes];
                }
            }
        }
    }
    return result;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *result;
    if (indexPath.row < [self itemCountAtSection:indexPath.section]) {
        CGRect frame = [self calculateAndCacheFrameForIndexPath:indexPath];
        result = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        result.frame = frame;
//        NSLog(@"result %@",NSStringFromCGRect(frame));
    };
    return result;
}

#pragma mark - Private

- (CGRect)calculateAndCacheFrameForIndexPath:(NSIndexPath*)path {
    CGRect result = CGRectMake(1, 1, 10, 10);
    if (self.mode == LayoutModeCustomFrames) {
        if (path.section < self.cellFrames.count) {
            NSArray *sectionItems = self.cellFrames[path.section];
            if (path.row < sectionItems.count) {
                NSValue *rectValue = sectionItems[path.row];
                result = [rectValue CGRectValue];
            }
        }
    }
    else if (self.mode == LayoutModeSerialFrames) {
            CGFloat y = (path.section * self.verticalSpace) + (path.section * self.defaultItemSize.height);
            CGFloat x = (path.row * self.horizontalSpace) + (path.row * self.defaultItemSize.width);
            result = CGRectMake(x, y, self.defaultItemSize.width, self.defaultItemSize.height);
    }
    else if (self.mode == LayoutModePercentDivision) {
        CGFloat x = [self.calculatedCellXs[path.row] doubleValue];
        CGFloat y = [self.calculatedCellYs[path.section] doubleValue];
        
        CGFloat height = [self.calculatedCellHeights[path.section] doubleValue];
        CGFloat width = [self.calculatedCellWidths[path.row] doubleValue];
        
        result = CGRectMake(x, y, width, height);
        NSValue *cachedValue = [NSValue valueWithCGRect:result];
        [self.cachedFramesDict setObject:cachedValue forKey:path];
    }
    result.size.width = (NSInteger)result.size.width;
    result.size.height = (NSInteger)result.size.height;
    
    result.origin.y = (NSInteger)result.origin.y;
    result.origin.x = (NSInteger)result.origin.x;
    
    return result;
}

- (void)convertProportionsToRealValues {
    NSMutableArray *futureCellWidths = [@[] mutableCopy];
    NSMutableArray *futureCellHeights = [@[] mutableCopy];

    NSMutableArray *futureCellXs = [@[] mutableCopy];
    NSMutableArray *futureCellYs = [@[] mutableCopy];

    NSInteger maxSectionItemCount = [self collectionMaxItemsAtSectionCount];
    CGFloat collectionViewHeightWithoutMargins = self.collectionView.height - (self.verticalSpace * ((CGFloat)[self sectionCount] - 1));
    CGFloat collectionViewWidthWithoutMargins = self.collectionView.width - (self.horizontalSpace * ((CGFloat)maxSectionItemCount - 1));
    
    NSInteger filledWidth = 0;
    for (NSInteger column = 0; column < self.cellProportionalWidths.count; ++column) {
        
        BOOL hasntProportionalWidth = NO;
        NSInteger width = 5;//     integer for avoid smooth of cell's content
        if (column == self.cellProportionalWidths.count - 1) {
            width = self.collectionView.width - filledWidth;//      calculate width of last cell via substraction for avoid free space (which taken from accuracy error)
        }
        else if (column < self.cellProportionalWidths.count) {
            NSNumber *number = self.cellProportionalWidths[column];
            width = number.doubleValue * collectionViewWidthWithoutMargins / self.summaryWidthPoints;
        }
        else {
            width = self.defaultItemSize.width;
            hasntProportionalWidth = YES;
        }
        
        CGFloat x = 0;
        if (column > 0) {
            x = filledWidth + self.horizontalSpace;
        }
        [futureCellXs addObject:@(x)];
        [futureCellWidths addObject:@(width)];
        
        if (column > 0) {
            filledWidth += self.horizontalSpace + width;
        } else {
            filledWidth += width;
        }
    }
    NSInteger filledHeight = 0;
    for (NSInteger row = 0; row < self.cellProportionalHeights.count; ++row) {
        
        BOOL hasntProportionalHeight = NO;
        NSInteger height = 5;//     integer for avoid smooth of cell's content
        if (row == self.cellProportionalHeights.count - 1) {
            height = self.collectionView.height - filledHeight;//      calculate height of last cell via substraction for avoid free space (which taken from accuracy error)
        }
        else if (row < self.cellProportionalHeights.count) {
            NSNumber *number = self.cellProportionalHeights[row];
            height = number.doubleValue * collectionViewHeightWithoutMargins / self.summaryHeightPoints;
        }
        else {
            height = self.defaultItemSize.height;
            hasntProportionalHeight = YES;
        }
        
        CGFloat y = 0;
        if (row > 0) {
            y = filledHeight + self.verticalSpace;
        }
        [futureCellYs addObject:@(y)];
        [futureCellHeights addObject:@(height)];
        
        if (row > 0) {
            filledHeight += self.verticalSpace + height;
        } else {
            filledHeight += height;
        }
    }
    self.calculatedCellXs = futureCellXs;
    self.calculatedCellYs = futureCellYs;
    self.calculatedCellWidths = futureCellWidths;
    self.calculatedCellHeights = futureCellHeights;
}

@end
