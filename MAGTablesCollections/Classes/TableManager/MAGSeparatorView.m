








#import "MAGSeparatorView.h"
#import "UIView+MAGMore.h"

#define kSeparatorColor [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.1f]

@implementation MAGSeparatorView

+ (CGFloat)mostThinLineWidth {
    CGFloat result = 1.0 / [UIScreen mainScreen].scale;
    return result;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
	self.color = _color ? _color : kSeparatorColor;
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef c = UIGraphicsGetCurrentContext();
	
    CGFloat lineWidth = [[self class] mostThinLineWidth];
    if (self.height == 1.0f) {
		CGFloat y = 0;
		if (self.contentMode != UIViewContentModeTop) {
			y = self.height - lineWidth;
		}
		CGContextSetFillColorWithColor(c, self.color.CGColor);
        CGContextFillRect(c, CGRectMake(0, y, self.width, lineWidth));
    }
    else if (self.width == 1.0f) {
        CGFloat x = self.contentMode == UIViewContentModeRight ? self.width : 0;
        CGContextSetFillColorWithColor(c, self.color.CGColor);
        CGContextFillRect(c, CGRectMake(x, 0, lineWidth, self.height));
    }
}

@end
