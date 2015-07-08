//
//  LogCell.m
//  IRiding
//
//  Created by qianfeng01 on 15-6-11.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "LogCell.h"
#import "LZXHelper.h"
@implementation LogCell
{
    AFHTTPRequestOperationManager *_manager;
    NSInteger _state;
    NSInteger _trackId;
    NSString *likeUrl;
    NSString *_favoriteUrl;
    NSInteger _favoriteState;
    JumpBlock _myBlock;
}
- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 30;
    self.height = self.logImage.bounds.size.height;
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}
#pragma mark - 实现类方法 动态算行高
+(CGFloat)heightOfCellWithModel:(LogModel*)model
{
    //return 60 + 10 + 278 + [LZXHelper textHeightFromTextString:model.title width:kScreenSize.width-20 fontSize:18] + 80;
    if (model.cover_image.length) {
        return 79+278+3+[LZXHelper textHeightFromTextString:model.title width:kScreenSize.width-20 fontSize:18]+37;
    }else{
        return 79+[LZXHelper textHeightFromTextString:model.title width:kScreenSize.width-20 fontSize:18]+37;
    }
    return 300;
}
#pragma mark - 填充cell
- (void)showDataWithModel:(LogModel *)model{
    self.logModel = model;
    if (model.gender.integerValue == 1) {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed: @"set_gender_selected_boy"]];
    }else{
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed: @"set_gender_selected_girl"]];
    }
    self.nameLabel.text = model.username;
    self.cityLabel.text = model.city;
    self.sistanceLabel.text = [NSString stringWithFormat:@"%.01f公里",model.distance.integerValue/1000.0];
    self.timeLabel.text = [self dateStringFromNumberTime:model.duration.integerValue];

    [self rowHeightWithModel:model];
    
    self.logLabel.text = model.title;
    [self.likeButton setTintColor:[UIColor clearColor]];
    [self.likeButton setImage:[[UIImage imageNamed: @"detail_like"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.likeButton setImage:[[UIImage imageNamed: @"detail_like_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    self.likeLabel.text = model.like_count.stringValue;
    //判断有没有赞过
    NSString *key = [NSString stringWithFormat:@"%ld",(long)model.id.integerValue];
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
    NSString *key2 = [NSString stringWithFormat:@"favorite%ld",(long)model.id.integerValue];
    BOOL isFavorite = [[NSUserDefaults standardUserDefaults]boolForKey:key2];
    if (isFavorite) {
        self.favoriteButton.selected = YES;
    }else{
        self.favoriteButton.selected = NO;
    }

    [self.commentButton setTintColor:[UIColor clearColor]];
    [self.commentButton setImage:[[UIImage imageNamed: @"detail_comment"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.commentButton setImage:[[UIImage imageNamed: @"detail_comment_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    self.commentLabel.text = model.comment_count.stringValue;
}
#pragma mark - 封装 动态算各个视图frame
- (void)rowHeightWithModel:(LogModel *)model{
    CGRect viewFrame1 = self.view1.frame;
    viewFrame1.size.width = kScreenSize.width;
    self.view1.frame = viewFrame1;
    
    CGRect nameFrame = self.nameLabel.frame;
    nameFrame.size.width = kScreenSize.width-80;
    self.nameLabel.frame = nameFrame;
    
    CGRect logImageFrame = self.logImage.frame;
    
    if (model.cover_image.length) {
        logImageFrame.origin.x = 5;
        logImageFrame.size.width = kScreenSize.width-10;
        logImageFrame.size.height = 278;
        [self.logImage sd_setImageWithURL:[NSURL URLWithString:model.cover_image] placeholderImage:[UIImage imageNamed: @"LaunchImage-600-480h"]];
    }else{
        logImageFrame.size.height = 0;
    }
    self.logImage.frame = logImageFrame;
    
    CGRect logLabelFrame = self.logLabel.frame;
    logLabelFrame.origin.y = self.logImage.frame.size.height?self.logImage.frame.origin.y+self.logImage.frame.size.height+3:self.logImage.frame.origin.y;
    logLabelFrame.size.width = kScreenSize.width-20;
    logLabelFrame.size.height = [LZXHelper textHeightFromTextString:model.title width:logLabelFrame.size.width fontSize:18];
    self.logLabel.frame = logLabelFrame;
    
    CGRect viewFrame2 = self.view2.frame;
    viewFrame2.origin.y = self.logLabel.frame.origin.y+self.logLabel.frame.size.height+2;
    viewFrame2.size.width = kScreenSize.width - 20;
    self.view2.frame = viewFrame2;
    
    CGFloat space = (kScreenSize.width - 20 - 70*2-30-2*2)/2;
    CGRect buttonFrame1 = self.likeButton.frame;
    buttonFrame1.origin.x = 20;
    buttonFrame1.origin.y = self.view2.frame.origin.y+1+2;
    self.likeButton.frame = buttonFrame1;
    
    CGRect labelFrame1 = self.likeLabel.frame;
    labelFrame1.origin.x = self.likeButton.frame.origin.x+30+2;
    labelFrame1.origin.y = self.likeButton.frame.origin.y;
    self.likeLabel.frame = labelFrame1;
    
    CGRect buttonFrame2 = self.favoriteButton.frame;
    buttonFrame2.origin.x = self.likeLabel.frame.origin.x+40+space;
    //buttonFrame2.origin.x = kScreenSize.width/2-30-2/2+2;
    buttonFrame2.origin.y = self.likeButton.frame.origin.y;
    self.favoriteButton.frame = buttonFrame2;
    
    CGRect buttonFrame3 = self.commentButton.frame;
    buttonFrame3.origin.x = self.favoriteButton.frame.origin.x+30+space;
    buttonFrame3.origin.y = self.likeButton.frame.origin.y;
    self.commentButton.frame = buttonFrame3;
    
    CGRect labelFrame3 = self.commentLabel.frame;
    labelFrame3.origin.x = self.commentButton.frame.origin.x+30+2;
    labelFrame3.origin.y = self.likeButton.frame.origin.y;
    self.commentLabel.frame = labelFrame3;
    
    CGRect buttonFrame4 = self.favoriteButton.frame;
    buttonFrame4.origin.x = self.likeLabel.frame.origin.x+40+space-10;
    self.favoriteButton.frame = buttonFrame4;
}
#pragma mark - 封装头视图时间显示格式
- (NSString *)dateStringFromNumberTime:(NSInteger)time{
    if (time/60) {
        NSInteger m = time/60;
        if (m/60) {
            double h = m/60.0f;
            return [NSString stringWithFormat:@"%.01f小时",h];
        }else{
            return [NSString stringWithFormat:@"%.1ld分钟",(long)m];
        }
    }else{
        return @"刚刚";
    }
    return nil;
}
- (void)setMyBlock:(JumpBlock)block{
    if (_myBlock != block) {
        _myBlock = nil;
        _myBlock = block;
    }
}
- (JumpBlock)myBlock{
    return _myBlock;
}
#pragma mark - 按钮触发
- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 201://点赞、取消赞
        {
            NSDictionary *userDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"dict"];
            if ([userDict[@"token"]length]) {
                likeUrl = [kLikeUrl stringByAppendingString:userDict[@"token"]];
                _trackId = self.logModel.id.integerValue;
                
                NSString *key = [NSString stringWithFormat:@"%ld",(long)self.logModel.id.integerValue];
                BOOL isLike = [[NSUserDefaults standardUserDefaults]boolForKey:key];
                if (isLike) {
                    self.likeButton.selected = NO;
                    _state = 2;
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:key];
                    //同步到磁盘
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    self.logModel.like_count = @(self.logModel.like_count.integerValue-1);
                    self.likeLabel.text = [NSString stringWithFormat:@"%ld",(long)self.logModel.like_count.integerValue];
                }else{
                    self.likeButton.selected = YES;
                    _state = 1;
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
                    //同步到磁盘
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    self.logModel.like_count = @(self.logModel.like_count.integerValue+1);
                    self.likeLabel.text = [NSString stringWithFormat:@"%ld",(long)self.logModel.like_count.integerValue];
                }
                [self addLikeTask];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"请先登录账号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }
            break;
        case 202:
        {
            NSDictionary *userDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"dict"];
            if ([userDict[@"token"]length]) {
                _favoriteUrl = [kFavoriteUrl stringByAppendingString:userDict[@"token"]];
                _trackId = self.logModel.id.integerValue;
                
                NSString *key = [NSString stringWithFormat:@"favorite%ld",(long)self.logModel.id.integerValue];
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
        case 203://评论
        {
            NSDictionary *userDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"dict"];
            if ([userDict[@"token"]length]) {
                if (self.myBlock) {
                    self.myBlock(self.logModel);
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
#pragma mark - 增加任务 提交点赞
- (void)addLikeTask{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"new_state":@(1),@"track_id":@(6094)}];
    [dict setObject:[NSNumber numberWithInteger:_trackId] forKey:@"track_id"];
    [dict setObject:[NSNumber numberWithInteger:_state] forKey:@"new_state"];
    [_manager POST:likeUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"点赞下载成功");
        if (responseObject) {
           // NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"点赞失败");
    }];
}
#pragma mark - 增加任务 提交收藏
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
