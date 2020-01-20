//
//  UEFullPhotoView.m
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/20.
//  Copyright © 2020 习波 肖. All rights reserved.
//


@class UEPhotoData;
@class UEFullPhotoView;

@protocol UEFullPhotoViewDelegate <NSObject>
/* 单击 后的操作 */
- (void)fullPhotoViewSingleTap:(UEFullPhotoView*)view;
/* 改变主视图 的 透明度 */
- (void)fullPhotoView:(UEFullPhotoView*)view touchMoveChangeMainViewAlpha:(CGFloat)alpha;

@end

@interface UEFullPhotoView : UIView

@property (nonatomic,weak) id<UEFullPhotoViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame photoData:(UEPhotoData *)photoData;

@end
