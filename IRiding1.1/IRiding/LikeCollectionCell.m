//
//  LikeCollectionCell.m
//  IRiding
//
//  Created by qianfeng01 on 15/6/29.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "LikeCollectionCell.h"
#import "LZXHelper.h"

@implementation LikeCollectionCell
{
    UIImageView *_imageView;
    UILabel *_label;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //self.backgroundColor =[UIColor redColor];
        [self creatView];
    }
    return self;
}
#pragma mark - 创建cell上的视图
- (void)creatView{
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 30;
    [self.contentView addSubview:_imageView];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, 60,15)];
    _label.numberOfLines = 0;
    _label.font = [UIFont systemFontOfSize:12];
    _label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_label];
}
#pragma mark - 填充cell
- (void)showDataWithHeadImage:(NSString *)image name:(NSString *)name gender:(NSInteger)gender{
    if (gender == 1) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"set_gender_selected_boy"]];
    }else{
        [_imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"set_gender_selected_girl"]];
    }
    _label.text = name;
    CGRect frame = _label.frame;
    frame.origin.y = 65;
    frame.size.height = [LZXHelper textHeightFromTextString:name width:_label.frame.size.width fontSize:12];
    _label.frame = frame;
}
#pragma mark - 动态算行高
//+ (CGFloat)itemHeightWithName:(NSString *)name{
//    return 65+[LZXHelper textHeightFromTextString:name width:60 fontSize:12]+5;
//    //return 100;
//}









@end
