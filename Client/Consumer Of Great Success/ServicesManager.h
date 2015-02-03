//
//  ServicesManager.h
//  Consumer Of Great Success
//
//  Created by Yossi Halevi on 1/29/15.
//  Copyright (c) 2015 Yossi Halevi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    getMethod,
    postMethod,
    putMethod,
} httpMethods;

@interface ServicesManager : NSObject

typedef void (^ServiceCompletionBlock)(BOOL success, NSDictionary* data, NSString *errorString);

+(void)serverApiWithHttpMethod:(httpMethods)method andUrlPath:(NSString *)urlPath andParameters:(NSDictionary *)parameters completion:(ServiceCompletionBlock)completion;

@end
