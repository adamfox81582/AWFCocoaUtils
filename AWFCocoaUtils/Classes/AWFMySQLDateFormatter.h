//
//  AWFMySQLDateFormatter.h
//  AWFCocoaUtils
//
//  Copyright (c) 2013 Adam Fox.
//  Released under The MIT License, see LICENSE file for details.
//

#import <Foundation/Foundation.h>

/**
 NSDateFormatter that formats dates suitable for use in MySQL queries.
 
 @discussion
 While nobody really uses MySQL in iOS directly, some (especially proprietary)
 network protocols require dates pre-formatted for database consumption.
 */
@interface AWFMySQLDateFormatter : NSDateFormatter

- (id)init;
- (id)initWithLocale:(NSLocale *)locale;

@end
