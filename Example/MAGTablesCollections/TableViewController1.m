








#import "TableViewController1.h"
#import "TableManager1.h"
#import "EmptyView.h"

@interface TableViewController1 ()

@property (strong, nonatomic) IBOutlet TableManager1 *tm;

@end

@implementation TableViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    [self.tm setDisplayEmptyViewWhenDataIsEmpty:YES classnameForEmptyView:[EmptyView mag_className] emptyViewCustomizationBlock:^(UIView *view) {
        EmptyView *emptyView = (EmptyView *)view;
        emptyView.emptyLabel.text = @"Списочек пуст111";
    }];
    
    self.tm.separatorsColor = [UIColor blueColor];
    
    [self.tm setCloseTableBottomWithSeparatorViewInsteadOfFooterView:YES];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *items1 = [@[] mutableCopy];
        for (NSInteger i = 0; i < 10; ++i) {
            [items1 addObject:@(i).stringValue];
        }
        NSMutableArray *items2 = [@[] mutableCopy];
        for (NSInteger i = 0; i < 10; ++i) {
            [items2 addObject:[NSString stringWithFormat:@"%@ string",@(i).stringValue]];
        }
        
        MAGTableSection *section1 = [MAGTableSection new];
        section1.name = @"section1";
        section1.items = items1;
        self.tm.tableView.estimatedRowHeight = 57;
        
        MAGTableSection *section2 = [MAGTableSection new];
        section2.name = @"section2";
        section2.items = items2;
        
        [self.tm setSections:@[section1,section2]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tm.items = @[];
        });
    });
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

@end
