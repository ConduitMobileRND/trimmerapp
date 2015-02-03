//
//  ExtendNSLogFunctionality.h
//  CockpitSDK
//
//  Created by Yossi Halevi Dev on 31/12/14.
//  Copyright (c) 2014 Planet Of The Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSLog(args...) ExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);


void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...);



@interface ExtendNSLogFunctionality : NSObject

@end
