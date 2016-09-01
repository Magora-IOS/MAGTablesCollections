
#import "MAGCollectionManager.h"
#import "UICollectionViewCell+MAGMore.h"
#import "MAGCommonDefines.h"

@interface MAGCollectionManager ()

@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat nextRowMargin;
@property (nonatomic) CGFloat nextColumnMargin;
@property (nonatomic) CGFloat summaryWidthPoints;
@property (nonatomic) CGFloat summaryHeightPoints;

@end

@implementation MAGCollectionManager

#pragma mark - LifeStyle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self prepareAll];
    }
    return self;
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView collectionViewLayout:(UICollectionViewLayout *)collectionViewLayout {
    self = [super init];
    if (self) {
        self.collectionView = collectionView;
        [self setLayout:collectionViewLayout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [self prepareAll];
    }
    return self;
}

- (void)prepareAll {
    self.scrollToTopAfterLayoutChange = YES;
}

- (void)setLayout:(UICollectionViewLayout *)layout {
    if (self.scrollToTopAfterLayoutChange) {
        self.collectionView.contentOffset = CGPointZero;
    }
    [self.collectionView setCollectionViewLayout:layout animated:NO];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - Configure

- (void)setItems:(NSArray *)items {
    if (items) {
        MAGTableSection *section = [MAGTableSection new];
        section.items = items;
        _sections = @[section];
    } 
    [self reloadData];
}

- (void)setItems:(NSArray *)items viaSplittinOnEqualSizeSectionsWithColumnCount:(NSInteger)columnCount {
    NSInteger i = 0;
    NSMutableArray *sections = [@[] mutableCopy];
    while (i < items.count) {
        MAGTableSection *section = [[MAGTableSection alloc] init];
        NSMutableArray *sectionItems = [@[] mutableCopy];
        for (NSInteger k = i; k < i + columnCount; ++k) {
            if (k < items.count) {
                id obj = items[k];
                [sectionItems addObject:obj];
            }
        }
        if (sectionItems.count > 0) {
            section.items = sectionItems;
            [sections addObject:section];
        }
        i += sectionItems.count;
    }
    
    [self setSections:sections];
}

- (NSArray *)items {
    NSMutableArray *result = [@[] mutableCopy];
    for (NSInteger i = 0; i < self.sections.count; ++i) {
        MAGTableSection *section = self.sections[i];
        [result addObjectsFromArray:section.items];
    }
    return result;
}

- (void)setSections:(NSArray<MAGTableSection *> *)sections {
    _sections = [sections copy];
    [self.collectionView reloadData];
}

- (void)setCollectionView:(UICollectionView *)collectionView {
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
    
    _collectionView = collectionView;
    
    _collectionView.delaysContentTouches = NO;
    
    NSArray *cellNibNames = [self cellNibNames];
    for (NSString *nibName in cellNibNames) {
        UINib *cellNib = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
        [_collectionView registerNib:cellNib forCellWithReuseIdentifier:nibName];
    }
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UICollectionViewDelegate DELEGATE

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *result;
    NSString *cellIdentifier = [self cellIdentifierForItem:[self itemByIndexPath:indexPath] atIndexPath:indexPath];
    @try {
        result = [UICollectionViewCell mag_createForCollectionView:collectionView cellIdentifier:cellIdentifier indexPath:indexPath];
        [self configureCell:result withItem:[self itemByIndexPath:indexPath] atIndexPath:indexPath];
        [result setSelected:result.selected];//       for update appearance of cell depending of its state
    }
    
    @catch (NSException *exception) {
        NSString *description = [NSString stringWithFormat:@"bad collection view cell identifier %@. Exception: %@ %@",cellIdentifier, exception.description, exception.userInfo];
        THROW_EXCEPTION(description, @"you should use just right cell identifier");
    }
    return result;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RUN_BLOCK(self.didSelectedCellWithItemBlock, [self itemByIndexPath:indexPath]);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RUN_BLOCK(self.didUnselectedCellWithItemBlock, [self itemByIndexPath:indexPath]);
}

#pragma mark - From Childs

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section {
    NSInteger result = 0;
    if (section < self.sections.count) {
        MAGTableSection *tableSection = self.sections[section];
        result = [tableSection.items count];
    }
    return result;
}

- (id)itemByIndexPath:(NSIndexPath *)indexPath {
    id item = nil;
    @try {
        MAGTableSection *section = self.sections[indexPath.section];
        NSArray *sectionItems = section.items;
        item = sectionItems[indexPath.row];
    }
    @catch (NSException *exception) {
    }
    
    return item;
}

- (id)itemByCell:(UICollectionViewCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (indexPath == nil) {
        NSParameterAssert(indexPath);
        
        return nil;
    }
    return [self itemByIndexPath:indexPath];
}

- (NSArray *)indexPathsOfItem:(id)item inSections:(NSArray <MAGTableSection *> *)sections {
    NSMutableArray *result = [@[] mutableCopy];
    for (NSInteger i = 0; i < self.sections.count; ++i) {
        MAGTableSection *currentSection = self.sections[i];
        if ([sections containsObject:currentSection]) {
            for (NSInteger k = 0; k < currentSection.items.count; ++k) {
                id currentItem = currentSection.items[k];
                if (EQUAL(currentItem, item)) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:k inSection:i];
                    [result addObject:indexPath];
                }
            }
        }
    }
    return result;
}

- (NSArray <MAGTableSection *> *)sectionsContainingItem:(id)item {
    NSMutableArray *result = [@[] mutableCopy];
    for (NSInteger i = 0; i < self.sections.count; ++i) {
        MAGTableSection *section = self.sections[i];
        if ([section.items containsObject:item]) {
            [result addObject:section];
            break;
        }
    }
    return result;
}

- (NSArray *)cellNibNames {
    THROW_MISSED_IMPLEMENTATION_EXCEPTION;
}

- (NSString *)cellIdentifierForItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    THROW_MISSED_IMPLEMENTATION_EXCEPTION;
}

- (void)configureCell:(UICollectionViewCell *)cell withItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    THROW_MISSED_IMPLEMENTATION_EXCEPTION;
}

- (void)selectAllRowsWithItem:(id)item animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition {
    NSArray *indexPaths = [self indexPathsOfItem:item inSections:self.sections];
    for (NSIndexPath *indexPath in indexPaths) {
        [self.collectionView selectItemAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
    }
}

- (NSArray *)selectedItems {
    NSMutableArray *result = [@[] mutableCopy];
    NSArray *selectedIndexPaths = [self.collectionView indexPathsForSelectedItems];
    for (NSIndexPath *indexPath in selectedIndexPaths) {
        MAGTableSection *section = self.sections[indexPath.section];
        id item = section.items[indexPath.row];
        [result addObject:item];
    }
    return result;
 }

@end
