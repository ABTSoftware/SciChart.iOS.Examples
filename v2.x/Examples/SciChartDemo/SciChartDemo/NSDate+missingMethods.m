#import "NSDate+missingMethods.h"

@implementation NSDate (missingMethods)

+ (NSDate *)dateWithYear:(int)year month:(int)month day:(int)day hour:(int)hour  minute:(int)minute second:(int)second {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents * components = [NSDateComponents new];
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = hour;
    components.minute = minute;
    components.second = second;
    
    return [calendar dateFromComponents:components];
}

@end
