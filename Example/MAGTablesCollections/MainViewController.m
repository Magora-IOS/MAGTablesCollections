








#import "MainViewController.h"
#import "CollectionViewController1.h"
#import "TableViewController1.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Select demo";
//    [self table1Action];
}

- (IBAction)collection1Action {
    CollectionViewController1 *vc = [[CollectionViewController1 alloc] initWithNibName:@"CollectionViewController1" bundle:nil];
    [self.navigationController pushViewController:vc animated:NO];
}

- (IBAction)table1Action {
    TableViewController1 *vc = [[TableViewController1 alloc] initWithNibName:@"TableViewController1" bundle:nil];
    [self.navigationController pushViewController:vc animated:NO];
}

@end
