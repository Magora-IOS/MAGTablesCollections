








#import "MAGTableManager.h"
#import "MAGCommonDefines.h"
#import "UIView+MAGMore.h"
#import "MAGTableManager+Redefinition.h"

static UIColor *_defaultSelectionColorSTATIC;
static UIColor *_defaultSeparatorColorSTATIC;

@interface MAGTableManager ()

@property (readonly, weak, nonatomic) UIView *emptyView;//      weak bcs added as subview
@property (assign) BOOL originallyBouncesEnabled;

@end

@implementation MAGTableManager

#pragma mark - IMPORTANT


+ (void)setDefaultSelectionColor:(UIColor *)color {
    _defaultSelectionColorSTATIC = color;
}

+ (void)setDefaultSeparatorColor:(UIColor *)color {
    _defaultSeparatorColorSTATIC = color;
}

- (void)setDisplayEmptyViewWhenDataIsEmpty:(BOOL)displayEmptyViewWhenDataIsEmpty classnameForEmptyView:(NSString *)classnameForEmptyView emptyViewCustomizationBlock:(MAGViewBlock)emptyViewCustomizationBlock {
    _displayEmptyViewWhenDataIsEmpty = displayEmptyViewWhenDataIsEmpty;
    _classnameForEmptyView = classnameForEmptyView;
    _emptyViewCustomizationBlock = emptyViewCustomizationBlock;
    
    [self recreateEmptyLabel];
    [self updateEmptyLabel];
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

- (void)selectAllRowsWithItem:(id)item animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
    [self addItemToSelectedItems:item];
    NSArray *indexPaths = [self indexPathsOfItem:item inSections:self.sections];
    for (NSIndexPath *indexPath in indexPaths) {
        [self.tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
    }
}

- (void)deselectAllRowsWithItem:(id)item animated:(BOOL)animated {
    [self removeItemFromSelectedItems:item];
    NSArray *indexPaths = [self indexPathsOfItem:item inSections:self.sections];
    for (NSIndexPath *indexPath in indexPaths) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
    }
}

- (void)clearSelection {
    self.selectedItems = @[];
    for (NSIndexPath *index in self.tableView.indexPathsForSelectedRows) {
        [self.tableView deselectRowAtIndexPath:index animated:NO];
    }
}

- (void)makeInsertOperations:(NSArray <MAGInsertOperation *> *)operations animated:(BOOL)animated completion:(MAGIntegerBlock)completion {
    NSLog(@"INSERTION ITEMS STARTED");
    UITableViewRowAnimation animation = UITableViewRowAnimationNone;
    if (animated) {
        animation = UITableViewRowAnimationBottom;
    }
    BOOL updatesHappened = NO;
	NSInteger affectedItemCount = 0;
	for (MAGInsertOperation *operation in operations) {
		BOOL suchSectionExists = [self.sections containsObject:operation.destinationSection];
		if (suchSectionExists) {
			if (operation.indexWhereto <= operation.destinationSection.items.count) {//        bcs we can insert element after all
				updatesHappened = YES;
				[self.tableView beginUpdates];
				
				NSMutableArray *indexpathsOfInsertedItems = @[].mutableCopy;
				NSMutableArray *changedItems = [operation.destinationSection.items mutableCopy];
				NSInteger rowIncrement;
				for (NSInteger i = operation.items.count - 1; i >= 0; --i) {//insert in backward order for making forward order
					id item = operation.items[i];
					[changedItems insertObject:item atIndex:operation.indexWhereto];
					NSInteger sectionIndex = [self.sections indexOfObject:operation.destinationSection];
					if (sectionIndex != NSNotFound) {
						NSInteger itemRow = operation.indexWhereto + i;
						NSIndexPath *insertedItemIndexpath = [NSIndexPath indexPathForRow:itemRow inSection:sectionIndex];
						[indexpathsOfInsertedItems addObject:insertedItemIndexpath];
					}
				}
				operation.destinationSection.items = changedItems;
				[self.tableView insertRowsAtIndexPaths:indexpathsOfInsertedItems withRowAnimation:animation];
				affectedItemCount += indexpathsOfInsertedItems.count;
								[self.tableView endUpdates];
			}
		}
	}
	if (updatesHappened) {
		if (animated) {
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMAGTableManagerAnimationTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				RUN_BLOCK(completion, affectedItemCount);
			});
		} else {
			RUN_BLOCK(completion, affectedItemCount);
		}
	} else {
		RUN_BLOCK(completion, 0);
	}
}

- (void)makeReloadOperations:(NSArray <MAGReloadOperation *> *)operations animated:(BOOL)animated completion:(MAGIntegerBlock)completion {
    NSLog(@"RELOADING ITEMS STARTED");
    UITableViewRowAnimation animation = UITableViewRowAnimationNone;
    if (animated) {
        animation = UITableViewRowAnimationAutomatic;
    }
	NSMutableArray *indexpaths = @[].mutableCopy;
	for (MAGReloadOperation *operation in operations) {
		BOOL suchSectionExists = [self.sections containsObject:operation.sourceSection];
		if (suchSectionExists) {
			for (id item in operation.items) {
				NSArray *currentIndexpaths = [self indexPathsOfItem:item inSections:@[operation.sourceSection]];
				[indexpaths addObjectsFromArray:currentIndexpaths];
			}
		}
	}
    if (indexpaths.count) {
		[self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:indexpaths withRowAnimation:animation];
        [self.tableView endUpdates];
        NSInteger affectedItemCount = indexpaths.count;
        if (animated) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMAGTableManagerAnimationTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                RUN_BLOCK(completion, affectedItemCount);
            });
        } else {
            RUN_BLOCK(completion, affectedItemCount);
        }
    } else {
        RUN_BLOCK(completion, 0);
    }
}

- (void)makeAllItemOccurenciesDeleteOperations:(NSArray <MAGDeleteOperation *> *)operations animated:(BOOL)animated completion:(MAGIntegerBlock)completion {
	NSLog(@"DELETION ITEMS STARTED");
	UITableViewRowAnimation animation = UITableViewRowAnimationNone;
	if (animated) {
		animation = UITableViewRowAnimationBottom;
	}
	NSMutableArray *indexpaths = @[].mutableCopy;
	for (MAGDeleteOperation *operation in operations) {
		BOOL suchSectionExists = [self.sections containsObject:operation.sourceSection];
		if (suchSectionExists) {
			for (id item in operation.items) {
				NSArray *currentIndexpaths = [self indexPathsOfItem:item inSections:@[operation.sourceSection]];
				[indexpaths addObjectsFromArray:currentIndexpaths];
				if (indexpaths.count) {
					[self.tableView beginUpdates];
					[self.tableView deleteRowsAtIndexPaths:currentIndexpaths withRowAnimation:animation];
					
					//        for (MAGTableSection *section in sections) {
					NSUInteger itemIndex = [operation.sourceSection.items indexOfObject:item];
					if (itemIndex != NSNotFound) {
						NSMutableArray *changedItems = [operation.sourceSection.items mutableCopy];
						[changedItems removeObject:item];
						operation.sourceSection.items = changedItems;
					}
					//        }
					[self.tableView endUpdates];
				}
			}
		}
	}
	NSInteger affectedItemCount = indexpaths.count;
	if (affectedItemCount) {
		if (animated) {
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMAGTableManagerAnimationTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				RUN_BLOCK(completion, affectedItemCount);
			});
		} else {
			RUN_BLOCK(completion, affectedItemCount);
		}
	} else {
		RUN_BLOCK(completion, 0)
	}
}

#pragma mark - Ot


- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        self.tableView = tableView;
        tableView.dataSource = self;
        tableView.delegate = self;
    }
    
    return self;
}

- (void)reloadData {
    [self recreateEmptyLabel];
    [self updateEmptyLabel];
    [self spoofFooterViewIfNeeded];
    
    [self.tableView reloadData];
}

#pragma mark - Configure

- (void)setItems:(NSArray *)items {
    if (items) {
        MAGTableSection *section = [MAGTableSection new];
        section.items = items;
        _sections = @[section];
    }
    _selectedItems = @[];
    _itemsOrSectionsWasFilledByUser = YES;
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

- (void)setSelectedItems:(NSArray *)selectedItems {
    if (selectedItems) {
        _selectedItems = selectedItems;
        for (MAGTableSection *section in self.sections) {
            for (id item in section.items) {
                BOOL contains = [selectedItems containsObject:item];
                if (contains) {
                    NSArray *itemIndexPaths = [self indexPathsOfItem:item inSections:self.sections];
                    for (NSIndexPath *indexpath in itemIndexPaths) {
                        [self.tableView selectRowAtIndexPath:indexpath animated:NO scrollPosition:UITableViewScrollPositionNone];
                    }
                }
            }
        }
    } else {
        _selectedItems = @[];
    }
}

- (void)setSections:(NSArray *)sections {
    _sections = [sections copy];
    _selectedItems = @[];
    _itemsOrSectionsWasFilledByUser = YES;
    
    [self reloadData];
}

- (void)setTableView:(UITableView *)tableView {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
	
	
    _tableView = tableView;
	
	self.tableView.separatorColor = [UIColor clearColor];//		will use custom separators instead
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

	self.useSeparatorsZeroInset = YES;
	if (!self.initialSeparatorInset) {
		_initialSeparatorInset = 	[NSValue valueWithUIEdgeInsets:self.tableView.separatorInset];
	}
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
    
    self.originallyBouncesEnabled = self.tableView.bounces;
    
    //    NSLog(@"ENABLED %@",@(self.originallyBouncesEnabled).stringValue);
    [self recreateEmptyLabel];
    
    [self spoofFooterViewIfNeeded];
}

- (void)recreateEmptyLabel {
    if (self.emptyView) {
        [self.emptyView removeFromSuperview];
        _emptyView = nil;
    }
    if (self.classnameForEmptyView.length) {
        Class emptyViewClass = NSClassFromString(self.classnameForEmptyView);
        _emptyView = [emptyViewClass mag_loadFromNib];
    }
    if (self.emptyView) {
        _emptyView.hidden = YES;
        
        [self.tableView mag_inscribeSubview:self.emptyView];
        self.emptyView.y = 0;
        RUN_BLOCK(self.emptyViewCustomizationBlock, self.emptyView);
    }
}




- (void)updateEmptyLabel {
    if (self.emptyView) {
        if (self.displayEmptyViewWhenDataIsEmpty) {
            BOOL hasAnyItems = [self hasAnyItems];
            BOOL willDisplayEmptyView = self.itemsOrSectionsWasFilledByUser && !hasAnyItems;
            self.emptyView.hidden = !willDisplayEmptyView;
        } else {
            self.emptyView.hidden = YES;
        }
        if (self.emptyView.hidden) {
            self.tableView.bounces =  self.originallyBouncesEnabled;
        } else {
            self.tableView.bounces = NO;//        not bounces when EmptyLabel is visible
        }
    }
}

- (void)setUseFooterSeparatorViewInsteadOfEmptyTableFooterView:(BOOL)use {
    _useFooterSeparatorViewInsteadOfEmptyTableFooterView = use;
    [self spoofFooterViewIfNeeded];
}

- (void)spoofFooterViewIfNeeded {
    //      displaying of footerSeparatorFundamentView will hide standard zebra. We have to not display footerSeparatorView on it if we haven't any items. So we shouldn't display separator always when footerSeparatorFundamentView is visible
    //      displaying of footerSeparatorView needed when we have any items and then we want to close last item with separator
    BOOL hasAnyItems = [self hasAnyItems];
    BOOL willDisplayFakeEmptyFooterForAvoidStandardStupidZebra = self.tableView && (self.useFooterSeparatorViewInsteadOfEmptyTableFooterView && (!self.tableView.tableFooterView || EQUAL(self.tableView.tableFooterView, self.footerSeparatorFundamentView)));//      add footer for skip visible of stupid standard zebra after last displayed
    if (willDisplayFakeEmptyFooterForAvoidStandardStupidZebra) {//      we will display view may be without separator view. This needed for hide stupid zebra
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 1)];
        view.backgroundColor = [UIColor clearColor];
        BOOL willAddSeparatorView = hasAnyItems;
        if (willAddSeparatorView) {
            MAGSeparatorView *separatorView = [MAGSeparatorView new];
            [view addSubview:separatorView];
            separatorView.frame = view.bounds;
            separatorView.y = -[MAGSeparatorView mostThinLineWidth];
            
            separatorView.contentMode = UIViewContentModeTop;
            separatorView.color = [self separatorColorForUsing];
			
            _footerSeparatorView = separatorView;
        }
        _footerSeparatorFundamentView = view;
        self.tableView.tableFooterView = self.footerSeparatorFundamentView;

        view.clipsToBounds = NO;
    } else {
        if (self.footerSeparatorFundamentView) {
            self.tableView.tableFooterView = nil;
            _footerSeparatorView = nil;
        }
    }
}

- (UIColor *)separatorColorForUsing {
	UIColor *result = self.separatorsColor;
	if (!result) {
		result = _defaultSeparatorColorSTATIC;
	}
	return result;
}

- (void)setSeparatorsColor:(UIColor *)separatorsColor {
    _separatorsColor = separatorsColor;
//    self.tableView.separatorColor = separatorsColor;
    self.footerSeparatorView.color = separatorsColor;
}

- (BOOL)hasAnyItems {//      PLEASE CALL THIS RARELY FOR AVOID LAGS !!!
    BOOL result;
    NSInteger count = 0;
    for (MAGTableSection *section in self.sections) {
        count += section.items.count;
    }
    result = CORRECTED_BOOL(count > 0);
    return result;
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


//########
//      methods for smooth animations of
//      reloadRowsAtIndexPaths,deleteRowsAtIndexPaths,insertRowsAtIndexPaths
//      during scrolling of tableView
//########

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat result = [self heightForItem:[self itemByIndexPath:indexPath]];
    //    NSLog(@"ESTIMATED HEIGHT %@",@(result).stringValue);
    return result;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
//    CGFloat result = 0.00001;
//    MAGTableSection *tableSection;
//    if (section < self.sections.count) {
//        tableSection = self.sections[section];
//        result = [self heightForHeaderViewOfSection:tableSection];
//    }
//    return result;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
//    CGFloat result = 0.00001;
//    MAGTableSection *tableSection;
//    if (section < self.sections.count) {
//        tableSection = self.sections[section];
//        result = [self heightForFooterViewOfSection:tableSection];
//    }
//    return result;
//}

//#########




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat result = 0.00001;
	BOOL emptyViewDisplayed = [self isEmptyViewDisplayed];
    if (!emptyViewDisplayed) {
        MAGTableSection *tableSection;
        if (section < self.sections.count) {
            tableSection = self.sections[section];
            result = [self heightForHeaderViewOfSection:tableSection];
        }
    }
    return result;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *result;
	BOOL emptyViewDisplayed = [self isEmptyViewDisplayed];
    if (!emptyViewDisplayed) {
        MAGTableSection *tableSection;
        if (section < self.sections.count) {
            tableSection = self.sections[section];
            NSString *headerIdentifier = [self headerIdentifierForSection:tableSection];
            if (headerIdentifier) {
                Class headerViewClass = NSClassFromString(headerIdentifier);
                result = [headerViewClass mag_loadFromNib:headerIdentifier];
                [self configureHeaderView:result forSection:tableSection];
            }
        }
    }
    return result;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *result;
	BOOL emptyViewDisplayed = [self isEmptyViewDisplayed];
    if (!emptyViewDisplayed) {
        MAGTableSection *tableSection;
        if (section < self.sections.count) {
            tableSection = self.sections[section];
            NSString *footerIdentifier = [self footerIdentifierForSection:tableSection];
            if (footerIdentifier) {
                Class footerViewClass = NSClassFromString(footerIdentifier);
                result = [footerViewClass mag_loadFromNib:footerIdentifier];
                [self configureFooterView:result forSection:tableSection];
            }
        }
    }
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat result = 0.00001;
	BOOL emptyViewDisplayed = [self isEmptyViewDisplayed];
    if (!emptyViewDisplayed) {
        MAGTableSection *tableSection;
        if (section < self.sections.count) {
            tableSection = self.sections[section];
            result = [self heightForFooterViewOfSection:tableSection];
        }
    }
    return result;
}

- (BOOL)isEmptyViewDisplayed {
	BOOL result = self.emptyView && !self.emptyView.hidden;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    id item;
    @try {
        item = [self itemByIndexPath:indexPath];
        cell = [self permanentCellForItem:item atIndexPath:indexPath];
        if (!cell) {
            NSString *cellId = [self cellIdentifierForItem:[self itemByIndexPath:indexPath] atIndexPath:indexPath];
            cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            [self configureCell:cell withItem:item atIndexPath:indexPath];
			if (self.alternateBackgroundColors.count) {
				NSInteger index = indexPath.row % self.alternateBackgroundColors.count;
				UIColor *color = self.alternateBackgroundColors[index];
				cell.contentView.backgroundColor = color;
			}
        }
    }
    @catch (NSException *exception) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"some not real cell id"];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL result = [self shouldHighlightAndSelectCellAtIndexPath:indexPath];
    if (self.changingSelectionByUserTapsDisabled) {
        id item = [self itemByIndexPath:indexPath];
        RUN_BLOCK(self.didTryChangeSelectionItemBlock, item);
    }
    return result;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForItem:[self itemByIndexPath:indexPath]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self itemByIndexPath:indexPath];
    if (self.changingSelectionByUserTapsDisabled) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    } else {
        if (self.clearSelectionOnce) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
        } else {
            [self addItemToSelectedItems:item];
        }
        RUN_BLOCK(self.didSelectedCellWithItemBlock, item);
        RUN_BLOCK(self.didSelectionCellChangedWithItemBlock, item);
    }
}

- (void)addItemToSelectedItems:(id)item {
    NSMutableArray *array = [self.selectedItems mutableCopy];
    [array removeObject:item];// bcs some sections might contains this item, so we need avoid duplicates
    [array addObject:item];
    _selectedItems = array;
}

- (void)removeItemFromSelectedItems:(id)item {
    NSMutableArray *array = [self.selectedItems mutableCopy];
    [array removeObject:item];// bcs some sections might contains this item, so we need avoid duplicates
    _selectedItems = array;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    id item = [self itemByIndexPath:indexPath];
    if (self.changingSelectionByUserTapsDisabled) {
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        NSMutableArray *array = [self.selectedItems mutableCopy];
        [array removeObject:item];
        _selectedItems = array;
        RUN_BLOCK(self.didDeselectedCellWithItemBlock, item);
        RUN_BLOCK(self.didSelectionCellChangedWithItemBlock, item);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"WILL DISPLAY INDEXPATH %@", indexPath);
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
    id item = [self itemByIndexPath:indexPath];
    BOOL contains = [self.selectedItems containsObject:item];
    if (contains) {
        [cell setSelected:YES animated:NO];
    }
	if ([cell isKindOfClass:[MAGBaseCell class]]) {
		MAGBaseCell *baseCell = (MAGBaseCell *)cell;
		baseCell.separatorColor = [self separatorColorForUsing];
		UIColor *selectedBackgroundColor = [self selectedBackgroundColorForBaseCell:cell atIndexPath:indexPath];
		baseCell.selectedBackgroundColor = selectedBackgroundColor;
		SeparatorDisplayingMode normalStateSeparatorMode = [self separatorDisplayingModeForBaseCellNormalState:cell atIndexPath:indexPath];
		SeparatorDisplayingMode selectedStateSeparatorMode = [self separatorDisplayingModeForBaseCellNormalState:cell atIndexPath:indexPath];
		baseCell.separatorDisplayingMode = normalStateSeparatorMode;
		baseCell.selectedStateSeparatorDisplayingMode = selectedStateSeparatorMode;
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

@end
