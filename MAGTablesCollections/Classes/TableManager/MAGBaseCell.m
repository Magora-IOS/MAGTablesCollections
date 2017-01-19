








#import "MAGBaseCell.h"
#import "MAGSeparatorView.h"
#import "UIView+MAGMore.h"

@interface MAGBaseCell ()

@property (strong, nonatomic) MAGSeparatorView *topSeparatorView;
@property (strong, nonatomic) MAGSeparatorView *bottomSeparatorView;

@property (strong, nonatomic) MAGSeparatorView *selectedTopSeparatorView;
@property (strong, nonatomic) MAGSeparatorView *selectedBottomSeparatorView;

@end

@implementation MAGBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
	
	UIView *backgroundColorView = [[UIView alloc] initWithFrame:self.bounds];
    [self setSelectedBackgroundView:backgroundColorView];
}

- (void)setSelectedBackgroundColor:(UIColor *)color {
    _selectedBackgroundColor = color;
    self.selectedBackgroundView.backgroundColor = color;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    
//    if (selected) {
//        [self displayBackgroundColorAsSelected];
//    } else {
//        [self displayBackgroundColorAsNonselected];
//    }
//}

- (void)displayBackgroundColorAsSelected {
//	if (self.selectedBackgroundColor) {
//		self.contentView.backgroundColor = self.selectedBackgroundColor;
//	} else {
//		self.contentView.backgroundColor = _defaultSelectionColorSTATIC;
//	}
}

//- (void)displayBackgroundColorAsNonselected {
//    self.contentView.backgroundColor = self.nonselectedBackgroundColor;
//}

- (CGFloat)requiredHeight {
	CGFloat result = 0;
	[self.contentView mag_relayout];
//	NSLog(@"NEEDED HEIGHT:");

	NSNumber *topMargin;
	for (UIView *subview in self.contentView.subviews) {
//		NSLog(@"SUBVIEW %@",subview);
		BOOL isViewExternal = [self viewIsExternal:subview];
		if (isViewExternal) {
			if (subview.bottom > result) {
				result = subview.bottom;
			}
			if (!topMargin) {
				topMargin = @(subview.y);
			} else {
				if (subview.y < topMargin.doubleValue) {
					topMargin = @(subview.y);
				}
			}
		}
	}
	if (self.bottomMarginEqualToTopViewMargin) {
		result += topMargin.doubleValue;
	} else {
		result += self.bottomMargin;
	}
	return result;
}

- (BOOL)viewIsExternal:(UIView *)view {
	BOOL result = (view != self.topSeparatorView) && (view != self.bottomSeparatorView) && (view != self.selectedTopSeparatorView) && (view != self.selectedBottomSeparatorView);
	return result;
}

- (void)setSeparatorDisplayingMode:(SeparatorDisplayingMode)separatorDisplayingMode {
	_separatorDisplayingMode = separatorDisplayingMode;
	switch (separatorDisplayingMode) {
  case SeparatorDisplayingModeNone:{
	  [self.topSeparatorView removeFromSuperview];
	  [self.bottomSeparatorView removeFromSuperview];
  }
			break;
			
  case SeparatorDisplayingModeTop:{
	  [self.bottomSeparatorView removeFromSuperview];
	  [self addSeparatorsWithColor:self.separatorColor withTopSeparator:YES withBottomSeparator:NO];
  }
			break;
			
  case SeparatorDisplayingModeBottom:{
	  [self.topSeparatorView removeFromSuperview];
	  [self addSeparatorsWithColor:self.separatorColor withTopSeparator:NO withBottomSeparator:YES];
  }
			break;
			
  case SeparatorDisplayingModeTopAndBottom:{
	  [self addSeparatorsWithColor:self.separatorColor withTopSeparator:YES withBottomSeparator:YES];
  }
			break;
			
  default:
			break;
	}
}

- (void)setSelectedStateSeparatorDisplayingMode:(SeparatorDisplayingMode)selectedStateSeparatorDisplayingMode {
	_selectedStateSeparatorDisplayingMode = selectedStateSeparatorDisplayingMode;
	switch (selectedStateSeparatorDisplayingMode) {
  case SeparatorDisplayingModeNone:{
	  [self.selectedTopSeparatorView removeFromSuperview];
	  [self.selectedBottomSeparatorView removeFromSuperview];
  }
			break;
			
  case SeparatorDisplayingModeTop:{
	  [self.selectedBottomSeparatorView removeFromSuperview];
	  [self addSelectedStateSeparatorsWithColor:self.separatorColor withTopSeparator:YES withBottomSeparator:NO];
  }
			break;
			
  case SeparatorDisplayingModeBottom:{
	  [self.selectedTopSeparatorView removeFromSuperview];
	  [self addSelectedStateSeparatorsWithColor:self.separatorColor withTopSeparator:NO withBottomSeparator:YES];
  }
			break;
			
  case SeparatorDisplayingModeTopAndBottom:{
	  [self addSelectedStateSeparatorsWithColor:self.separatorColor withTopSeparator:YES withBottomSeparator:YES];
  }
			break;
			
  default:
			break;
	}
}

- (void)addSeparatorsWithColor:(UIColor *)color withTopSeparator:(BOOL)displayTopSeparator withBottomSeparator:(BOOL)displayBottomSeparator {
	if (!self.topSeparatorView && displayTopSeparator) {
		_topSeparatorView = [MAGSeparatorView new];
		_topSeparatorView.contentMode = UIViewContentModeTop;
		_topSeparatorView.backgroundColor = color;
		[self.contentView addSubview:_topSeparatorView];
    }
	if (!self.bottomSeparatorView && displayBottomSeparator) {
		_bottomSeparatorView = [MAGSeparatorView new];
		_bottomSeparatorView.contentMode = UIViewContentModeBottom;
		_bottomSeparatorView.backgroundColor = color;
		[self.contentView addSubview:_bottomSeparatorView];
    }
    _topSeparatorView.hidden = !displayTopSeparator;
    _bottomSeparatorView.hidden = !displayBottomSeparator;
}

- (void)addSelectedStateSeparatorsWithColor:(UIColor *)color withTopSeparator:(BOOL)displayTopSeparator withBottomSeparator:(BOOL)displayBottomSeparator {
	if (!self.selectedTopSeparatorView && displayTopSeparator) {
		_selectedTopSeparatorView = [MAGSeparatorView new];
		_selectedTopSeparatorView.contentMode = UIViewContentModeTop;
		_selectedTopSeparatorView.backgroundColor = color;
		[self.selectedBackgroundView addSubview:_selectedTopSeparatorView];
    }
	if (!self.selectedBottomSeparatorView && displayBottomSeparator) {
		_selectedBottomSeparatorView = [MAGSeparatorView new];
		_selectedBottomSeparatorView.contentMode = UIViewContentModeBottom;
		_selectedBottomSeparatorView.backgroundColor = color;
		[self.selectedBackgroundView addSubview:_selectedBottomSeparatorView];
    }
    _selectedTopSeparatorView.hidden = !displayTopSeparator;
    _selectedBottomSeparatorView.hidden = !displayBottomSeparator;
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
	_separatorColor = separatorColor;
	
	self.topSeparatorView.backgroundColor = separatorColor;
	self.bottomSeparatorView.backgroundColor = separatorColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
	
	self.selectedBackgroundView.frame = self.contentView.bounds;
	CGFloat separatorViewHeight = [MAGSeparatorView mostThinLineWidth];
    _topSeparatorView.frame = CGRectMake(self.separatorInset.left, 0, self.contentView.width, [MAGSeparatorView mostThinLineWidth]);//      self.separatorInset automatically filled by parent UITableView of this cell
    _bottomSeparatorView.frame = CGRectMake(self.separatorInset.left, self.height - separatorViewHeight, self.contentView.width, separatorViewHeight);
	
	_selectedTopSeparatorView.frame = CGRectMake(self.separatorInset.left, 0, self.selectedBackgroundView.width, [MAGSeparatorView mostThinLineWidth]);//      self.separatorInset automatically filled by parent UITableView of this cell
    _selectedBottomSeparatorView.frame = CGRectMake(self.separatorInset.left, self.height - separatorViewHeight, self.selectedBackgroundView.width, separatorViewHeight);
}

@end
