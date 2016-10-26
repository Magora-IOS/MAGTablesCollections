








#import "UIViewController+MAGMore.h"
#import "UIView+MAGMore.h"

@implementation UIViewController (MAGMore)

- (void)mag_addCloseButton {
    UIBarButtonItem *closeBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeAction)];
    self.navigationItem.leftBarButtonItems = @[closeBBI];
}

- (IBAction)mag_closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mag_presentVCinsideNC:(UIViewController *)vc animated:(BOOL)animated {
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nc animated:animated completion:nil];
}

- (void)mag_presentVCinAppTopVCinsideNC:(UIViewController *)vc animated:(BOOL)animated {
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [[UIView mag_appTopViewController] presentViewController:nc animated:animated completion:nil];
}

@end
