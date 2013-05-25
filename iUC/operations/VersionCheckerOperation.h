//
//  VersionCheckerOperation.h
//  iUC
//
//  Created by Paolo Cortis on 25/05/13.
//  Copyright (c) 2013 Paolo Cortis. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CHECKVERSION_NOTIFICATION_NAME_COMPLETED @"iUC_checkVersionCompleted"
#define CHECKVERSION_NOTIFICATION_NAME_FAILED @"iUC_checkVersionFailed"

#define TIMEOUT_CONNECTION 60.0

@interface VersionCheckerOperation : NSOperation
{
	NSURL *updateURL;
}

@property (strong, nonatomic) NSURL *updateURL;

@end
