//
//  iUC.h
//  iUC
//
//  Created by Paolo Cortis on 25/05/13.
//  Copyright (c) 2013 Paolo Cortis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewVersionAvailableDelegate;

@interface iUC : NSObject
{
	NSURL *updateURL;
	NSURL *appStoreURL;

	id<NewVersionAvailableDelegate> delegate;
	
@private
	NSOperationQueue *queue;
}

@property (strong, nonatomic) NSURL *updateURL;
@property (strong, nonatomic) NSURL *appStoreURL;
@property (strong, nonatomic) id<NewVersionAvailableDelegate> delegate;

- (void) checkVersion;

@end

@protocol NewVersionAvailableDelegate <NSObject>

@optional
- (void)newVersionAvailableWithVersionCode:(NSInteger)newBuildNumber andChanges:(NSString *)changes andAppStoreURL:(NSURL *) url;

@end
