//
//  UEProgressView.m
//  UnsplashExplorer
//
//  Created by 习波 肖 on 2020/1/20.
//  Copyright © 2020 习波 肖. All rights reserved.
//


#import "UEProgressView.h"

@interface UEProgressView ()

@property (nonatomic, strong) UILabel* progressLabel;

@end

@implementation UEProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _progressLabel.textColor = [UIColor grayColor];
        [self addSubview:_progressLabel];
        [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(20);
        }];
    }
    return _progressLabel;
}

- (void)setProgressValue:(CGFloat)progressValue
{
    _progressValue = progressValue;
    
    // 设置label的文字
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", fabs(progressValue) * 100];
    
    // 重绘
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center
                                                        radius:self.frame.size.width < self.frame.size.height ? self.frame.size.width * 0.3 : self.frame.size.height * 0.3
                                                    startAngle:-M_PI_2 endAngle:2 * M_PI * self.progressValue - M_PI_2
                                                     clockwise:1];
    
    [path setLineWidth:5];
    [[UIColor orangeColor] setStroke];
    [path stroke];
}

@end
