//
//  UEFullPhotoView.m
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/20.
//  Copyright © 2020 习波 肖. All rights reserved.
//


#import "UEFullPhotoView.h"
#import "UEPhotosModel.h"

@interface UEFullPhotoView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UEPhotoData * photoData;
@property (nonatomic,strong) UIScrollView * subScrollView;
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,assign) NSInteger touchFingerNumber;

@end

@implementation UEFullPhotoView

- (id)initWithFrame:(CGRect)frame photoData:(UEPhotoData *)photoData {
    self = [super initWithFrame:frame];
    if (self) {
        self.photoData = photoData;
        [self initView];
    }
    return self;
}
- (void)initView {
    [self addSubview:self.subScrollView];
    [self.subScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.subScrollView addSubview:self.imageView];
    //加入 点击事件 单击 与 双击
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [self addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:doubleTap];
    
    __weak typeof (self) ws = self;
    SDExternalCompletionBlock completionBlock = ^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error) {
            [ws updateSubScrollViewimageView];
        }
    };
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_photoData.urls.full]
                      placeholderImage:nil
                             completed:completionBlock
                     usingProgressView:nil];
    [self updateSubScrollViewimageView];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longGes {
    if (longGes.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择对象" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) ws = self;
    UIAlertAction *actionSave = [UIAlertAction actionWithTitle:@"保持" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [ws savePhoto];
    }];
    UIAlertAction *actionShare = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ws sharePhoto];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    //把action添加到actionSheet里
    [actionSheet addAction:actionSave];
    [actionSheet addAction:actionShare];
    [actionSheet addAction:actionCancel];
    
    //相当于之前的[actionSheet show];
    [self.parentController presentViewController:actionSheet animated:YES completion:nil];
}

//单击 退出
- (void)singleTapAction:(UITapGestureRecognizer *)singleTap {
    if ([self.delegate respondsToSelector:@selector(fullPhotoViewSingleTap:)]) {
        [self.delegate fullPhotoViewSingleTap:self];
    }
}

//双击 局部放大 或者 变成正常大小
- (void)doubleTapAction:(UITapGestureRecognizer *)doubleTap {
    if (self.subScrollView.zoomScale > 1.0) {
        //已经放大过了 就变成正常大小
        [self.subScrollView setZoomScale:1.0 animated:YES];
    } else {
        //如果是正常大小 就 局部放大
        CGPoint touchPoint = [doubleTap locationInView:self.imageView];
        CGFloat maxZoomScale = self.subScrollView.maximumZoomScale;
        CGFloat width = self.frame.size.width / maxZoomScale;
        CGFloat height = self.frame.size.height / maxZoomScale;
        [self.subScrollView zoomToRect:CGRectMake(touchPoint.x - width/2, touchPoint.y = height/2, width, height) animated:YES];
    }
}

- (void)updateSubScrollViewimageView {
    [self.subScrollView setZoomScale:1.0 animated:NO];
    
    CGFloat imageW = _photoData.width.floatValue;
    CGFloat imageH = _photoData.height.floatValue;
    CGFloat height =  SCREEN_WIDTH * imageH/imageW;

    if (imageH/imageW > SCREEN_HEIGHT/SCREEN_WIDTH) {
        //长图
        self.imageView.frame =CGRectMake(0, 0, SCREEN_WIDTH, height);
    } else {
        self.imageView.frame =CGRectMake(0, SCREEN_HEIGHT/2 - height/2, SCREEN_WIDTH, height);
    }
    self.subScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height);
}


- (void)sharePhoto {
    NSString * shareText = @"分享";
    UIImage * shareImage = _imageView.image;
    NSArray * activityItems = [[NSArray alloc] initWithObjects:shareText, shareImage, nil];
    
    UIActivityViewControllerCompletionWithItemsHandler resultHandle = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
            NSLog(@"%@",activityType);
            if (completed) {
                NSLog(@"分享成功");
            } else {
                NSLog(@"分享失败");
            }
        };
    [UEUtil shareActivityItems:activityItems inController:self.parentController completionHandler:resultHandle];
}

- (void)savePhoto {
    NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
    
    if ([imageData isKindOfClass:[NSNull class]] || imageData == nil) {
        [UIView showToast:@"网络异常，请稍后再试"];
    } else {
        [self saveStillImage:self.imageView.image];
    }
}

- (void)saveStillImage:(UIImage *)image {
    [self checkAndSaveMediaWithCompletion:^(BOOL hasAccess){
        if (hasAccess) {
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:didFinishSavingWithError:contextInfo:),
                                           nil);
        } else {
            NSError *error = [NSError errorWithDomain:ALAssetsLibraryErrorDomain code:ALAssetsLibraryDataUnavailableError userInfo:nil];
            [self image:image didFinishSavingWithError:error contextInfo:nil];
        }
        
    }];
}

- (void)checkAndSaveMediaWithCompletion:(void (^)(BOOL hasAccess))completion {
    PHAuthorizationStatus curStatus = [PHPhotoLibrary authorizationStatus];
    if (PHAuthorizationStatusDenied == curStatus || PHAuthorizationStatusRestricted == curStatus) {
        BOOL canOpen = [self canOpenSystemSettings];
        NSString *title = canOpen ? @"保存图片需要相册权限" : @"需要相册权限";
        NSString *message = canOpen ? @"" : @"保持图片需要相册权限，请前往\n[设置]→[隐私]→[照片]\n开启权限";
        NSString *firstTitle = canOpen ? @"取消" : @"";
        NSString *secondTitle = canOpen ? @"开启" : @"知道了";
        
        [[UEAlertController alertControllerWithTitle:title message:message
                                           firstTitle:firstTitle secondTitle:secondTitle
                                          firstAction:nil
                                         secondAction:^(UIAlertAction *action) {
                                             if (canOpen) {
                                                 [ self openSystemSettings];
                                             }
                                         }] show];
    } else if (PHAuthorizationStatusNotDetermined == curStatus) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus _status) {
            if (_status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(YES);
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(NO);
                    }
                });
            }
        }];
    } else {
        if (completion) {
            completion(YES);
        }
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *toastString = nil;
    if (error) {
        toastString = @"保存失败";
    } else {
        toastString = @"保存成功";
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView showToast:toastString];
    });
}

- (BOOL)canOpenSystemSettings {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
- (BOOL)openSystemSettings {
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0) {
        [self openIOS11SystemSettings];
        return YES;
    }
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)openIOS11SystemSettings {
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    } else {
        [application openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark -scrollView delegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    UIPanGestureRecognizer * subScrollViewPan = [scrollView panGestureRecognizer];
    _touchFingerNumber = subScrollViewPan.numberOfTouches;
    _subScrollView.clipsToBounds = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    //只有是一根手指事件才做出响应。
    if (contentOffsetY < 0 && _touchFingerNumber == 1) {
        [self changeSizeCenterY:contentOffsetY];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if ((contentOffsetY<0 && _touchFingerNumber==1) && (velocity.y<0 && fabs(velocity.y)>fabs(velocity.x))) {
        //如果是向下滑动才触发消失的操作。
        if ([self.delegate respondsToSelector:@selector(fullPhotoViewSingleTap:)]) {
            [self.delegate fullPhotoViewSingleTap:self];
        }
    } else {
        [self changeSizeCenterY:0.0];
        CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
        CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
        self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    }
    _touchFingerNumber = 0;
    self.subScrollView.clipsToBounds = YES;
}

- (void)changeSizeCenterY:(CGFloat)contentOffsetY {
    //contentOffsetY 为负值
    CGFloat multiple = (SCREEN_HEIGHT + contentOffsetY*1.75)/SCREEN_HEIGHT;
    if ([self.delegate respondsToSelector:@selector(fullPhotoView:touchMoveChangeMainViewAlpha:)]) {
        [self.delegate fullPhotoView:self touchMoveChangeMainViewAlpha:multiple];
    }
    multiple = multiple>0.4?multiple:0.4;
    self.subScrollView.transform = CGAffineTransformMakeScale(multiple, multiple);
    self.subScrollView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - contentOffsetY*0.5);
}

#pragma mark -lazy
- (UIScrollView *)subScrollView {
    if (_subScrollView == nil) {
        _subScrollView = [[UIScrollView alloc] init];
        _subScrollView.delegate = self;
        _subScrollView.bouncesZoom = YES;
        _subScrollView.maximumZoomScale = 2.5;//最大放大倍数
        _subScrollView.minimumZoomScale = 1.0;//最小缩小倍数
        _subScrollView.multipleTouchEnabled = YES;
        _subScrollView.scrollsToTop = NO;
        _subScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        _subScrollView.userInteractionEnabled = YES;
        _subScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _subScrollView.delaysContentTouches = NO;//默认yes  设置NO则无论手指移动的多么快，始终都会将触摸事件传递给内部控件；
        _subScrollView.canCancelContentTouches = NO; // 默认是yes
        _subScrollView.alwaysBounceVertical = YES;//设置上下回弹
        _subScrollView.showsVerticalScrollIndicator = NO;
        _subScrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            //表示只在ios11以上的版本执行
            _subScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _subScrollView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end
