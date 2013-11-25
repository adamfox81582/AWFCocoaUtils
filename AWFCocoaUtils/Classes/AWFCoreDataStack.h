//
//  AWFCoreDataStack.h
//  AWFCocoaUtils
//
//  Copyright (c) 2013 Adam Fox.
//  Released under The MIT License, see LICENSE file for details.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AWFCoreDataStack;

@protocol AWFCoreDataStackDelegate <NSObject>

- (void)coreDataStack:(AWFCoreDataStack *)coreDataStack didFailWithError:(NSError *)error;

@end

@interface AWFCoreDataStack : NSObject

@property (readonly, strong, nonatomic) NSString *modelName;
@property (strong, nonatomic) NSURL *modelURL;

@property (readonly, strong, nonatomic) NSString *fileNameBase;
@property (strong, nonatomic) NSURL *fileURL;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *defaultManagedObjectContext;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *defaultPersistentStoreCoordinator;

@property (weak, nonatomic) NSObject <AWFCoreDataStackDelegate> *delegate;

- (id)initWithModelName:(NSString *)modelName withFileNameBase:(NSString *)fileNameBase;

@end
