//
//  UENetworkManager.m
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/18.
//  Copyright © 2020 习波 肖. All rights reserved.
//

#import "UENetworkManager.h"
#import "UENetworkConfig.h"

@implementation UENetworkManager

+ (instancetype)shareManager {
    static UENetworkManager* singleton;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] initWithBaseURL:[NSURL URLWithString:HTTP_HOST]];

        singleton.responseSerializer = [AFJSONResponseSerializer serializer];
        [singleton.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
            return (NSString*)parameters;
        }];
        singleton.requestSerializer.timeoutInterval = 10;
    });
    return  singleton;
}

@end
