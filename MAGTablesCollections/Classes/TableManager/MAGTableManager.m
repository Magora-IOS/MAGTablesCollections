
#import "MAGTableManager.h"
#import "MAGCommonDefines.h"
#import "UIView+MAGMore.h"

@interface MAGTableManager ()

@end

@implementation MAGTableManager

#pragma mark - LifeStyle

- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        self.tableView = tableView;
        tableView.dataSource = self;
        tableView.delegate = self;
    }
    
    return self;
}

- (void)reloadData {
    [self.tableView reloadData];
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

- (NSArray *)items {
    NSArray *result;
    if (self.sections.count) {
        MAGTableSection *section = self.sections[0];
        result = section.items;
    }
    return result;
}

- (NSArray *)selectedItems {
    NSMutableArray *result = [@[] mutableCopy];
    NSArray *selectedIndexPaths = [self.tableView indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in selectedIndexPaths) {
        MAGTableSection *section = self.sections[indexPath.section];
        id item = section.items[indexPath.row];
        [result addObject:item];
    }
    return result;
}

- (void)setSections:(NSArray *)sections {
    _sections = [sections copy];
    [self.tableView reloadData];
}

- (void)setTableView:(UITableView *)tableView {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    
    _tableView = tableView;
    
    self.useSeparatorsZeroInset = YES;
    _tableView.delaysContentTouches = NO;
    
    NSArray *cellClassNames = [self cellClassNamesForNibOrClassRegistering];
    //      at first try to register nib with same FileName's base as classname. else try to register class
    for (NSString *cellClassname in cellClassNames) {
        NSString *cellNibPath = [[NSBundle mainBundle] pathForResource:cellClassname ofType:@"xib"];
        if (!cellNibPath) {
            cellNibPath = [[NSBundle mainBundle] pathForResource:cellClassname ofType:@"nib"];
        }
        BOOL cellNibFoundAndRegistered = NO;
        if (cellNibPath.length > 0) {//     WARNING! Save this check ! This needed bcs [UINib nibWithNibName will return UINib EVEN if xib with name not exists! It's strange bug. So we should use just this kind of check!
            UINib *cellNib = [UINib nibWithNibName:cellClassname bundle:[NSBundle mainBundle]];
            if (cellNib) {
                [_tableView registerNib:cellNib forCellReuseIdentifier:cellClassname];
                cellNibFoundAndRegistered = YES;
            }
        }
        if (!cellNibFoundAndRegistered) {
            [_tableView registerClass:NSClassFromString(cellClassname) forCellReuseIdentifier:cellClassname];
        }
    }
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

//      this and next method for dispaying of default table separators with UIEdgeInsetsZero
- (void)setUseSeparatorsZeroInset:(BOOL)useSeparatorsZeroInset {
    _useSeparatorsZeroInset = useSeparatorsZeroInset;
    if (_useSeparatorsZeroInset) {
        if (IOS_VERSION_FIRST_NUMBER >= 9) {
            self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
        }
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat result;
    MAGTableSection *tableSection;
    if (section < self.sections.count) {
        tableSection = self.sections[section];
        result = [self heightForHeaderViewOfSection:tableSection];
    }
    return result;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *result;
    MAGTableSection *tableSection;
    if (section < self.sections.count) {
        tableSection = self.sections[section];
        NSString *headerIdentifier = [self headerIdentifierForSection:tableSection];
        if (headerIdentifier) {
            result = [UIView mag_loadFromNib:headerIdentifier];
            [self configureHeaderView:result forSection:tableSection];
        }
    }
    return result;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *result;
    MAGTableSection *tableSection;
    if (section < self.sections.count) {
        tableSection = self.sections[section];
        NSString *footerIdentifier = [self footerIdentifierForSection:tableSection];
        if (footerIdentifier) {
            result = [UIView mag_loadFromNib:footerIdentifier];
            [self configureFooterView:result forSection:tableSection];
        }
    }
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat result;
    MAGTableSection *tableSection;
    if (section < self.sections.count) {
        tableSection = self.sections[section];
        result = [self heightForFooterViewOfSection:tableSection];
    }
    return result;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    @try {
        id item = [self itemByIndexPath:indexPath];
        cell = [self permanentCellForItem:item atIndexPath:indexPath];
        if (!cell) {
            NSString *cellId = [self cellIdentifierForItem:[self itemByIndexPath:indexPath] atIndexPath:indexPath];
            cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            [self configureCell:cell withItem:item atIndexPath:indexPath];
        }
    }
    @catch (NSException *exception) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"some not real cell id"];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL result = [self shouldHighlightAndSelectCellAtIndexPath:indexPath];
    return result;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForItem:[self itemByIndexPath:indexPath]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RUN_BLOCK(self.didSelectedCellWithItemBlock, [self itemByIndexPath:indexPath]);
    RUN_BLOCK(self.didSelectionCellChangedWithItemBlock, [self itemByIndexPath:indexPath]);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RUN_BLOCK(self.didDeselectedCellWithItemBlock, [self itemByIndexPath:indexPath]);
    RUN_BLOCK(self.didSelectionCellChangedWithItemBlock, [self itemByIndexPath:indexPath]);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_useSeparatorsZeroInset) {
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        
        // Explictly set your cell's layout margins
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

#pragma mark - From Childs

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section {
    ///enough for current feature
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

- (id)itemByCell:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
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

- (void)reloadItemAtIndexPath:(NSIndexPath *)indexPath animation:(UITableViewRowAnimation)animation {
    if (indexPath) {
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
        [self.tableView endUpdates];
    }
}

- (CGFloat)heightForItem:(id)item {
    return 44.;
}

- (CGFloat)heightForHeaderViewOfSection:(MAGTableSection *)section {
    return 0.00001;
}

- (CGFloat)heightForFooterViewOfSection:(MAGTableSection *)section {
    return 0.00001;
}

- (UITableViewCell *)permanentCellForItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSString *)cellIdentifierForItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    @throw [NSException exceptionWithName:@"no cell identifier" reason:@"identifier should be provided by childs of RCTableManager" userInfo:nil];
    
    return nil;
}

- (void)configureCell:(UITableViewCell *)cell withItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    THROW_MISSED_IMPLEMENTATION_EXCEPTION;
}

- (NSArray *)cellClassNamesForNibOrClassRegistering {
    return nil;
}

- (NSString *)headerIdentifierForSection:(MAGTableSection *)section {
    return nil;
}

- (NSString *)footerIdentifierForSection:(MAGTableSection *)section {
    return nil;
}

- (void)configureHeaderView:(UIView *)view forSection:(MAGTableSection *)section {
    THROW_MISSED_IMPLEMENTATION_EXCEPTION
}

- (void)configureFooterView:(UIView *)view forSection:(MAGTableSection *)section {
    THROW_MISSED_IMPLEMENTATION_EXCEPTION
}

- (BOOL)shouldHighlightAndSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)selectFirstRowWithItem:(id)item animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
    NSArray *indexPaths = [self indexPathsOfItem:item inSections:self.sections];
    if (indexPaths.count > 0) {
        NSIndexPath *first = [indexPaths firstObject];
        [self.tableView selectRowAtIndexPath:first animated:animated scrollPosition:scrollPosition];
    }
}

- (void)selectAllRowsWithItem:(id)item animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
    NSArray *indexPaths = [self indexPathsOfItem:item inSections:self.sections];
    for (NSIndexPath *indexPath in indexPaths) {
        [self.tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
    }
}

- (void)clearSelection {
    for (NSIndexPath *index in self.tableView.indexPathsForSelectedRows) {
        [self.tableView deselectRowAtIndexPath:index animated:NO];
    }
}

@end
