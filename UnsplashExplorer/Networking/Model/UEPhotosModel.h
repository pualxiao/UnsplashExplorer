//
//  UEPhotosModel.h
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/18.
//  Copyright © 2020 习波 肖. All rights reserved.
//

#import "UENetworkResultBase.h"

@interface UEUrlsData : JSONModel

@property (nonatomic, copy) NSString<Optional> *raw;
@property (nonatomic, copy) NSString<Optional> *full;
@property (nonatomic, copy) NSString<Optional> *small;

@end


@interface UEPhotoData : JSONModel

@property (nonatomic, strong) NSNumber<Optional> *width;
@property (nonatomic, strong) NSNumber<Optional> *height;
@property (nonatomic, strong) UEUrlsData<Optional> *urls;

@end

@protocol UEPhotoData
@end


@interface UEPhotosData : JSONModel

@property (nonatomic, strong) NSArray<UEPhotoData, Optional> *data;

@end


@interface UEPhotosModel : UENetworkResultBase

@property (nonatomic, strong) UEPhotosData *data;

@end
