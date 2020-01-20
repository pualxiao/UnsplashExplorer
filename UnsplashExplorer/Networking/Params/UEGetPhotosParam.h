//
//  UEGetPhotosParam.h
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/18.
//  Copyright © 2020 习波 肖. All rights reserved.
//

#define PHOTOS_ORDER_BY_LATEST      @"latest"
#define PHOTOS_ORDER_BY_OLDEST      @"oldest"
#define PHOTOS_ORDER_BY_POPULAR     @"popular"

@interface UEGetPhotosParam : JSONModel

@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, strong) NSNumber *per_page;
@property (nonatomic, strong) NSString *order_by;
@property (nonatomic, strong) NSString *client_id;

@end
