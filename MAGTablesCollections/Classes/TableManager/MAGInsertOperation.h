








#import <Foundation/Foundation.h>

@class MAGTableSection;

@interface MAGInsertOperation : NSObject

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) MAGTableSection *destinationSection;
@property (nonatomic) NSUInteger indexWhereto;

@end
