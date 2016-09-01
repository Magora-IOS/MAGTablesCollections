








#import "MainViewController.h"
#import "CollectionViewController1.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Select demo";
    [self collection1Action];
}

- (IBAction)collection1Action {
    CollectionViewController1 *vc = [[CollectionViewController1 alloc] initWithNibName:@"CollectionViewController1" bundle:nil];
    [self.navigationController pushViewController:vc animated:NO];
}

- (IBAction)table1Action {
//    TableViewInputController *vc = [[TableViewInputController alloc] initWithNibName:@"TableViewInputController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}


@end
