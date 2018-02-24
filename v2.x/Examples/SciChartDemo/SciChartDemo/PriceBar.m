#import "PriceBar.h"

@implementation PriceBar

@synthesize date = _date;
@synthesize open = _open;
@synthesize high = _high;
@synthesize low = _low;
@synthesize close = _close;
@synthesize volume = _volume;

- (instancetype)initWithOpen:(double)open high:(double)high low:(double)low close:(double)close volume:(long)volume {
    self = [super init];
    if (self) {
        _date = [[NSDate alloc] init];
        _open = open;
        _high = high;
        _low = low;
        _close = close;
        _volume = volume;
    }
    return self;
}

- (instancetype)initWithDate:(NSDate *)date open:(double)open high:(double)high low:(double)low close:(double)close volume:(long)volume {
    self = [super init];
    if (self) {
        _date = date;
        _open = open;
        _high = high;
        _low = low;
        _close = close;
        _volume = volume;
    }
    return self;
}

@end
