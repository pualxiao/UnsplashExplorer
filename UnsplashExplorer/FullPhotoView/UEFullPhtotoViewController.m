//
//  UEFullPhtotoViewController.m
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/20.
//  Copyright © 2020 习波 肖. All rights reserved.
//


#import "UEFullPhtotoViewController.h"
#import "UEFullPhotoView.h"
#import "UEFullPhtotoViewTranslation.h"

@interface UEFullPhtotoViewController ()<UIViewControllerTransitioningDelegate, UEFullPhotoViewDelegate>

@property (nonatomic, strong) UEPhotoData * photoData;
@property (nonatomic, strong) UEFullPhotoView * photoView;
@property (nonatomic, strong) UEFullPhtotoViewTranslation *browserTranslation;
@property (nonatomic, strong) UIViewController * controller;

@end

@implementation UEFullPhtotoViewController

- (id)initWithPhotoData:(UEPhotoData*)photoData {
    if (self = [super init]) {
        self.photoData = photoData;
        self.transitioningDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark --UEFullPhotoViewDelegate
- (void)fullPhotoViewSingleTap:(UEFullPhotoView*)view {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)fullPhotoView:(UEFullPhotoView*)view touchMoveChangeMainViewAlpha:(CGFloat)alpha {
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
}

#pragma mark --UIViewControllerTransitioningDelegate
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
//    self.browserTranslation.isBrowserMainView = YES;
//    return self.browserTranslation;
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
//    self.browserTranslation.isBrowserMainView = NO;
//    return self.browserTranslation;
//}

#pragma mark -lazy
- (UEFullPhotoView*)photoView {
    if (_photoView == nil) {
        _photoView = [[UEFullPhotoView alloc] initWithFrame:self.view.bounds photoData:_photoData];
        _photoView.delegate = self;
    }
    return _photoView;
}

- (UEFullPhtotoViewTranslation *)browserTranslation {
    if (_browserTranslation == nil) {
        _browserTranslation = [[UEFullPhtotoViewTranslation alloc] init];
        _browserTranslation.photoView = self.photoView;
        _browserTranslation.browserControllerView = self.view;
    }
    return _browserTranslation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
