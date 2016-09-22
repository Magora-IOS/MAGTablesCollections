








#import "TableViewController1.h"
#import "MAGTableSection.h"
#import "TableManager1.h"
#import "UIView+MAGMore.h"

@interface TableViewController1 ()

@property (strong, nonatomic) IBOutlet TableManager1 *tm;

@end

@implementation TableViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *items1 = [@[] mutableCopy];
    for (NSInteger i = 0; i < 20; ++i) {
        [items1 addObject:@(i).stringValue];
    }
    NSMutableArray *items2 = [@[] mutableCopy];
    for (NSInteger i = 0; i < 20; ++i) {
        [items2 addObject:[NSString stringWithFormat:@"%@ string",@(i).stringValue]];
    }
    
    MAGTableSection *section1 = [MAGTableSection new];
    section1.name = @"Section 1";
    section1.items = items1;
    self.tm.tableView.estimatedRowHeight = 57;
    
    MAGTableSection *section2 = [MAGTableSection new];
    section2.name = @"Section 2";
    section2.items = items2;
    
    [self.tm setSections:@[section1,section2]];
    
    NSLog(@"");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}
          
@end
