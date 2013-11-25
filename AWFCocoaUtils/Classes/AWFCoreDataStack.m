//
//  AWFCoreDataStack.m
//  AWFCocoaUtils
//
//  Copyright (c) 2013 Adam Fox.
//  Released under The MIT License, see LICENSE file for details.
//

#import "AWFCoreDataStack.h"

@implementation AWFCoreDataStack

@synthesize managedObjectModel = _managedObjectModel;
@synthesize defaultManagedObjectContext = _defaultManagedObjectContext;
@synthesize defaultPersistentStoreCoordinator = _defaultPersistentStoreCoordinator;

- (id)initWithModelName:(NSString *)modelName withFileNameBase:(NSString *)fileNameBase
{
    self = [super init];
    
    if (self)
    {
        _modelName = modelName;
        _fileNameBase = fileNameBase;
    }
    
    return self;
}

- (NSURL *)modelURL
{
    if (!_modelURL)
    {
        _modelURL = [[NSBundle mainBundle] URLForResource:self.modelName
                                            withExtension:@"momd"];
    }
    
    return _modelURL;
}

- (NSURL *)fileURL
{
    if (!_fileURL)
    {
        NSURL *docsDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSString *filename = [NSString stringWithFormat:@"%@.sqlite", self.fileNameBase];
        _fileURL = [docsDirectoryURL URLByAppendingPathComponent:filename];
    }
    
    return _fileURL;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel)
    {
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
    }
    return _managedObjectModel;
}

- (NSManagedObjectContext *)defaultManagedObjectContext
{
    if (!_defaultManagedObjectContext)
    {
        NSPersistentStoreCoordinator *coordinator = self.defaultPersistentStoreCoordinator;
        if (coordinator != nil) {
            _defaultManagedObjectContext = [[NSManagedObjectContext alloc] init];
            _defaultManagedObjectContext.persistentStoreCoordinator = coordinator;
        }
    }
    
    return _defaultManagedObjectContext;
}

- (NSPersistentStoreCoordinator *)defaultPersistentStoreCoordinator
{
    if (!_defaultPersistentStoreCoordinator)
    {

        NSError *error = nil;
        
        _defaultPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        if (![_defaultPersistentStoreCoordinator
              addPersistentStoreWithType:NSSQLiteStoreType
              configuration:nil
              URL:self.fileURL
              options:nil
              error:&error])
        {
            if (self.delegate)
            {
                [self.delegate coreDataStack:self didFailWithError:error];
            }
            else
            {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            }
        }
    }
    
    return _defaultPersistentStoreCoordinator;
}

@end
