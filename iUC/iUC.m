//
//  iUC.m
//  iUC
//
//  Created by Paolo Cortis on 25/05/13.
//  Copyright (c) 2013 Paolo Cortis. All rights reserved.
//

#import "iUC.h"
#import "iUC_private.h"

#import "VersionCheckerOperation.h"
#import "VersionUtils.h"

@implementation iUC

@synthesize updateURL;
@synthesize appStoreURL;
@synthesize delegate;

- (id) init
{
	self = [super init];
    if(self) {
		queue = [[NSOperationQueue alloc] init];
		[queue setMaxConcurrentOperationCount: 1];
		settingsManager = [iUCSettingsManager getInstance];
	}

	return self;
}

- (void) checkVersion
{
	if(self.updateURL == nil) {
		NSLog(@"ERROR: no updateURL");
		return;
	}

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationForCompleted:) name:CHECKVERSION_NOTIFICATION_NAME_COMPLETED object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationForError:) name:CHECKVERSION_NOTIFICATION_NAME_FAILED object:nil];

	NSLog(@"INFO: Launching download of version info");
	VersionCheckerOperation *operation = [[VersionCheckerOperation alloc] initWithURL:self.updateURL];
	[queue addOperation:operation];
}

- (void) receiveNotificationForCompleted: (NSNotification *)notification
{
	NSError *error = nil;

	NSLog(@"INFO: parsing JSON");
	NSLog(@"VERBOSE: JSON: %@", [NSString stringWithUTF8String:[[notification object] bytes]]);
	NSDictionary *result = [NSJSONSerialization JSONObjectWithData:[notification object] options:kNilOptions error:&error];
	if(error != nil) {
		NSLog(@"Error: could not parse json: %@", [error localizedDescription]);
		return;
	}

	NSInteger versionCode = [[result valueForKey:@"version_code"] integerValue];
	NSInteger currentAppVersion = [[VersionUtils build] integerValue];
	NSLog(@"INFO: currentAppVersion: %d", currentAppVersion);
	NSLog(@"INFO: versionCode: %d", versionCode);

	if(versionCode <= currentAppVersion) {
		NSLog(@"INFO: no update available.");
		return;
	}

	NSLog(@"INFO: Update available!");

	NSTimeInterval currentTimeStamp = [[NSDate date] timeIntervalSince1970];
	NSNumber *reminderTimeStamp = [settingsManager getReminderTimestamp];
	if([reminderTimeStamp compare:[NSNumber numberWithInt:-1]] != NSOrderedSame &&
	   [reminderTimeStamp compare:[NSNumber numberWithDouble:currentTimeStamp]] != NSOrderedAscending) {
		NSLog(@"INFO: reminder timeout wasn't expired");
		return;
	}

	if(![delegate respondsToSelector:@selector(newVersionAvailableWithVersionCode:andChanges:)]) {
		NSLog(@"ERROR: delegate does not respond to selector newVersionAvailableWithVersionCode:andChanges:");
		return;
	}

	NSLog(@"INFO: Notifying delegate");
	NSString *changes = [result valueForKey:@"content"];
	[delegate newVersionAvailableWithVersionCode:versionCode andChanges:changes andAppStoreURL:appStoreURL];
}

- (void) receiveNotificationForError:(NSNotification *)notification
{
	NSLog(@"ERROR: could not download version infos");
}

@end
