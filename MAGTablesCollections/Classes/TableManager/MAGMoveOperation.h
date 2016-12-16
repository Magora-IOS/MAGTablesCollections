








#import <Foundation/Foundation.h>

@class MAGTableSection;

@interface MAGMoveOperation : NSObject

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) MAGTableSection *sourceSection;
@property (strong, nonatomic) MAGTableSection *destinationSection;
@property (nonatomic) NSUInteger indexWhereto;

@end
