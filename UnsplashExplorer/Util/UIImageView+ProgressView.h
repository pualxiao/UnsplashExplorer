//
//  UIImageView+ProgressView.h
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/20.
//  Copyright © 2020 习波 肖. All rights reserved.
//

#import "UEProgressView.h"

@interface UIImageView (ProgressView)

- (void)sd_setImageWithURL:(NSURL *)url usingProgressView:(UEProgressView *)progressView;

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder usingProgressView:(UEProgressView *)progressView;

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options usingProgressView:(UEProgressView *)progressView;

- (void)sd_setImageWithURL:(NSURL *)url completed:(SDExternalCompletionBlock)completedBlock usingProgressView:(UEProgressView *)progressView;

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDExternalCompletionBlock)completedBlock usingProgressView:(UEProgressView *)progressView;

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDExternalCompletionBlock)completedBlock usingProgressView:(UEProgressView *)progressView;

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completedBlock usingProgressView:(UEProgressView *)progressView;

- (void)removeProgressView;

@end
