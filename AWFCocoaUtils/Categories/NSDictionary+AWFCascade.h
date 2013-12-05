//
//  NSDictionary+AWFCascade.h
//  AWFCocoaUtils
//
//  Created by Adam Fox on 11/26/13.
//  Copyright (c) 2013 Adam Fox. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const AWFCascadeContainerSeparator;
FOUNDATION_EXPORT NSString *const AWFCascadeAttributeSeparator;

typedef BOOL (^AWFOverrideKeyIsApplicableBlock)(NSString *overrideKey);

@interface NSDictionary (AWFCascade)

- (void)addHandler:(AWFOverrideKeyIsApplicableBlock)keyIsApplicableBlock forOverrideKey:(NSString *)overrideKey;
- (NSDictionary *)dictionaryByCascadingAlongPath:(NSString *)dictionaryPath;
- (id)objectForKey:(id)key cascadedAlongPath:(NSString *)dictionaryPath;

@end
