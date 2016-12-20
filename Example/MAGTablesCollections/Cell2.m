








#import "Cell2.h"

@interface Cell2 ()

@property (strong, nonatomic) IBOutlet UILabel *myL;
@property (strong, nonatomic) IBOutlet UIButton *myB;

@end

@implementation Cell2

- (void)setItem:(id)item {
    [super setItem:item];

    self.myL.text = item;
    [self.myB setTitle:item forState:UIControlStateNormal];
}

@end
