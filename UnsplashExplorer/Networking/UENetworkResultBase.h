//
//  UENetworkResultBase.h
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/18.
//  Copyright © 2020 习波 肖. All rights reserved.
//

typedef enum : NSUInteger {
    NETWORK_SUCCESS = 0,
    NETWORK_DECODE_ERROR = 1000,
} NETWORK_ERROR_CODE;

@interface UENetworkResultBase : NSObject

@property (nonatomic, assign) NETWORK_ERROR_CODE code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) JSONModel *data;

- (BOOL)isSuccess;

@end
