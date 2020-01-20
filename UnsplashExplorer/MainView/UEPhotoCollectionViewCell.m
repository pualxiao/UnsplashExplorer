//
//  UEPhotoCollectionViewCell.m
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/20.
//  Copyright © 2020 习波 肖. All rights reserved.
//

#import "UEPhotoCollectionViewCell.h"

@implementation UEPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = RandColor;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        [self initView];
    }
    return self;
}


- (void)initView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor clearColor];
    self.photo = imageView;
    [self.contentView addSubview:self.photo];
    [self.photo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.size.mas_equalTo(self.contentView);
    }];
}
@end
