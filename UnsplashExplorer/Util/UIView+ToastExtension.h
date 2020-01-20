//
//  UIView+ToastExtension.h
//  Exchange
//
//  Created by X on 16/9/6.
//  Copyright © 2017年 Via. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ToastExtension)
+ (void)showToast:(NSString *)message;

+ (void)showToast:(NSString *)message
         duration:(NSTimeInterval)duration
         position:(id)position;

@end
