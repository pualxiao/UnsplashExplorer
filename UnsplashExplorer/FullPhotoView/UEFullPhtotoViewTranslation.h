//
//  UEFullPhtotoViewTranslation.m
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/20.
//  Copyright © 2020 习波 肖. All rights reserved.
//


@class UEFullPhotoView;

@interface UEFullPhtotoViewTranslation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isBrowserMainView;
@property (nonatomic, strong) UEFullPhotoView * photoView;
@property (nonatomic, strong) UIView * browserControllerView;

@end
