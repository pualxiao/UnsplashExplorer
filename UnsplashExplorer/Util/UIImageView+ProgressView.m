//
//  UIImageView+ProgressView.h
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/20.
//  Copyright © 2020 习波 肖. All rights reserved.
//

#import "UIImageView+ProgressView.h"


#define TAG_PROGRESS_VIEW 149462

@implementation UIImageView (ProgressView)

- (void)addProgressView:(UEProgressView *)progressView {
    UEProgressView *existingProgressView = (UEProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (!existingProgressView) {
        if (!progressView) {
            progressView = [[UEProgressView alloc] initWithFrame:self.frame];
        }

        progressView.tag = TAG_PROGRESS_VIEW;
        progressView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;

        float width = progressView.frame.size.width;
        float height = progressView.frame.size.height;
        float x = (self.frame.size.width / 2.0) - width/2;
        float y = (self.frame.size.height / 2.0) - height/2;
        progressView.frame = CGRectMake(x, y, width, height);

        [self addSubview:progressView];
        [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.equalTo(self).multipliedBy(0.5);
        }];
    }
}

- (void)updateProgress:(CGFloat)progress {
    UEProgressView *progressView = (UEProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (progressView) {
        progressView.progressValue = progress;
    }
}

- (void)removeProgressView {
    UEProgressView *progressView = (UEProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (progressView) {
        [progressView removeFromSuperview];
    }
}

- (void)sd_setImageWithURL:(NSURL *)url usingProgressView:(UEProgressView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil usingProgressView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder usingProgressView:(UEProgressView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil usingProgressView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options usingProgressView:(UEProgressView *)progressView{
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil usingProgressView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url completed:(SDExternalCompletionBlock)completedBlock usingProgressView:(UEProgressView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock usingProgressView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDExternalCompletionBlock)completedBlock usingProgressView:(UEProgressView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock usingProgressView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDExternalCompletionBlock)completedBlock usingProgressView:(UEProgressView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock usingProgressView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completedBlock usingProgressView:(UEProgressView *)progressView {
    [self addProgressView:progressView];
    
    __weak typeof(self) weakSelf = self;

    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
        CGFloat progress = ((CGFloat)receivedSize / (CGFloat)expectedSize);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateProgress:progress];
        });
        
        if (progressBlock) {
            progressBlock(receivedSize, expectedSize, url);
        }
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        [weakSelf removeProgressView];
        if (completedBlock) {
            completedBlock(image, error, cacheType, imageURL);
        }
        
    }];
    
}

@end
