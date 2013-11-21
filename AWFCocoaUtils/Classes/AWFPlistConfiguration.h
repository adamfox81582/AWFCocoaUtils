//
//  AWFPlistConfiguration.h
//  AWFCocoaUtils
//
//  Copyright (c) 2013 Adam Fox.
//  Released under The MIT License, see LICENSE file for details.
//

#import <Foundation/Foundation.h>

/**
 * Basic wrapper for Apple's .plist properties files.  In particular, this class
 * provides convenience methods for setting and getting simple string-based
 * configuration values, saving and loading from the filesystem, and is the owner
 * of a default configuration that can be used for simple apps.
 */
@interface AWFPlistConfiguration : NSObject

/// Name of .plist filename without the .plist suffix.
@property (nonatomic, strong) NSString *plistName;

/// Bundle to which the .plist belongs
@property (nonatomic, strong) NSBundle *bundle;

/**
 * Attempt to read from the given .plist file (no suffix).
 */
- (id)initWithPlist:(NSString *) plistName inBundle:(NSBundle *)bundle;

/**
 * Blank config.
 */
- (id)init;

/**
 * Load given plist from disk.
 */
- (void)loadFromFile:(NSString *)plistName inBundle:(NSBundle *)bundle;

/**
 * Load current plist (self.plistName) from disk.
 */
- (void)loadFromFile;

/**
 * Save to given plist on disk.
 */
- (void)saveToFile:(NSString *)plistName inBundle:(NSBundle *)bundle;

/**
 * Save to current plist (self.plistName) on disk.
 */
- (void)saveToFile;

/**
 * Get the NSString value for the given property key.
 */
- (NSString *)stringForKey:(NSString *)key;

/**
 * Set the NSString value for the given property key.
 */
- (void)setString:(NSString *)value forKey:(NSString *)key;


/**
 * Set the NSString value for the given property key.  If saveImmediately is YES,
 * then the save method will be called immediately after the value is set.
 */
- (void)setString:(NSString *)value forKey:(NSString *)key saveImmediately:(BOOL)saveImmediately;

/**
 * Enumerator for keys in configuration.
 */
- (NSEnumerator *)keyEnumerator;

/**
 * Get the current .plist name.  If not overridden, this will be "config".
 */
+ (NSString *)defaultPlistName;

/**
 * Overrride the default .plist name.  This is useful if you have a simple app that uses
 * a single .plist configuration and you want it easily accesssible from everywhere but
 * don't want to use the default .plist name.  If you choose to override, make sure
 * you do it before any of your code tries to use [AWFPropertiesManager defaultPropertiesManager].
 */
+ (void)setDefaultPlistName:(NSString *)plistName;

/**
 * Get the current default bundle.  If not overridden, this will be [NSBundle mainBundle].
 */
+ (NSBundle *)defaultBundle;

/**
 * Override the default bundle.
 */
+ (void)setDefaultBundle:(NSBundle *)bundle;

/**
 * The default AWFPlistConfiguration object.
 */
+ (AWFPlistConfiguration *)defaultPlistConfiguration;

@end
