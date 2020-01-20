//
//  UEPhotosModel.m
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/18.
//  Copyright © 2020 习波 肖. All rights reserved.
//

#import "UEPhotosModel.h"

@implementation UEUrlsData

@end

@implementation UEPhotoData

@end

@implementation UEPhotosData

@end

@implementation UEPhotosModel

@synthesize data = _data;

- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [[UEPhotosData alloc] init];
    }
    return self;
}

@end
