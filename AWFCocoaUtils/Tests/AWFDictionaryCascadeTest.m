//
//  AWFDictionaryCascadeTest.m
//  AWFCocoaUtils
//
//  Created by Adam Fox on 11/26/13.
//  Copyright (c) 2013 Adam Fox. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSDictionary+AWFCascade.h"

@interface AWFDictionaryCascadeTest : XCTestCase

@property (nonatomic, strong) NSDictionary *testDictionary;

@end

@implementation AWFDictionaryCascadeTest

- (void)setUp
{
    [super setUp];
    
    // Use this block to handle all override key tests
    AWFOverrideKeyIsApplicableBlock overrideKeyIsApplicableBlock = ^BOOL (NSString *overrideKey)
    {
        // These are just provided as an example, they aren't part of the tests
        // because they depend on environment variables that would cause the tests
        // to behave differently in different environments.
        if ([overrideKey isEqualToString:@"iPhone"])
        {
            return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
        }
        else if ([overrideKey isEqualToString:@"iPad"])
        {
            return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        }
        else if ([overrideKey isEqualToString:@"iOS7"])
        {
            return NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1;
        }
        
        // These are the keys used in the tests (plus the negative keys, which
        // aren't necessary because this block will just return NO anyways)
        else if ([overrideKey isEqualToString:@"PositiveOverrideKey-1"])
        {
            return YES;
        }
        else if ([overrideKey isEqualToString:@"PositiveOverrideKey-2"])
        {
            return YES;
        }
        
        return NO;
    };
    
    // Read the plist into a dictionary
    NSString * plistPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"AWFDictionaryCascadeTest" ofType:@"plist"];
    self.testDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    // Add override handlers
    [self.testDictionary addHandler:overrideKeyIsApplicableBlock forOverrideKey:@"iPhone"];
    [self.testDictionary addHandler:overrideKeyIsApplicableBlock forOverrideKey:@"iPad"];
    [self.testDictionary addHandler:overrideKeyIsApplicableBlock forOverrideKey:@"iOS7"];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testEmptyPaths
{
    XCTAssertEqualObjects([self.testDictionary objectForKey:@"attribute-1" cascadedAlongPath:nil], @"testValue-1");
    XCTAssertEqualObjects([self.testDictionary objectForKey:@"attribute-1" cascadedAlongPath:@""], @"testValue-1");
}

- (void)testNestedDictionaries
{
    NSString *key = nil;
    NSString *expectedValue = nil;
    NSString *path = nil;
    
    key = @"attribute-1.1";
    path = @"NestedDictionary-1";
    expectedValue = @"testValue-1.1";
    XCTAssertEqualObjects([self.testDictionary objectForKey:key cascadedAlongPath:path], expectedValue);

    key = @"attribute-1.1.1";
    path = @"NestedDictionary-1/NestedDictionary-1.1";
    expectedValue = @"testValue-1.1.1";
    XCTAssertEqualObjects([self.testDictionary objectForKey:key cascadedAlongPath:path], expectedValue);

    key = @"attribute-1.1.1.1";
    path = @"NestedDictionary-1/NestedDictionary-1.1/NestedDictionary-1.1.1";
    expectedValue = @"testValue-1.1.1.1";
    XCTAssertEqualObjects([self.testDictionary objectForKey:key cascadedAlongPath:path], expectedValue);
}

- (void)testCascadedAttributes
{
    NSString *key = nil;
    NSString *expectedValue = nil;
    
    NSString *path = @"NestedDictionary-1/NestedDictionary-1.1/NestedDictionary-1.1.1";
    
    key = @"attribute-1";
    expectedValue = @"testValue-1";
    XCTAssertEqualObjects([self.testDictionary objectForKey:key cascadedAlongPath:path], expectedValue);

    key = @"attribute-1.1";
    expectedValue = @"testValue-1.1";
    XCTAssertEqualObjects([self.testDictionary objectForKey:key cascadedAlongPath:path], expectedValue);
    
    key = @"attribute-1.1.1";
    expectedValue = @"testValue-1.1.1";
    XCTAssertEqualObjects([self.testDictionary objectForKey:key cascadedAlongPath:path], expectedValue);
}

- (void)testReplacedAttributes
{
    NSString *key = @"replacedAttribute-1";
    NSString *expectedValue = nil;
    NSString *path = nil;
    
    expectedValue = @"originalValue-1";
    XCTAssertEqualObjects([self.testDictionary objectForKey:key cascadedAlongPath:path], expectedValue);
    
    path = @"NestedDictionary-1";
    expectedValue = @"replacedValue-1.1";
    XCTAssertEqualObjects([self.testDictionary objectForKey:key cascadedAlongPath:path], expectedValue);
    
    path = @"NestedDictionary-1/NestedDictionary-1.1";
    expectedValue = @"replacedValue-1.1.1";
    XCTAssertEqualObjects([self.testDictionary objectForKey:key cascadedAlongPath:path], expectedValue);
    
    path = @"NestedDictionary-1/NestedDictionary-1.1/NestedDictionary-1.1.1";
    expectedValue = @"replacedValue-1.1.1.1";
    XCTAssertEqualObjects([self.testDictionary objectForKey:key cascadedAlongPath:path], expectedValue);
}

- (void)testOverriddenAttributes
{
    
}

@end
