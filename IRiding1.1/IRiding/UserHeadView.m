//
//  UserHeadView.m
//  IRiding
//
//  Created by qianfeng01 on 15/6/19.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "UserHeadView.h"
#import "LZXHelper.h"
#import "LikeCollectionViewController.h"
#import "LogCell.h"
@implementation UserHeadView
{
    LikeBlock _myBlock;
}
- (void)awakeFromNib{
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 30;
}
#pragma mark - 填充cell
- (void)showDataWithModel:(DetailModel *)model{
    self.model = model;
    if (model.gender.integerValue == 1) {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed: @"set_gender_selected_boy"]];
    }else{
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed: @"set_gender_selected_girl"]];
    }
    self.nameLabel.text = model.username;
    self.cityLabel.text = model.city;
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.1f公里",model.distance.integerValue/1000.0];
    self.timeLabel.text = [self dateStringFromNumberTime:model.duration.integerValue];
    self.titleLabel.text = model.title;
    
    //设置视图frame
    CGRect titleLabelFrame = self.titleLabel.frame;
    titleLabelFrame.size.width = kScreenSize.width-20;
    titleLabelFrame.size.height = [LZXHelper textHeightFromTextString:model.title width:titleLabelFrame.size.width fontSize:18];
    self.titleLabel.frame = titleLabelFrame;
    
    self.frame = CGRectMake(0, 0, kScreenSize.width, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+10);
    if (model.like.count) {
        [self creatLikeViewWithModel:model];
        self.frame = CGRectMake(0, 0, kScreenSize.width, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+106+10);
    }
}
#pragma mark - 封装头视图时间显示格式
- (NSString *)dateStringFromNumberTime:(NSInteger)time{
    if (time/60) {
        NSInteger m = time/60;
        if (m/60) {
            double h = m/60.0f;
            return [NSString stringWithFormat:@"%.01f小时",h];
        }else{
            return [NSString stringWithFormat:@"%.01ld分钟",m];
        }
    }else{
        return @"刚刚";
    }
    return nil;
}
#pragma mark - 对私有变量进行setter方法
- (void)setMyBlockWithBlock:(LikeBlock)block{
    if (_myBlock != block) {
        _myBlock = nil;
        _myBlock = block;
    }
}
#pragma mark - 对私有变量进行getter方法
- (LikeBlock)myBlock{
    return _myBlock;
}
#pragma mark - 封装 创建点赞的行视图
- (void)creatLikeViewWithModel:(DetailModel *)model{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+10, kScreenSize.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
    
    UILabel *likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineView.frame.origin.y+lineView.frame.size.height+10, kScreenSize.width-20, 25)];
    likeLabel.text = @"他们觉得棒棒哒";
    likeLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:likeLabel];
    
    NSArray *arr = model.like;
    for (NSInteger i = 0; i < arr.count; i++) {
        NSDictionary *dict = arr[i];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+(50+5)*i, likeLabel.frame.origin.y+likeLabel.frame.size.height+10, 50, 50)];
        if (kScreenSize.width-imageView.frame.origin.x-50>=50) {
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 25;
            if ([dict[@"gender"]integerValue] == 1) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"avatar_url"]] placeholderImage:[UIImage imageNamed:@"set_gender_selected_boy"]];
            }else{
                [imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"avatar_url"]] placeholderImage:[UIImage imageNamed:@"set_gender_selected_girl"]];
            }
            [self addSubview:imageView];
        }else{
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(kScreenSize.width-40-20, likeLabel.frame.origin.y+likeLabel.frame.size.height+15, 40, 40);
            [button setTitle:[NSString stringWithFormat:@"%ld",model.like_count.integerValue] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor lightGrayColor]];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 20;
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            break;
        }
    }
}
#pragma mark - 点赞列表按钮触发
- (void)btnClick:(UIButton *)button{
    if (_myBlock) {
        _myBlock(self.model);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
