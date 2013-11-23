//
//  AWFMySQLDateFormatter.m
//  AWFCocoaUtils
//
//  Copyright (c) 2013 Adam Fox.
//  Released under The MIT License, see LICENSE file for details.
//

#import "AWFMySQLDateFormatter.h"

@implementation AWFMySQLDateFormatter

- (void)setupFormatterWithLocale:(NSLocale *)locale
{
    [self setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss'.'S"];
    [self setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
}

- (id)init
{
    if (self = [super init])
    {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        // TODO get the locale from SKProduct? or a setting
        
        [self setupFormatterWithLocale:locale];
    }
    
    return self;
}

- (id)initWithLocale:(NSLocale *)locale
{
    if (self = [super init])
    {
        [self setupFormatterWithLocale:locale];
    }
    
    return self;
}

@end
