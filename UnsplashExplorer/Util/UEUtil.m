//
//  UEUtil.m
//  unsplashPhoto
//
//  Created by MrZhou on 2019/5/12.
//  Copyright © 2019 MrZhou. All rights reserved.
//

#import "UEUtil.h"

@implementation UEUtil

+ (void)shareActivityItems:(NSArray*)activityItems inController:(UIViewController*)controller completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)handler{
    
    UIActivityViewController * activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];

    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
            handler(activityType, completed, returnedItems, activityError);
            [activityVC dismissViewControllerAnimated:YES completion:nil];
        };
    
    activityVC.completionWithItemsHandler = myBlock;
    [controller presentViewController:activityVC animated:YES completion:nil];
}

@end
