//
//  UEUtil.h
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/18.
//  Copyright © 2020 习波 肖. All rights reserved.
//

typedef void(^CompletioBlock)(Boolean);

@interface UEUtil : NSObject

+ (void)shareActivityItems:(NSArray*)activityItems inController:(UIViewController*)controller completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)handler;

@end
