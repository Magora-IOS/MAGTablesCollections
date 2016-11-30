
#import <Foundation/Foundation.h>

#import "MAGTableSection.h"
#import "MAGSeparatorView.h"

typedef void (^MAGTableItemBlock) (id item);

typedef void (^MAGViewBlock) (UIView *view);

typedef void (^MAGIntegerBlock) (NSInteger affectedItemCount);
/**
        @warn TableManager shoudn't contains some of identical section objects at single time!
 */

@interface MAGTableManager : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) MAGTableItemBlock didSelectedCellWithItemBlock;
@property (copy, nonatomic) MAGTableItemBlock didDeselectedCellWithItemBlock;
@property (copy, nonatomic) MAGTableItemBlock didSelectionCellChangedWithItemBlock;

@property (copy, nonatomic) MAGTableItemBlock didTryChangeSelectionItemBlock;//       use it in pair with notChangeSelectionOnSelectionOrDeselectionEvent property

@property (nonatomic) BOOL itemsOrSectionsWasFilledByUser;

@property (copy, nonatomic) NSArray *items;//      for single section
@property (strong, nonatomic) NSArray<MAGTableSection *> *sections;

@property (nonatomic) BOOL clearSelectionOnce;
@property (nonatomic) BOOL changingSelectionByUserTapsDisabled;//     but detect action you can via didTryChangeSelectionItemBlock

@property (strong, nonatomic) NSArray *selectedItems;//     if set, all this items will displayed as selected at first or after appearing on screen. After selection's changing by user, it will contains correct selected items. WARN Be careful when some sections contains the same utem!
@property (nonatomic) BOOL useSeparatorsZeroInset;

@property (readonly, nonatomic) BOOL displayEmptyViewWhenDataIsEmpty;
@property (readonly, strong, nonatomic) NSString *classnameForEmptyView;
@property (readonly, strong, nonatomic) MAGViewBlock emptyViewCustomizationBlock;

@property (nonatomic) BOOL useFooterSeparatorViewInsteadOfEmptyTableFooterView;
@property (readonly, strong, nonatomic) MAGSeparatorView *footerSeparatorView;
@property (readonly, strong, nonatomic) UIView *footerSeparatorFundamentView;

@property (strong, nonatomic) UIColor *separatorsColor;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTableView:(UITableView *)tableView NS_DESIGNATED_INITIALIZER;

- (id)itemByIndexPath:(NSIndexPath *)indexPath;
- (id)itemByCell:(UITableViewCell *)cell;

- (NSArray *)indexPathsOfItem:(id)item inSections:(NSArray <MAGTableSection *> *)sections;
- (NSArray <MAGTableSection *> *)sectionsContainingItem:(id)item;//      some sections might contains same item

- (void)reloadData;

//- (void)selectFirstRowWithItem:(id)item animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)selectAllRowsWithItem:(id)item animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)deselectAllRowsWithItem:(id)item animated:(BOOL)animated;
- (void)clearSelection;


- (void)insertItem:(id)item inSection:(MAGTableSection *)section inPosition:(NSInteger)position animated:(BOOL)animated completion:(MAGIntegerBlock)completion;
- (void)reloadAllRowsWithItem:(id)item inSections:(NSArray<MAGTableSection *> *)sections animated:(BOOL)animated completion:(MAGIntegerBlock)completion;
- (void)deleteAllItemOccurencies:(id)item inSections:(NSArray<MAGTableSection *> *)sections animated:(BOOL)animated completion:(MAGIntegerBlock)completion;

- (void)setDisplayEmptyViewWhenDataIsEmpty:(BOOL)displayEmptyViewWhenDataIsEmpty classnameForEmptyView:(NSString *)classnameForEmptyView emptyViewCustomizationBlock:(MAGViewBlock)emptyViewCustomizationBlock;

//      might be override

- (CGFloat)heightForItem:(id)item;
- (CGFloat)heightForHeaderViewOfSection:(MAGTableSection *)section;
- (CGFloat)heightForFooterViewOfSection:(MAGTableSection *)section;

- (NSString *)headerIdentifierForSection:(MAGTableSection *)section;
- (NSString *)footerIdentifierForSection:(MAGTableSection *)section;

- (BOOL)shouldHighlightAndSelectCellAtIndexPath:(NSIndexPath *)indexPath;
// must be override
- (UITableViewCell *)permanentCellForItem:(id)item atIndexPath:(NSIndexPath *)indexPath;
- (NSString *)cellIdentifierForItem:(id)item atIndexPath:(NSIndexPath *)indexPath;//        ! indexPath added bcs different sections can contains same item but display it in different cell types
- (NSArray *)cellClassNamesForNibOrClassRegistering;//        for registering of nib or class (if nib not exists)
- (void)configureCell:(__kindof UITableViewCell *)cell withItem:(id)item atIndexPath:(NSIndexPath *)indexPath;//     indexPath added for same reason
- (void)configureHeaderView:(UIView *)view forSection:(MAGTableSection *)section;
- (void)configureFooterView:(UIView *)view forSection:(MAGTableSection *)section;

@end
