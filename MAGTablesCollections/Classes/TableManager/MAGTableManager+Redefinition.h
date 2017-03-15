








#import <MAGTablesCollections/MAGTableManager.h>

/**
	@brief You must to rewrite CRITICAL section's methods in your subclass of MAGTableManager! You can rewrite optional methods too by your wish.
	MAGTableManager has special advantages when you use MAGBaseCell.
*/

@interface MAGTableManager (Redefinition)

//		CRITICAL REDEFINITION

- (NSArray *)cellClassNamesForNibOrClassRegistering;//        for registering of nib or class (if nib not exists)
- (UITableViewCell *)permanentCellForItem:(id)item atIndexPath:(NSIndexPath *)indexPath;
- (NSString *)cellIdentifierForItem:(id)item atIndexPath:(NSIndexPath *)indexPath;// YOU MUSTNOT return here cell's identifier when you return permanentCell for this indexPath from - (UITableViewCell *)permanentCellForItem:atIndexPath: method.
- (void)configureCell:(__kindof UITableViewCell *)cell withItem:(id)item atIndexPath:(NSIndexPath *)indexPath;
- (void)configureHeaderView:(UIView *)view forSection:(MAGTableSection *)section;
- (void)configureFooterView:(UIView *)view forSection:(MAGTableSection *)section;



//		OPTIONAL MAIN REDEFINITION

- (CGFloat)heightForItem:(id)item;
- (BOOL)shouldHighlightAndSelectCellAtIndexPath:(NSIndexPath *)indexPath;
- (UIColor *)selectedBackgroundColorForBaseCell:(MAGBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (SeparatorDisplayingMode)separatorDisplayingModeForBaseCellNormalState:(MAGBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (SeparatorDisplayingMode)separatorDisplayingModeForBaseCellSelectedState:(MAGBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath;

//		OPTIONAL ADDITIONAL REDEFINITION

- (CGFloat)heightForHeaderViewOfSection:(MAGTableSection *)section;
- (CGFloat)heightForFooterViewOfSection:(MAGTableSection *)section;
- (NSString *)headerIdentifierForSection:(MAGTableSection *)section;
- (NSString *)footerIdentifierForSection:(MAGTableSection *)section;

@end
