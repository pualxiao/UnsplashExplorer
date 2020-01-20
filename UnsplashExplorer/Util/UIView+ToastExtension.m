//
//  UIView+ToastExtension.m
//  Exchange
//
//  Created by X on 16/9/6.
//  Copyright © 2017年 Via. All rights reserved.
//

#import "UIView+ToastExtension.h"


@implementation UIView (ToastExtension)

+ (void)showToast:(NSString *)message
{
    return [self showToast:message duration:10 position:CSToastPositionCenter];
}

+ (void)showToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position {
    if (message.length == 0) {
        return;
    }
    [[UIApplication sharedApplication].keyWindow makeToast:message duration:duration position:position];
}

@end
