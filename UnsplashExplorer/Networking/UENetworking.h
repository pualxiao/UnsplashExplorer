//
//  UENetworking.h
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/18.
//  Copyright © 2020 习波 肖. All rights reserved.
//

@class UEGetPhotosParam;
@class UENetworkResultBase;

typedef void (^NetworkCallback)(NSError * _Nullable error, UENetworkResultBase * _Nonnull model);

@interface UENetworking : NSObject

NS_ASSUME_NONNULL_BEGIN

+ (void)getPhotosWithParam:(UEGetPhotosParam*)param  callback:(NetworkCallback)callback;

NS_ASSUME_NONNULL_END

@end
