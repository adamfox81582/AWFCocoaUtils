//
//  AWFCoreDataStackTests.m
//  AWFCocoaUtils
//
//  Copyright (c) 2013 Adam Fox.
//  Released under The MIT License, see LICENSE file for details.
//

#import <XCTest/XCTest.h>

#import "AWFCoreDataStack.h"
#import "AWFTestUser.h"
#import "NSManagedObject+AWFRevert.h"

@interface AWFCoreDataStackTests : XCTestCase <AWFCoreDataStackDelegate>

@property (nonatomic, strong, readonly) AWFCoreDataStack *coreDataStack;

@property (nonatomic, strong, readonly) NSString *modelName;
@property (nonatomic, strong, readonly) NSString *fileNameBase;

@end

@implementation AWFCoreDataStackTests

- (void)setUp
{
    [super setUp];
    
    _modelName = @"AWFTestModel";
    _fileNameBase = [NSString stringWithFormat:@"AWFTestModel-Test-%@", [[NSUUID UUID] UUIDString]];
    _coreDataStack = [[AWFCoreDataStack alloc] initWithModelName:_modelName withFileNameBase:_fileNameBase];
    _coreDataStack.delegate = self;
    
    // Override URL to use the test's bundle
    _coreDataStack.modelURL = [[NSBundle bundleForClass:[self class]] URLForResource:_coreDataStack.modelName withExtension:@"momd"];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)coreDataStack:(AWFCoreDataStack *)coreDataStack didFailWithError:(NSError *)error
{
    XCTFail(@"Error in core data stack: %@", error.description);
}

- (void)testCreateDatabaseAndRevert
{
    // Use the default managed object context from the AWFCoreDataStack
    NSManagedObjectContext *context = self.coreDataStack.defaultManagedObjectContext;
    
    // Create a new managed object
    NSString *EntityName = @"TestUser";
    AWFTestUser *user = [NSEntityDescription
                        insertNewObjectForEntityForName:EntityName
                        inManagedObjectContext:context];
    
    // Set managed object's properties
    user.emailAddress = @"adamfox81582@gmail.com";
    user.firstName = @"Adam";
    user.lastName = @"Fox";
    
    // Save changes
    NSError *error;
    XCTAssert([context save:&error], @"Couldn't save: %@", error.localizedDescription);
    NSLog(@"Saved to %@", self.coreDataStack.fileURL);
    
    // Read from database
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:EntityName
                                        inManagedObjectContext:context]];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    XCTAssert(fetchedObjects && fetchedObjects.count > 0, @"No objects read from database");
    
    for (AWFTestUser *fetchedUser in fetchedObjects)
    {
        // Make a change and revert it
        NSString *originalEmailAddress = fetchedUser.emailAddress;
        fetchedUser.emailAddress = @"wrongaddress@whatever.com";
        [fetchedUser revert];
        XCTAssertEqualObjects(fetchedUser.emailAddress, originalEmailAddress, @"Failed to revert changes");
    }
    
    // Delete test files since the test succeeded
    NSURL *parentDir = [self.coreDataStack.fileURL URLByDeletingLastPathComponent];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:parentDir includingPropertiesForKeys:nil options:0 error:nil];
    for (NSURL *file in files)
    {
        if ([file.lastPathComponent rangeOfString:self.fileNameBase].location == 0 &&
            [file.lastPathComponent rangeOfString:@".sqlite"].location != NSNotFound)
        {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
    }
}

@end
