//
//  iUC_private.h
//  iUC
//
//  Created by Paolo Cortis on 25/05/13.
//  Copyright (c) 2013 Paolo Cortis. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef iUC_iUC_private_h
#define iUC_iUC_private_h

@interface iUC()

- (void) receiveNotificationForCompleted: (NSNotification *)notification;
- (void) receiveNotificationForError: (NSNotification *)notification;

@end

#endif
