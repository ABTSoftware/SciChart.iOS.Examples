#import "TradeData.h"

@implementation TradeData

@synthesize tradeDate = _tradeDate;
@synthesize tradePrice = _tradePrice;
@synthesize tradeSize = _tradeSize;

- (instancetype)initWithTradeDate:(NSDate *)date tradePrice:(double)price tradeSize:(double)size {
    self = [super init];
    if (self) {
        _tradeDate = date;
        _tradePrice = price;
        _tradeSize = size;
        
    }
    return self;
}

@end
