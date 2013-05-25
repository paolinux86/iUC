//
//  SettingsManager.m
//  Streaming
//
//  Created by Paolo on 25/05/13.
//
//

#import "iUCSettingsManager.h"

@implementation iUCSettingsManager

@synthesize settings;

#pragma mark - Singleton Methods

+ (id) getInstance
{
	static iUCSettingsManager *instance = nil;

    @synchronized(self) {
        if(instance == nil) {
            instance = [[self alloc] init];
		}
    }

    return instance;
}

- (id)init
{
	if(self = [super init]) {
		NSString *filePath = [self getDataFilePath];
		if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
			NSLog(@"file exists");
			settings = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
		} else {
			NSLog(@"file does not exists");
			settings = [[NSMutableDictionary alloc] init];
		}
	}

	return self;
}

#pragma mark - Instance methods

- (id) getPreference:(NSString *) preference
{
	return [settings objectForKey:preference];
}

- (void) savePreference:(NSString *) preference andValue:(id) value
{
	[settings setObject:value forKey:preference];
	BOOL result = [settings writeToFile:[self getDataFilePath] atomically:YES];

	NSLog(@"result: %@", result ? @"OK" : @"ERROR");
}

- (NSString *) getDataFilePath
{
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [path objectAtIndex:0];

	return [documentsDirectory stringByAppendingPathComponent:SETTINGS_PLIST];
}

#pragma mark Specific methods

- (NSNumber *) getIgnoredVersion
{
	id ignoredVersion = [self getPreference:IGNORED_VERSION];

	return ignoredVersion;
}

- (NSNumber *) getReminderIntervalInMinutes
{
	id reminderIntervalInMinutes = [self getPreference:REMINDER_INTERVAL_IN_MINUTES];

	return reminderIntervalInMinutes;
}

- (NSNumber *) getReminderTimestamp
{
	id reminderTimestamp = [self getPreference:REMINDER_TIMESTAMP];

	return reminderTimestamp;
}

- (void) saveIgnoredVersion:(NSNumber *) ignoredVersion
{
	[self savePreference:IGNORED_VERSION andValue:ignoredVersion];
}

- (void) saveReminderIntervalInMinutes:(NSNumber *) reminderIntervalInMinutes
{
	[self savePreference:REMINDER_INTERVAL_IN_MINUTES andValue:reminderIntervalInMinutes];
}

- (void) saveReminderTimestamp:(NSNumber *) reminderTimestamp
{
	[self savePreference:REMINDER_TIMESTAMP andValue:reminderTimestamp];
}

@end
