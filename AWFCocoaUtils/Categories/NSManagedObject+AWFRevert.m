//
//  NSManagedObject+AWFRevert.m
//  AWFCocoaUtils
//
//  Copyright (c) 2013 Adam Fox.
//  Released under The MIT License, see LICENSE file for details.
//

#import "NSManagedObject+AWFRevert.h"

@implementation NSManagedObject (AWFRevert)

- (void)revert
{
    NSDictionary *changedValues = [self changedValues];
    NSDictionary *committedValues = [self committedValuesForKeys:[changedValues allKeys]];
    
    [changedValues enumerateKeysAndObjectsUsingBlock:^(id key, id changedValue, BOOL *stop)
    {
        [self setValue:[committedValues objectForKey:key] forKey:key];
    }];
}

@end
