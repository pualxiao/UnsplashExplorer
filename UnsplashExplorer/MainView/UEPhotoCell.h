//
//  UEPhotoCell.h
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/18.
//  Copyright © 2020 习波 肖. All rights reserved.
//


#import <UIKit/UIKit.h>

static NSString *UEPhotoCellIdentifier = @"UEPhotoCell";

@interface UEPhotoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photo;

@end
