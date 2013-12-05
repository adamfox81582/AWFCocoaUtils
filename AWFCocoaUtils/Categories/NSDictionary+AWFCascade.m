//
//  NSDictionary+AWFCascade.m
//  AWFCocoaUtils
//
//  Created by Adam Fox on 11/26/13.
//  Copyright (c) 2013 Adam Fox. All rights reserved.
//

#import <objc/runtime.h>

#import "NSDictionary+AWFCascade.h"

NSString *const AWFCascadeContainerSeparator = @"/";
NSString *const AWFCascadeAttributeSeparator = @"@";

static char const * const
    keyForOverrideKeyHandlers =
        "AWFCascadeOverrideKeyHandlers";

@implementation NSDictionary (AWFCascade)

- (NSMutableDictionary *)overrideKeyHandlers
{
    NSMutableDictionary *overrideKeyHandlers = objc_getAssociatedObject(self, keyForOverrideKeyHandlers);
    
    if (!overrideKeyHandlers)
    {
        overrideKeyHandlers = [NSMutableDictionary dictionary];
        
        objc_setAssociatedObject(
            self,
            keyForOverrideKeyHandlers,
            overrideKeyHandlers,
            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return overrideKeyHandlers;
}

- (void)setOverrideKeyHandlers:(NSMutableDictionary *)overrideKeyHandlers
{
    objc_setAssociatedObject(
        self,
        keyForOverrideKeyHandlers,
        overrideKeyHandlers,
        OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addHandler:(AWFOverrideKeyIsApplicableBlock)keyIsApplicableBlock forOverrideKey:(NSString *)overrideKey
{
    [[self overrideKeyHandlers] setObject:keyIsApplicableBlock forKey:overrideKey];
}

- (NSDictionary *)dictionaryByCascadingAlongPath:(NSString *)dictionaryPath
{
    NSMutableDictionary *overrideKeyHandlers = self.overrideKeyHandlers;
    NSMutableDictionary *cascadedDictionary = [NSMutableDictionary dictionary];
    
    // Initialize with attributes in the current dictionary
    [self enumerateKeysAndObjectsUsingBlock:^(NSString *attributeName, id attributeValue, BOOL *stop)
     {
         NSLog(@"%@=%@", attributeName, attributeValue);
         
         if ([attributeValue isKindOfClass:[NSString class]])
         {
             [cascadedDictionary setObject:attributeValue forKey:attributeName];
         }
     }];
    
    // Override with attributes in dictionaries whose keys match applicable override keys
    [overrideKeyHandlers enumerateKeysAndObjectsUsingBlock:
     ^(NSString *overrideKey,
       AWFOverrideKeyIsApplicableBlock isApplicableBlock,
       BOOL *stop)
     {
         if (isApplicableBlock && isApplicableBlock(overrideKey))
         {
             NSDictionary *overrideDictionary = [self objectForKey:overrideKey];
             if (overrideDictionary)
             {
                 overrideDictionary.overrideKeyHandlers = overrideKeyHandlers;
                 [cascadedDictionary addEntriesFromDictionary:
                  (NSDictionary *)[overrideDictionary dictionaryByCascadingAlongPath:dictionaryPath]];
             }
         }
     }];
    
    NSArray *dictionaryPathElements = [dictionaryPath componentsSeparatedByString:AWFCascadeContainerSeparator];
    
    if (dictionaryPathElements && dictionaryPathElements.count > 0)
    {
        NSString *currentPathElement = [dictionaryPathElements firstObject];
        NSDictionary *nextDictionary = [self objectForKey:currentPathElement];
        NSArray *nextDictionaryPathElements = dictionaryPathElements.count > 1 ? [dictionaryPathElements subarrayWithRange:NSMakeRange(1, dictionaryPathElements.count - 1)] : nil;
        NSString *nextPath = [nextDictionaryPathElements componentsJoinedByString:AWFCascadeContainerSeparator];
        
        // Override with cascaded dictionary whose key matches the current path element
        nextDictionary.overrideKeyHandlers = overrideKeyHandlers;
        [cascadedDictionary addEntriesFromDictionary:[nextDictionary dictionaryByCascadingAlongPath:nextPath]];
        
        // Override with cascaded dictionaries whose key matches the current path element
        //            IN dictionaries whose keys match applicable override keys
        [overrideKeyHandlers enumerateKeysAndObjectsUsingBlock:
         ^(NSString *overrideKey,
           AWFOverrideKeyIsApplicableBlock isApplicableBlock,
           BOOL *stop)
         {
             if (isApplicableBlock && isApplicableBlock(overrideKey))
             {
                 NSDictionary *overrideDictionary = [self objectForKey:overrideKey];
                 NSDictionary *nextDictionary = [overrideDictionary objectForKey:currentPathElement];
                 NSArray *nextDictionaryPathElements = dictionaryPathElements.count > 1 ? [dictionaryPathElements subarrayWithRange:NSMakeRange(1, dictionaryPathElements.count - 1)] : nil;
                 NSString *nextPath = [nextDictionaryPathElements componentsJoinedByString:AWFCascadeContainerSeparator];
                 
                 nextDictionary.overrideKeyHandlers = overrideKeyHandlers;
                 [cascadedDictionary addEntriesFromDictionary:[nextDictionary dictionaryByCascadingAlongPath:nextPath]];
             }
         }];
    }
    
    // Return immutable copy
    return [NSDictionary dictionaryWithDictionary:cascadedDictionary];
}

- (id)objectForKey:(id)key cascadedAlongPath:(NSString *)dictionaryPath
{
    NSDictionary *cascadedDictionary = [self dictionaryByCascadingAlongPath:dictionaryPath];
    return [cascadedDictionary objectForKey:key];
}

@end
