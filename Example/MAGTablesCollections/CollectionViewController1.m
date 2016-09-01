

#import "CollectionViewController1.h"
#import "MAGCustomCollectionViewLayout.h"
#import "CollectionManager1.h"

@interface CollectionViewController1 ()

@property (strong, nonatomic) IBOutlet CollectionManager1 *cm;

@end

@implementation CollectionViewController1

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cm.collectionView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.cm.collectionView.layer.borderWidth = 1;
    
    [self mode0Action];
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//
//}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)mode0Action {
    NSArray *array =  @[@[[NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)],[NSValue valueWithCGRect:CGRectMake(30, 30, 200, 100)]],
                        @[[NSValue valueWithCGRect:CGRectMake(200, 120, 300, 75)],[NSValue valueWithCGRect:CGRectMake(250, 300, 500, 250)]]
                        ];
    
    MAGCustomCollectionViewLayout *layout = [MAGCustomCollectionViewLayout new];
    [layout setCellFrames:array];
    [self.cm setLayout:layout];

    NSMutableArray *items = [@[] mutableCopy];
    for (NSInteger i = 0; i < 4; ++i) {
        [items addObject:@(i)];
    }
    [self.cm setItems:items viaSplittinOnEqualSizeSectionsWithColumnCount:2];
}

- (IBAction)mode1Action {
    NSMutableArray *items = [@[] mutableCopy];
    for (NSInteger i = 0; i < 10000; ++i) {//       on 100 000 lags will appeared
        [items addObject:@(i)];
    }
    [self.cm setItems:items viaSplittinOnEqualSizeSectionsWithColumnCount:100];

    
    MAGCustomCollectionViewLayout *layout = [MAGCustomCollectionViewLayout new];
    [layout setDefaultItemSize:CGSizeMake(105,155) verticalSpace:1 horizontalSpace:1];
    [self.cm setLayout:layout];
}

- (IBAction)mode2Action {
    NSMutableArray *items = [@[] mutableCopy];
    for (NSInteger i = 0; i < 25; ++i) {
        [items addObject:@(i)];
    }
    [self.cm setItems:items viaSplittinOnEqualSizeSectionsWithColumnCount:5];

    MAGCustomCollectionViewLayout *layout = [MAGCustomCollectionViewLayout new];
    [layout setDefaultItemSize:CGSizeMake(50, 50) cellProportionalHeights:@[@1.7,@0.8,@2,@1.2,@1] cellProportionalWidths:@[@1,@1,@2.5,@1,@2] verticalSpace:1 horizontalSpace:1];
    [self.cm setLayout:layout];
}

@end
