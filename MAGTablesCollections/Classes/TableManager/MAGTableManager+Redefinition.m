//
//  MAGTableManager+Redefinition.m
//  Pods
//
//  Created by Matveev on 14/03/17.
//
//

#import "MAGTableManager+Redefinition.h"
#import "MAGCommonDefines.h"

@implementation MAGTableManager (Redefinition)

#pragma mark - CRITICAL

- (NSArray *)cellClassNamesForNibOrClassRegistering {
    return nil;
}

- (UITableViewCell *)permanentCellForItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSString *)cellIdentifierForItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    @throw [NSException exceptionWithName:@"no cell identifier" reason:@"identifier should be provided by childs of MAGTableManager" userInfo:nil];
    
    return nil;
}

- (void)configureCell:(UITableViewCell *)cell withItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    THROW_MISSED_IMPLEMENTATION_EXCEPTION;
}

- (void)configureHeaderView:(UIView *)view forSection:(MAGTableSection *)section {
    THROW_MISSED_IMPLEMENTATION_EXCEPTION
}

- (void)configureFooterView:(UIView *)view forSection:(MAGTableSection *)section {
    THROW_MISSED_IMPLEMENTATION_EXCEPTION
}

#pragma mark - OPTIONAL MAIN

- (CGFloat)heightForItem:(id)item {
    return 44.;
}

- (BOOL)shouldHighlightAndSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UIColor *)selectedBackgroundColorForBaseCell:(MAGBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	UIColor *result = RGB(208,208,208);
	return result;
}

- (SeparatorDisplayingMode)separatorDisplayingModeForBaseCellNormalState:(MAGBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	SeparatorDisplayingMode result = SeparatorDisplayingModeBottom;
	return result;
}

- (SeparatorDisplayingMode)separatorDisplayingModeForBaseCellSelectedState:(MAGBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	SeparatorDisplayingMode result = SeparatorDisplayingModeNone;
	return result;
}

#pragma mark - OPTIONAL ADDITIONAL

- (CGFloat)heightForHeaderViewOfSection:(MAGTableSection *)section {
    return 0.00001;
}

- (CGFloat)heightForFooterViewOfSection:(MAGTableSection *)section {
    return 0.00001;
}

- (NSString *)headerIdentifierForSection:(MAGTableSection *)section {
    return nil;
}

- (NSString *)footerIdentifierForSection:(MAGTableSection *)section {
    return nil;
}

@end
