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

@implementation iUC

@synthesize updateURL;
@synthesize delegate;

- (id) init
{
	self = [super init];
    if(self) {
		queue = [[NSOperationQueue alloc] init];
		[queue setMaxConcurrentOperationCount: 1];
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
	VersionCheckerOperation *operation = [[VersionCheckerOperation alloc] init];
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
	NSInteger currentAppVersion = [[self build] integerValue];
	NSLog(@"INFO: currentAppVersion: %d", currentAppVersion);
	NSLog(@"INFO: versionCode: %d", versionCode);
	if(versionCode > currentAppVersion) {
		NSLog(@"INFO: Update available! Notifying delegate");
		NSString *changes = [result valueForKey:@"changes"];
		[delegate newVersionAvailableWithVersionCode:versionCode andChanges:changes];
		return;
	}

	NSLog(@"INFO: no update available.");
}

- (void) receiveNotificationForError:(NSNotification *)notification
{
	NSLog(@"ERROR: could not download version infos");
}

- (NSString *) build
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
}

@end
