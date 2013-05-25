//
//  iUCViewController.m
//  iUC
//
//  Created by Paolo Cortis on 25/05/13.
//  Copyright (c) 2013 Paolo Cortis. All rights reserved.
//

#import "iUCResponder.h"
#import "iUCSettingsManager.h"
#import "VersionUtils.h"

@implementation UIResponder (iUC)

- (void) newVersionAvailableWithVersionCode:(NSInteger)newBuildNumber andChanges:(NSString *)changes andAppStoreURL:(NSURL *) url
{
	appStoreURL = url;

	iUCSettingsManager *settingsManager = [iUCSettingsManager getInstance];
	NSNumber *ignoredVersion = [settingsManager getIgnoredVersion];
	if([ignoredVersion compare:[NSNumber numberWithInt:newBuildNumber]] == NSOrderedSame) {
		NSLog(@"INFO: Version %d is in ignore list", newBuildNumber);
		return;
	}

	NSString *changesToShow = changes;
	if([changes isEqualToString:@""]) {
		changesToShow = NSLocalizedStringFromTable(@"ALERT_MESSAGE", @"iUCLocalizable", @"");
	}

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"ALERT_TITLE", @"iUCLocalizable", @"")
													message:changesToShow
												   delegate:self
										  cancelButtonTitle:nil
										  otherButtonTitles:NSLocalizedStringFromTable(@"ALERT_BUTTONS_IGNORE_THIS_VERSION", @"iUCLocalizable", @""),
															NSLocalizedStringFromTable(@"ALERT_BUTTONS_REMIND_ME_LATER", @"iUCLocalizable", @""),
															NSLocalizedStringFromTable(@"ALERT_BUTTONS_UPDATE_NOW", @"iUCLocalizable", @""),
															nil];
	

	[self performSelectorOnMainThread:@selector(openDialog:) withObject:alert waitUntilDone:NO];
}

- (void) openDialog:(UIAlertView *)alert
{
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch(buttonIndex) {
		case 0:
			// ignore this version
			[self ignoreThisVersion];
			break;

		case 1:
			// remind later
			[self remindMeLater];
			break;

		case 2:
			// update now
			[self openAppStore];
			break;

		default:
			break;
	}
}

- (void) ignoreThisVersion
{
	iUCSettingsManager *settingsManager = [iUCSettingsManager getInstance];
	NSNumber *ignoredVersion = [NSNumber numberWithInteger:[[VersionUtils build] integerValue]];
	[settingsManager saveIgnoredVersion:ignoredVersion];
}

- (void) remindMeLater
{
	iUCSettingsManager *settingsManager = [iUCSettingsManager getInstance];
	double nextReminderTimeStamp = [[NSDate date] timeIntervalSince1970];
	nextReminderTimeStamp += [[settingsManager getReminderIntervalInMinutes] intValue] * 60;
	[settingsManager saveReminderTimestamp:[NSNumber numberWithDouble: nextReminderTimeStamp]];
}

- (void) openAppStore
{
	[[UIApplication sharedApplication] openURL:appStoreURL];
}

@end
