//
//  ExtendNSLogFunctionality.m
//  CockpitSDK
//
//  Created by Yossi Halevi Dev on 31/12/14.
//  Copyright (c) 2014 Planet Of The Apps. All rights reserved.
//

#import "ExtendNSLogFunctionality.h"

@implementation ExtendNSLogFunctionality

void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...)
{
    if(1==2){
        return;
    }
    
    va_list ap;
    
    va_start (ap, format);

    if (![format hasSuffix: @"\n"])
    {
        format = [format stringByAppendingString: @"\n"];
    }
    
    NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
    
    // End using variable argument list.
    va_end (ap);
    
    NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
    fprintf(stderr, "(%s) (%s:%d) %s",
            functionName, [fileName UTF8String],
            lineNumber, [body UTF8String]);
}


@end
