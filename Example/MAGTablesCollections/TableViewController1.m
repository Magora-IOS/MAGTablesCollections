








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
    
    self.tm.useFooterSeparatorViewInsteadOfEmptyTableFooterView = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MAGTableSection *section = self.tm.sections[0];
            id item1 = section.items[0];
            id item2 = section.items[1];
			id item3 = section.items[2];
			
			MAGReloadOperation *oper1 = [MAGReloadOperation new];
			oper1.items = @[item1, item3];
			oper1.sourceSection = section1;
			MAGReloadOperation *oper2 = [MAGReloadOperation new];
			oper2.items = @[item2];
			oper2.sourceSection = section1;
			MAGReloadOperation *oper3 = [MAGReloadOperation new];
			oper3.items = @[item1, item2, item3];
			oper3.sourceSection = section2;
			
			[self.tm makeReloadOperations:@[oper1, oper2, oper3] animated:YES completion:^(NSInteger affectedItemCount) {
			    NSLog(@"ITEMS RELOADED");
            }];
//			[self.tm.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MAGTableSection *section1 = self.tm.sections[0];
                MAGTableSection *section2 = self.tm.sections[1];
                id item2 = section1.items[1];
                id item4 = section1.items[3];

                id item5 = section2.items[4];
                id item6 = section2.items[5];
				
				MAGDeleteOperation *oper1 = [MAGDeleteOperation new];
				oper1.items = @[item2, item4];
				oper1.sourceSection = section1;
				MAGDeleteOperation *oper2 = [MAGDeleteOperation new];
				oper2.items = @[item5, item6];
				oper2.sourceSection = section2;
				
				[self.tm makeAllItemOccurenciesDeleteOperations:@[oper1, oper2] animated:YES completion:^(NSInteger affectedItemCount) {
                    NSLog(@"ITEMS DELETED");
				}];
//				[self.tm.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    MAGTableSection *section1 = self.tm.sections[0];
                    MAGTableSection *section2 = self.tm.sections[1];
                    id item1 = @"1 Добавленный в 1 секцию";
                    id item2 = @"2 Добавленный в 1 секцию ";
					MAGInsertOperation *oper1 = [MAGInsertOperation new];
					oper1.items = @[item1, item2];
					oper1.destinationSection = section1;
					oper1.indexWhereto = 9;
					MAGInsertOperation *oper2 = [MAGInsertOperation new];
					oper2.items = @[item1, item2];
					oper2.destinationSection = section1;
					oper2.indexWhereto = 2;

					[self.tm makeInsertOperations:@[oper1, oper1, oper1, oper2, oper2, oper2] animated:YES completion:^(NSInteger affectedItemCount) {
                        NSLog(@"ITEMS INSERTED");
					}];
//					[self.tm.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                });
            });
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tm.items = @[];
        });
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

@end
