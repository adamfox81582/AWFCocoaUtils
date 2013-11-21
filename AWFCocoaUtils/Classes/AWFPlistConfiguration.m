//
//  AWFPlistConfiguration.m
//  AWFCocoaUtils
//
//  Copyright (c) 2013 Adam Fox.
//  Released under The MIT License, see LICENSE file for details.
//

#import "AWFPlistConfiguration.h"

@interface AWFPlistConfiguration()

/// Dictionary that represents the configuration
@property (nonatomic, strong, readonly) NSMutableDictionary *plistDictionary;

@end

@implementation AWFPlistConfiguration

@synthesize plistName = _plistName; // I have no idea why this is necessary
@synthesize plistDictionary = _plistDictionary;

static NSString *_defaultPlistName;
static NSBundle *_defaultBundle;
static AWFPlistConfiguration *_defaultPlistConfiguration;

- (id)initWithPlist:(NSString *) plistName inBundle:(NSBundle *)bundle
{
    self = [super init];
    if (self)
    {
        [self loadFromFile:plistName inBundle:bundle];
    }
    return self;
}

- (id)init
{
    self = [super init];
    return self;
}

- (NSMutableDictionary *)plistDictionary
{
    if (_plistDictionary == nil)
    {
        _plistDictionary = [NSMutableDictionary dictionary];
    }
    
    return _plistDictionary;
}

- (void)loadFromFile:(NSString *)plistName inBundle:(NSBundle *)bundle
{
    self.plistName = plistName;
    self.bundle = bundle;
    [self loadFromFile];
}

- (void)loadFromFile
{
    if (!self.plistName) return;
    
    NSString *path = [AWFPlistConfiguration pathForPlist:self.plistName inBundle:self.bundle];
    _plistDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
}

- (void)saveToFile:(NSString *)plistName inBundle:(NSBundle *)bundle
{
    if (!plistName) return;
    NSString *path = [AWFPlistConfiguration pathForPlist:plistName inBundle:bundle];
    [self.plistDictionary writeToFile:path atomically:YES];
}

- (void)saveToFile
{
    [self saveToFile:self.plistName inBundle:self.bundle];
}

- (NSString *)stringForKey:(NSString *)key
{
    return [self.plistDictionary objectForKey:key];
}

- (void)setString:(NSString *)value forKey:(NSString *)key
{
    [self.plistDictionary setObject:value forKey:key];
}

- (void)setString:(NSString *)value forKey:(NSString *)key saveImmediately:(BOOL)saveImmediately
{
    [self setString:value forKey:key];
    if (saveImmediately)
    {
        [self saveToFile];
    }
}

- (NSEnumerator *)keyEnumerator
{
    return [self.plistDictionary keyEnumerator];
}

+ (NSString *)pathForPlist:(NSString *)plistName inBundle:(NSBundle *)bundle
{
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", plistName];
    return [bundle.bundlePath stringByAppendingPathComponent:fileName];
}

+ (NSString *)defaultPlistName
{
    if (_defaultPlistName == nil)
    {
        _defaultPlistName = @"config";
    }
    
    return _defaultPlistName;
}

+ (void)setDefaultPlistName:(NSString *)plistName
{
    _defaultPlistName = plistName;
}

+ (NSBundle *)defaultBundle
{
    if (_defaultBundle == nil)
    {
        _defaultBundle = [NSBundle mainBundle];
    }
    
    return _defaultBundle;
}

+ (void)setDefaultBundle:(NSBundle *)bundle
{
    _defaultBundle = bundle;
}

+ (AWFPlistConfiguration *)defaultPlistConfiguration
{
    if(_defaultPlistConfiguration == nil)
    {
        _defaultPlistConfiguration =
            [[AWFPlistConfiguration alloc]
             initWithPlist:[AWFPlistConfiguration defaultPlistName]
             inBundle:[AWFPlistConfiguration defaultBundle]];
    }
    
    return _defaultPlistConfiguration;
}

@end
