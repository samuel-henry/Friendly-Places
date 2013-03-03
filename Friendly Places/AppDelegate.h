//
//  AppDelegate.h
//  Friendly Places
//
//  Created by Sam on 3/2/13.
//  Copyright (c) 2013 sam henry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#pragma mark -- Core Data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (AppDelegate *)sharedAppDelegate;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


# pragma mark -- FB 
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

extern NSString *const FBSessionStateChangedNotification;
@end
