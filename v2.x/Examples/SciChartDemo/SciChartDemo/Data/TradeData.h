#import <Foundation/Foundation.h>

@interface TradeData : NSObject

@property(readonly, nonatomic) NSDate * tradeDate;
@property(readonly, nonatomic) double tradePrice;
@property(readonly, nonatomic) double tradeSize;

- (instancetype)initWithTradeDate:(NSDate *)date tradePrice:(double)price tradeSize:(double)size;

@end
