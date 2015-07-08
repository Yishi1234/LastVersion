//
//  ShareButtonView.h
//  IRiding
//
//  Created by qianfeng01 on 15/7/5.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareButtonView : UIView
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
- (IBAction)btnClick:(UIButton *)sender;

@end
