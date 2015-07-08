//
//  UserHeadView.h
//  IRiding
//
//  Created by qianfeng01 on 15/6/19.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
typedef void(^LikeBlock)(DetailModel *model);

@interface UserHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)showDataWithModel:(DetailModel *)model;
- (void)setMyBlockWithBlock:(LikeBlock)block;
- (LikeBlock)myBlock;
@property (nonatomic,strong)DetailModel *model;
@end
