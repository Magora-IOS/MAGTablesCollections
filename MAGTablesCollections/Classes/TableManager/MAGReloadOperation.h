








#import <Foundation/Foundation.h>

@class MAGTableSection;

@interface MAGReloadOperation : NSObject

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) MAGTableSection *sourceSection;

@end
