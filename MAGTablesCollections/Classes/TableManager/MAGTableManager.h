
#import <Foundation/Foundation.h>

#import "MAGTableSection.h"
#import "MAGBaseCell.h"
#import "MAGSeparatorView.h"

#import "MAGInsertOperation.h"
#import "MAGReloadOperation.h"
#import "MAGDeleteOperation.h"
#import "MAGMoveOperation.h"

#define kMAGTableManagerAnimationTimeInterval       0.3//       for covering of 0.25 timeinterval

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

@property (readonly, nonatomic) NSValue *initialSeparatorInset;

@property (nonatomic) BOOL useFooterSeparatorViewInsteadOfEmptyTableFooterView;
@property (readonly, strong, nonatomic) MAGSeparatorView *footerSeparatorView;
@property (readonly, strong, nonatomic) UIView *footerSeparatorFundamentView;

@property (strong, nonatomic) UIColor *separatorsColor;

+ (void)setDefaultSelectionColor:(UIColor *)color;//       do it on start of application :)
+ (void)setDefaultSeparatorColor:(UIColor *)color;//       do it on start of application :)

- (void)setDisplayEmptyViewWhenDataIsEmpty:(BOOL)displayEmptyViewWhenDataIsEmpty classnameForEmptyView:(NSString *)classnameForEmptyView emptyViewCustomizationBlock:(MAGViewBlock)emptyViewCustomizationBlock;

- (id)itemByIndexPath:(NSIndexPath *)indexPath;
- (id)itemByCell:(UITableViewCell *)cell;

- (NSArray *)indexPathsOfItem:(id)item inSections:(NSArray <MAGTableSection *> *)sections;
- (NSArray <MAGTableSection *> *)sectionsContainingItem:(id)item;//      some sections might contains same item

- (void)selectAllRowsWithItem:(id)item animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)deselectAllRowsWithItem:(id)item animated:(BOOL)animated;
- (void)clearSelection;

- (void)makeInsertOperations:(NSArray <MAGInsertOperation *> *)operations animated:(BOOL)animated completion:(MAGIntegerBlock)completion;
- (void)makeReloadOperations:(NSArray <MAGReloadOperation *> *)operations animated:(BOOL)animated completion:(MAGIntegerBlock)completion;
- (void)makeAllItemOccurenciesDeleteOperations:(NSArray <MAGDeleteOperation *> *)operations animated:(BOOL)animated completion:(MAGIntegerBlock)completion;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTableView:(UITableView *)tableView NS_DESIGNATED_INITIALIZER;

- (void)reloadData;

@end
