








#import <Foundation/Foundation.h>

@class MAGTableSection;

@interface MAGDeleteOperation : NSObject

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) MAGTableSection *sourceSection;

@end
