//
//  LogCell.h
//  IRiding
//
//  Created by qianfeng01 on 15-6-11.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogModel.h"
#import "AppListViewController.h"
#import "DetailModel.h"

typedef void(^JumpBlock)(LogModel *model);


@interface LogCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *sistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logImage;
@property (weak, nonatomic) IBOutlet UILabel *logLabel;

- (IBAction)btnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
- (void)showDataWithModel:(LogModel *)model;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

//@property (nonatomic)CGFloat rowHeight;
@property (nonatomic)CGFloat height;

@property (nonatomic,retain)LogModel *logModel;

- (void)setMyBlock:(JumpBlock)block;
- (JumpBlock)myBlock;

+(CGFloat)heightOfCellWithModel:(LogModel*)model;
@end
