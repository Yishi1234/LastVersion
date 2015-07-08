//
//  ShareButtonView.m
//  IRiding
//
//  Created by qianfeng01 on 15/7/5.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "ShareButtonView.h"

@implementation ShareButtonView
- (void)awakeFromNib{
    //self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.backgroundColor = [UIColor whiteColor];
}
- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 801://收起按钮界面
        {
            
        }
            break;
        case 802://发表
        {
            
        }
            break;
        case 803://取消返回
        {
            
        }
            break;
        case 804://开始 暂停
        {
            
        }
            break;
        case 805://拍照
        {
            
        }
            break;
        default:
            break;
    }
}
@end
