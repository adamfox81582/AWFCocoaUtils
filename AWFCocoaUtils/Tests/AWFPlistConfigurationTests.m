//
//  AWFPlistConfigurationTests.m
//  AWFCocoaUtils
//
//  Copyright (c) 2013 Adam Fox.
//  Released under The MIT License, see LICENSE file for details.
//

#import <XCTest/XCTest.h>

#import "AWFPlistConfiguration.h"

@interface AWFPlistConfigurationTests : XCTestCase

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSString *tempPlistName;
@property (nonatomic, strong) NSString *tempPlistPath;
@property (nonatomic, strong) NSString *pathToDelete;

@end

@implementation AWFPlistConfigurationTests

- (void)setUp
{
    [super setUp];
    
    self.pathToDelete = nil;
    
    // Can't use main bundle in a unit test
    self.bundle = [NSBundle bundleForClass:[self class]];
    [AWFPlistConfiguration setDefaultBundle:self.bundle];
    
    self.tempPlistName = [[NSUUID UUID] UUIDString];
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", self.tempPlistName];
    self.tempPlistPath = [self.bundle.bundlePath stringByAppendingPathComponent:fileName];
}

- (void)tearDown
{
    [super tearDown];
    
    if (self.pathToDelete)
    {
        [[NSFileManager defaultManager] removeItemAtPath:self.pathToDelete error:nil];
    }
}

/**
 * Create a config from scratch then set/read properties.
 */
- (void)testCreateNewPlistConfiguration
{
    AWFPlistConfiguration *config = [AWFPlistConfigurationTests newTestConfig];
    NSAssert([AWFPlistConfigurationTests myConfigIsEqualToTestConfig:config],
             @"configs aren't equal");
    
    self.pathToDelete = self.tempPlistPath;
}

/**
 * Write new config to disk then read it back.
 */
- (void)testCreateNewPlistConfigurationOnDisk
{
    // Write config to file
    AWFPlistConfiguration *config = [[AWFPlistConfiguration alloc] initWithPlist:self.tempPlistName inBundle:self.bundle];
    NSAssert(config, @"failed to create empty config");
    [AWFPlistConfigurationTests addTestPropertiesToConfig:config];
    [config saveToFile];
    
    // Now read config
    config = [[AWFPlistConfiguration alloc] initWithPlist:self.tempPlistName inBundle:self.bundle];
    NSAssert(config, @"failed to create empty config");
    NSAssert([AWFPlistConfigurationTests myConfigIsEqualToTestConfig:config],
             @"configs aren't equal");
    
    self.pathToDelete = self.tempPlistPath;
}

/**
 * Write values to default config then read it back.
 */
- (void)testDefaultConfig
{
    // Write to default config file
    AWFPlistConfiguration *config = [AWFPlistConfiguration defaultPlistConfiguration];
    NSAssert(config, @"failed to get default config");
    [AWFPlistConfigurationTests addTestPropertiesToConfig:config];
    [config saveToFile];
    
    // Now read default config
    config = [[AWFPlistConfiguration alloc] initWithPlist:[AWFPlistConfiguration defaultPlistName] inBundle:[AWFPlistConfiguration defaultBundle]];
    NSAssert(config, @"failed to get default config");
    NSAssert([AWFPlistConfigurationTests myConfigIsEqualToTestConfig:config],
             @"configs aren't equal");
    
    NSString *pathToDelete = [NSString stringWithFormat:@"%@.plist", [[AWFPlistConfiguration defaultBundle].bundlePath stringByAppendingPathComponent:[AWFPlistConfiguration defaultPlistName]]];
    self.pathToDelete = pathToDelete;
}

+ (AWFPlistConfiguration *)newTestConfig
{
    AWFPlistConfiguration *config = [[AWFPlistConfiguration alloc] init];
    NSAssert(config != nil, @"emty config is nil");
    [AWFPlistConfigurationTests addTestPropertiesToConfig:config];
    return config;
}

+ (void)addTestPropertiesToConfig:(AWFPlistConfiguration *)config
{
    [config setString:@"TestValueOne" forKey:@"TestKeyOne"];
    [config setString:@"TestValueTwo" forKey:@"TestKeyTwo"];
    [config setString:@"TestValueThree" forKey:@"TestKeyThree"];
}

+ (BOOL)myConfigIsEqualToTestConfig:(AWFPlistConfiguration *)myConfig
{
    if (!myConfig) return NO;
    
    AWFPlistConfiguration *testConfig = [AWFPlistConfigurationTests newTestConfig];
    
    NSEnumerator *enumerator = [testConfig keyEnumerator];
    NSString *key;
    while ((key = [enumerator nextObject])) {
        NSString *testValue = [testConfig stringForKey:key];
        NSString *myValue = [myConfig stringForKey:key];
        
        if (!myValue || myValue == (id)[NSNull null] || ![myValue isEqualToString:testValue])
        {
            return NO;
        }
    }
    
    return YES;
}


@end
