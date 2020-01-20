//
//  UENetworkResultBase.m
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/18.
//  Copyright © 2020 习波 肖. All rights reserved.
//

#import "UENetworkResultBase.h"

@implementation UENetworkResultBase

- (BOOL)isSuccess
{
    return _code == NETWORK_SUCCESS;
}

@end
