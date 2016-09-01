
#import <Foundation/Foundation.h>

#import "MAGTableSection.h"

typedef void (^RCCollectionItemBlock) (id item);

/**
        @warn TableManager shoudn't contains some of identical section objects at single time!
 */

@interface MAGCollectionManager : NSObject <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//
@property (copy, nonatomic) RCCollectionItemBlock didSelectedCellWithItemBlock;
@property (copy, nonatomic) RCCollectionItemBlock didUnselectedCellWithItemBlock;
@property (copy, nonatomic) NSArray *items;//      for single section
@property (strong, nonatomic) NSArray<MAGTableSection *> *sections;
@property (nonatomic) BOOL scrollToTopAfterLayoutChange;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView collectionViewLayout:(UICollectionViewLayout *)collectionViewLayout;

- (void)setItems:(NSArray *)items;
- (void)setItems:(NSArray *)items viaSplittinOnEqualSizeSectionsWithColumnCount:(NSInteger)columnCount;
- (void)setSections:(NSArray<MAGTableSection *> *)sections;

- (void)setLayout:(UICollectionViewLayout *)layout;

- (void)reloadData;

- (void)selectAllRowsWithItem:(id)item animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition;
- (NSArray *)selectedItems;

//      must be override

- (NSArray *)cellNibNames;
- (NSString *)cellIdentifierForItem:(id)item atIndexPath:(NSIndexPath *)indexPath;

@end
