//
//  SettingsManager.h
//  Streaming
//
//  Created by Paolo on 09/01/13.
//
//

#import <Foundation/Foundation.h>

#define SETTINGS_PLIST @"iUCSettings.plist"

#define IGNORED_VERSION @"ignoredVersion"
#define REMINDER_INTERVAL_IN_MINUTES @"reminderIntervalInMinutes"
#define REMINDER_TIMESTAMP @"reminderTimeStamp"

@interface iUCSettingsManager : NSObject
{
	NSMutableDictionary *settings;
}

@property (strong, nonatomic) NSDictionary *settings;

+ (id) getInstance;

- (id) getPreference:(NSString *) preference;
- (void) savePreference:(NSString *) preference andValue:(id) value;

- (NSNumber *) getIgnoredVersion;
- (NSNumber *) getReminderIntervalInMinutes;
- (NSNumber *) getReminderTimestamp;

- (void) saveIgnoredVersion:(NSNumber *) ignoredVersion;
- (void) saveReminderIntervalInMinutes: (NSNumber *) reminderIntervalInMinutes;
- (void) saveReminderTimestamp: (NSNumber *) reminderTimestamp;

@end
