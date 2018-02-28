#import <Foundation/Foundation.h>
#import <SciChart/SciChart.h>
#import "PriceBar.h"

@interface PriceSeries : NSObject

- (instancetype)init;

- (double *)dateData;

- (double *)openData;

- (double *)highData;

- (double *)lowData;

- (double *)closeData;

- (long *)volumeData;

- (double *)indexesAsDouble;

- (void)add:(PriceBar *)item;

- (PriceBar *)itemAt:(int)index;

- (PriceBar *)lastObject;

- (int)size;

@end
