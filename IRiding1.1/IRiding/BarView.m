//
//  BarView.m
//  IRiding
//
//  Created by qianfeng01 on 15/6/26.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "BarView.h"
@implementation BarView
{
    BarBlock _myBlock;
    NSString *_likeUrl;
    NSInteger _likeState;
    NSInteger _trackId;
    NSString *_favoriteUrl;
    NSInteger _favoriteState;
    AFHTTPRequestOperationManager *_manager;
}
#pragma mark - 视图初始化
- (void)awakeFromNib{
    //self.backgroundColor = [UIColor redColor];
    [self setBackgroundColor:[UIColor colorWithRed:0.95 green:0.5 blue:0.2 alpha:0.3]];
}
#pragma mark - 填充cell
- (void)showDataWithModel:(DetailModel *)model{
    self.model = model;
    [self setViewFrame];
    [self.likeButton setTintColor:[UIColor clearColor]];
    [self.likeButton setImage:[[UIImage imageNamed: @"detail_like"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.likeButton setImage:[[UIImage imageNamed: @"detail_like_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    self.likeLabel.text = model.like_count.stringValue;
    //判断有没有赞过
    NSString *key = [NSString stringWithFormat:@"%ld",model.id.integerValue];
    BOOL isLike = [[NSUserDefaults standardUserDefaults]boolForKey:key];
    if (isLike) {
        self.likeButton.selected = YES;
    }else{
        self.likeButton.selected = NO;
    }
    
    [self.favoriteButton setTintColor:[UIColor clearColor]];
    [self.favoriteButton setImage:[[UIImage imageNamed: @"detail_favorite"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[[UIImage imageNamed: @"detail_favorite_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    //判断有没有收藏过
    NSString *key2 = [NSString stringWithFormat:@"favorite%ld",model.id.integerValue];
    BOOL isFavorite = [[NSUserDefaults standardUserDefaults]boolForKey:key2];
    if (isFavorite) {
        self.favoriteButton.selected = YES;
    }else{
        self.favoriteButton.selected = NO;
    }
    
    [self.commentButton setTintColor:[UIColor clearColor]];
    [self.commentButton setImage:[[UIImage imageNamed: @"detail_comment"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.commentButton setImage:[[UIImage imageNamed: @"detail_comment_highlighted"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    self.commentLabel.text = model.comment_count.stringValue;
    //    [self setViewFrame];
}
#pragma mark - 封装 设置cell上各个子视图的frame
- (void)setViewFrame{
    CGFloat space = (kScreenSize.width - 20 - 70*2-30-2*2)/2;
    CGRect buttonFrame1 = self.likeButton.frame;
    buttonFrame1.origin.x = 20;
    self.likeButton.frame = buttonFrame1;
    
    CGRect labelFrame1 = self.likeLabel.frame;
    labelFrame1.origin.x = self.likeButton.frame.origin.x+30+2;
    self.likeLabel.frame = labelFrame1;
    
    CGRect buttonFrame2 = self.favoriteButton.frame;
    buttonFrame2.origin.x = self.likeLabel.frame.origin.x+40+space;
    self.favoriteButton.frame = buttonFrame2;
    
    CGRect buttonFrame3 = self.commentButton.frame;
    buttonFrame3.origin.x = self.favoriteButton.frame.origin.x+30+space;
    self.commentButton.frame = buttonFrame3;
    
    CGRect labelFrame3 = self.commentLabel.frame;
    labelFrame3.origin.x = self.commentButton.frame.origin.x+30+2;
    self.commentLabel.frame = labelFrame3;
    
    CGRect buttonFrame4 = self.favoriteButton.frame;
    buttonFrame4.origin.x = self.likeLabel.frame.origin.x+40+space-10;
    self.favoriteButton.frame = buttonFrame4;
}
#pragma mark - 私有变量block的setter方法
- (void)setMyBlock:(BarBlock)block{
    if (_myBlock != block) {
        _myBlock = nil;
        _myBlock = block;
    }
}
#pragma mark - 私有变量block的getter方法
- (BarBlock)myBlock{
    return _myBlock;
}

#pragma mark - 按扭触发
- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 101:
        {
            NSDictionary *userDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"dict"];
            if ([userDict[@"token"]length]) {
                _likeUrl = [kLikeUrl stringByAppendingString:userDict[@"token"]];
                _trackId = self.model.id.integerValue;
                
                NSString *key = [NSString stringWithFormat:@"%ld",(long)self.model.id.integerValue];
                BOOL isLike = [[NSUserDefaults standardUserDefaults]boolForKey:key];
                if (isLike) {
                    self.likeButton.selected = NO;
                    _likeState = 2;
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:key];
                    //同步到磁盘
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    self.model.like_count = @(self.model.like_count.integerValue-1);
                    self.likeLabel.text = [NSString stringWithFormat:@"%ld",self.model.like_count.integerValue];
                }else{
                    self.likeButton.selected = YES;
                    _likeState = 1;
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
                    //同步到磁盘
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    self.model.like_count = @(self.model.like_count.integerValue+1);
                    self.likeLabel.text = [NSString stringWithFormat:@"%ld",self.model.like_count.integerValue];
                }
                [self addLikeTask];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"请先登录账号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }
            break;
        case 102:
        {
            NSDictionary *userDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"dict"];
            if ([userDict[@"token"]length]) {
                _favoriteUrl = [kFavoriteUrl stringByAppendingString:userDict[@"token"]];
                _trackId = self.model.id.integerValue;
                
                NSString *key = [NSString stringWithFormat:@"favorite%ld",self.model.id.integerValue];
                BOOL isFavorite = [[NSUserDefaults standardUserDefaults]boolForKey:key];
                if (isFavorite) {
                    self.favoriteButton.selected = NO;
                    _favoriteState = 0;
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:key];
                    //同步到磁盘
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }else{
                    self.favoriteButton.selected = YES;
                    _favoriteState = 1;
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
                    //同步到磁盘
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                [self addFavoriteTask];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"请先登录账号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }
            break;
        case 103:
        {
            NSDictionary *userDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"dict"];
            if ([userDict[@"token"]length]) {
                if (self.myBlock) {
                    self.myBlock(self.model);
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"请先登录账号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - 增加任务 点赞,取消赞
- (void)addLikeTask{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"new_state":@(1),@"track_id":@(6094)}];
    [dict setObject:[NSNumber numberWithInteger:_trackId] forKey:@"track_id"];
    [dict setObject:[NSNumber numberWithInteger:_likeState] forKey:@"new_state"];
    [_manager POST:_likeUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"点赞下载成功");
        if (responseObject) {
            //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"点赞失败");
    }];
}
#pragma mark - 增加任务 收藏，取消收藏
- (void)addFavoriteTask{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"new_state":@(1),@"track_id":@(6094)}];
    [dict setObject:[NSNumber numberWithInteger:_trackId] forKey:@"track_id"];
    [dict setObject:[NSNumber numberWithInteger:_favoriteState] forKey:@"new_state"];
    [_manager POST:_favoriteUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"收藏下载成功");
        if (responseObject) {
            //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"收藏失败");
    }];
}
@end
