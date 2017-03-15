








#import "TableManager1.h"
#import "Cell1.h"
#import "Cell2.h"

@interface TableManager1 ()

@property (strong, nonatomic) Cell1 *sampleCell1;
@property (strong, nonatomic) Cell2 *sampleCell2;

@property (strong, nonatomic) UITableViewCell *header1;
@property (strong, nonatomic) UITableViewCell *header2;

@end

@implementation TableManager1

- (void)awakeFromNib {
	[super awakeFromNib];;
	
	self.separatorsColor = [UIColor redColor];
	self.alternateBackgroundColors = @[RGB(250,250,250),RGB(225,225,225), RGB(200,200,200)];
}

- (NSString *)cellIdentifierForItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    NSString *result;
    switch (indexPath.section) {
        case 0:
            result = [Cell1 mag_className];
            break;

        case 1:
            result = [Cell2 mag_className];
            break;

        default:
            break;
    }
    return result;
}

- (NSArray *)cellClassNamesForNibOrClassRegistering {
    return @[[Cell1 mag_className],[Cell2 mag_className]];
}

- (void)configureCell:(UITableViewCell *)cell withItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        Cell1 *castedCell = (Cell1 *)cell;
        castedCell.item = item;
    } else {
        Cell2 *castedCell = (Cell2 *)cell;
        castedCell.item = item;
    }
}

- (CGFloat)heightForHeaderViewOfSection:(MAGTableSection *)section {
    CGFloat result;
    if (!self.header1) {
        self.header1 = [[[NSBundle mainBundle] loadNibNamed:@"Header1" owner:nil options:0] firstObject];
    }
    if (!self.header2) {
        self.header2 = [[[NSBundle mainBundle] loadNibNamed:@"Header2" owner:nil options:0] firstObject];
    }
    
    if (EQUAL(section.name, @"section1")) {
        result = self.header1.height;
    } else {
        result = self.header2.height;
    }
//    NSLog(@"result header height %@ %@",@(section).stringValue, @(result).stringValue);
    return result;

}

- (NSString *)headerIdentifierForSection:(MAGTableSection *)section {
    NSString *result;
    if (EQUAL(section.name, @"section1")) {
        result = @"Header1";
    } else {
        result = @"Header2";
    }
    return result;
}

- (CGFloat)heightForItem:(id)item {
    CGFloat result;
    if (!self.sampleCell1) {
        self.sampleCell1 = [[[NSBundle mainBundle] loadNibNamed:@"Cell1" owner:nil options:0] firstObject];
    }
    if (!self.sampleCell2) {
        self.sampleCell2 = [[[NSBundle mainBundle] loadNibNamed:@"Cell2" owner:nil options:0] firstObject];
    }
    
    NSArray *indexPaths = [self indexPathsOfItem:item inSections:self.sections];//       I use all sections bcs I know that all sections contains unical elements
    if (indexPaths.count) {
        NSIndexPath *itemIndexPath = [indexPaths firstObject];
        switch (itemIndexPath.section) {
            case 0: {
                result = self.sampleCell1.height;
            }
                break;
                
            case 1:
                result = self.sampleCell2.height;
                break;
                
            default:
                break;
        }

    }
    return result;
}

- (void)configureHeaderView:(UIView *)view forSection:(MAGTableSection *)section {

}

- (UIColor *)selectedBackgroundColorForBaseCell:(MAGBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	UIColor *result = [UIColor orangeColor];
	if (indexPath.row % 2 == 0) {
		result = [UIColor lightGrayColor];
	}
	return result;
}

- (SeparatorDisplayingMode)separatorDisplayingModeForBaseCellNormalState:(MAGBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	SeparatorDisplayingMode result = SeparatorDisplayingModeNone;
	if (indexPath.row % 2 == 0) {
		result = SeparatorDisplayingModeBottom;
	}
	return result;
}

- (SeparatorDisplayingMode)separatorDisplayingModeForBaseCellSelectedState:(MAGBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	SeparatorDisplayingMode result = SeparatorDisplayingModeNone;
//	if (indexPath.row % 2 == 0) {
//		result = SeparatorDisplayingModeBottom;
//	}
	return result;
}

@end
