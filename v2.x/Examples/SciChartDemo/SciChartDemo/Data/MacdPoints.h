#import <Foundation/Foundation.h>
#import <SciChart/SciChart.h>

@interface MacdPoints : NSObject

@property(nonatomic, readonly) SCIGenericType macdValues;
@property(nonatomic, readonly) SCIGenericType signalValues;
@property(nonatomic, readonly) SCIGenericType divergenceValues;

- (instancetype)initWithCapacity:(int)capacity;

- (void)addMacd:(double)macd signal:(double)signal divergence:(double)divergence;

@end
