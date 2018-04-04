#import <Foundation/Foundation.h>

@interface PriceBar : NSObject

@property(readonly, nonatomic) NSDate * date;
@property(readonly, nonatomic) double open;
@property(readonly, nonatomic) double high;
@property(readonly, nonatomic) double low;
@property(readonly, nonatomic) double close;
@property(readonly, nonatomic) long volume;

- (instancetype)initWithOpen:(double)open high:(double)high low:(double)low close:(double)close volume:(long)volume;

- (instancetype)initWithDate:(NSDate *)date open:(double)open high:(double)high low:(double)low close:(double)close volume:(long)volume;

@end
