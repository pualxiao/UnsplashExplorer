//
//  UENetworking.m
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/18.
//  Copyright © 2020 习波 肖. All rights reserved.
//

#import "UENetworking.h"
#import "UENetworkConfig.h"
#import "UENetworkManager.h"
#import "JSONModel+GETParam.h"
#import "UEPhotosModel.h"
#import "UEGetPhotosParam.h"

@interface RequestParam : NSObject

@property SEL callback;
@property (nonatomic, strong) NSObject *callbackObj;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) id otherParam;

@end

typedef void (^AFNetworkSuccessCallback)(NSURLSessionDataTask * _Nonnull, id _Nullable);
typedef void (^AFNetworkFailCallback)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull);


typedef enum : NSUInteger {
    HTTP_METHOD_GET,
    HTTP_METHOD_POST,
    HTTP_METHOD_PUT,
    HTTP_METHOD_DELETE,
} HTTP_METHOD;

@implementation UENetworking

+ (void)getPhotosWithParam:(UEGetPhotosParam*)param  callback:(NetworkCallback)callback
{
    [self doSendData:param url:PHOTOS_URL method:HTTP_METHOD_GET resultClass:[UEPhotosModel class] callback:callback];
}

+ (void)doSendData:(JSONModel *)params url:(NSString*)url method:(HTTP_METHOD)method resultClass:(Class)resultClass callback:(NetworkCallback)callback
{
    AFNetworkSuccessCallback successCallback = ^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        
        UENetworkResultBase *result = [[resultClass alloc] init];
        
        NSError *error = [NSError new];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            result.data = [[result.data.class alloc] initWithDictionary:responseObject error:&error];
            if (!error.code) {
                result.code = NETWORK_SUCCESS;
            }
            else {
                result.code = NETWORK_DECODE_ERROR;
                result.message = @"decode error";
            }
        }
        else if ([responseObject isKindOfClass:[NSArray class]]) {
            result.data = [[result.data.class alloc] initWithDictionary:@{@"data":responseObject} error:&error];
            if (!error.code) {
                result.code = NETWORK_SUCCESS;
            }
            else {
                result.code = NETWORK_DECODE_ERROR;
                result.message = @"decode error";
            }
        }
        else {
            result.code = NETWORK_DECODE_ERROR;
            result.message = @"unknown json string";
        }
        
        if (callback) {
            callback(nil, result);
        }
    };
    
    AFNetworkFailCallback failCallback = ^(NSURLSessionDataTask *task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;

        UENetworkResultBase *result = [[resultClass alloc] init];
        result.code = response.statusCode;
        result.message = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        
        if (callback) {
            callback(error, result);
        }
        //[self errorParse:error];
    };
    
    UENetworkManager *manager = [UENetworkManager shareManager];
    
    switch (method) {
        case HTTP_METHOD_GET:
        {
            if (params) {
                NSString *paramStr = [params toGETParamString];
                [manager GET:url parameters:paramStr progress:nil success:successCallback failure:failCallback];
            }
            else {
                [manager GET:url parameters:@"" progress:nil success:successCallback failure:failCallback];
            }
        }
            break;
            
        case HTTP_METHOD_POST:
        {
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [manager POST:url parameters:[params toJSONString] progress:nil success:successCallback failure:failCallback];
        }
            break;
            
        default:
            [manager GET:url parameters:[params toJSONString] progress:nil success:successCallback failure:failCallback];
            break;
    }
}

@end
