#import <Foundation/Foundation.h>
#import <SciChart/SciChart.h>

@interface PriceSeries : NSObject

- (instancetype)init;

- (double *)dateData;

- (double *)openData;

- (double *)highData;

- (double *)lowData;

- (double *)closeData;

- (long *)volumeData;

- (double *)indexesAsDouble;

- (void)add:(id)item;

- (int)size;

@end
