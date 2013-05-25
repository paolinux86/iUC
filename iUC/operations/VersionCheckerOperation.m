//
//  VersionCheckerOperation.m
//  iUC
//
//  Created by Paolo Cortis on 25/05/13.
//  Copyright (c) 2013 Paolo Cortis. All rights reserved.
//

#import "VersionCheckerOperation.h"

@implementation VersionCheckerOperation

@synthesize updateURL;

- (id) init
{
	if(self = [super init]) {
	}
	
	return self;
}

- (void) main
{
	NSData *result = [self httpGet:updateURL];

	if(result == nil) {
		NSLog(@"ERROR: Notifying error");
		[[NSNotificationCenter defaultCenter] postNotificationName:CHECKVERSION_NOTIFICATION_NAME_FAILED object:nil];

		return;
	}

	NSLog(@"INFO: Notifying complete");
	[[NSNotificationCenter defaultCenter] postNotificationName:CHECKVERSION_NOTIFICATION_NAME_COMPLETED object:result];
}

- (NSData *) httpGet:(NSURL *) url
{
	NSURLRequest *request = [NSURLRequest requestWithURL:url
											 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
										 timeoutInterval:TIMEOUT_CONNECTION];

	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

	if(error != nil) {
		NSLog(@"ERROR: error while downloading from url: %@. Error was: %@", [updateURL absoluteString], [error localizedDescription]);
	}
	
	return data;
}

@end
