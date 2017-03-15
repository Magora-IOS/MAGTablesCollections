
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

@property (readonly, nonatomic) BOOL itemsOrSectionsWasFilledByUser;//		YES if any items or sections was set by user after initialization
@property (readonly, nonatomic) NSValue *initialSeparatorInset;//		just to know which was initial separator inset before any actions with separators
@property (nonatomic) BOOL useSeparatorsZeroInset;

@property (nonatomic) BOOL useFooterSeparatorViewInsteadOfEmptyTableFooterView;
@property (readonly, strong, nonatomic) MAGSeparatorView *footerSeparatorView;
@property (readonly, strong, nonatomic) UIView *footerSeparatorFundamentView;

+ (void)setDefaultSelectionColor:(UIColor *)color;//       do it on start of application :)
+ (void)setDefaultSeparatorColor:(UIColor *)color;//       do it on start of application :)

@property (strong, nonatomic) UIColor *separatorsColor;

@property (strong, nonatomic) NSArray <UIColor *> *alternateBackgroundColors;//		color sequence resets in every section. Color sequence inside concrete section willn't updated after any operations on rows, so you must do it yourself

@property (readonly, nonatomic) BOOL displayEmptyViewWhenDataIsEmpty;
@property (readonly, strong, nonatomic) NSString *classnameForEmptyView;
@property (readonly, strong, nonatomic) MAGViewBlock emptyViewCustomizationBlock;
- (void)setDisplayEmptyViewWhenDataIsEmpty:(BOOL)displayEmptyViewWhenDataIsEmpty classnameForEmptyView:(NSString *)classnameForEmptyView emptyViewCustomizationBlock:(MAGViewBlock)emptyViewCustomizationBlock;

@property (nonatomic) BOOL clearSelectionOnce;//		will deselect selected item once
@property (nonatomic) BOOL changingSelectionByUserTapsDisabled;//     but you still can detect selection attempt by didTryChangeSelectionItemBlock

@property (copy, nonatomic) MAGTableItemBlock didSelectedCellWithItemBlock;
@property (copy, nonatomic) MAGTableItemBlock didDeselectedCellWithItemBlock;
@property (copy, nonatomic) MAGTableItemBlock didSelectionCellChangedWithItemBlock;

@property (copy, nonatomic) MAGTableItemBlock didTryChangeSelectionItemBlock;//       use it in pair with notChangeSelectionOnSelectionOrDeselectionEvent property

@property (copy, nonatomic) NSArray *items;//      set it if you want single section
@property (strong, nonatomic) NSArray<MAGTableSection *> *sections;//		set if you want many sections

@property (strong, nonatomic) NSArray *selectedItems;//     if set, all these items will displayed as selected at first or after appearing on screen. After selection's changing by user, it will contains correct selected items. WARN Be careful when some sections contains the same item!

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
