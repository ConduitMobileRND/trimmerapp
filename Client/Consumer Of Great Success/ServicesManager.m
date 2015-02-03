//
//  ServicesManager.m
//  Consumer Of Great Success
//
//  Created by Yossi Halevi on 1/29/15.
//  Copyright (c) 2015 Yossi Halevi. All rights reserved.
//

#import "ServicesManager.h"
#import "AFNetworking.h"

#define TIMEOUT_INTERVAL 4.0
#define API_URL @"https://safe-basin-8277.herokuapp.com/v1"

@implementation ServicesManager


void(^serviceCompletionBlock)(BOOL success, NSString* inAppPromotionName, NSString *errorString);


+(void)serverApiWithHttpMethod:(httpMethods)method andUrlPath:(NSString *)urlPath andParameters:(NSDictionary *)parameters completion:(ServiceCompletionBlock)completion
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
    spinner.center = mainWindow.center;
    spinner.color = [UIColor greenColor];
    [mainWindow addSubview: spinner];
    [spinner startAnimating];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",API_URL,urlPath];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIMEOUT_INTERVAL];

    if(parameters){
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        request.HTTPBody = jsonData;
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    [request setHTTPMethod:[ServicesManager convertToString:method]];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
     
        [spinner stopAnimating];
        completion(YES,(NSDictionary *)responseObject,nil);
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        [spinner stopAnimating];
        NSLog(@"Server error: %@", error.localizedDescription);
        if(completion) {
            completion(NO,nil,error.localizedDescription);
        }
    }];
    [operation start];
}

+(NSString*) convertToString:(httpMethods) method {
    NSString *result = nil;
    switch(method) {
        case getMethod:
            result = @"GET";
            break;
        case postMethod:
            result = @"POST";
            break;
        case putMethod:
            result = @"PUT";
            break;
        default:
            result = @"GET";
    }
    return result;
}


@end
