








#import "Cell1.h"

@interface Cell1 ()

@property (strong, nonatomic) IBOutlet UIImageView *myIV;
@property (strong, nonatomic) IBOutlet UITextField *myTF;

@end

@implementation Cell1

- (void)setItem:(id)item {
    _item = item;
    
    self.myTF.text = item;
}

@end
