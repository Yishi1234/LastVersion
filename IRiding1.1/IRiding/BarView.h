//
//  BarView.h
//  IRiding
//
//  Created by qianfeng01 on 15/6/26.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
typedef void(^BarBlock)(DetailModel *model);
@interface BarView : UIView
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
- (IBAction)btnClick:(UIButton *)sender;
- (void)showDataWithModel:(DetailModel *)model;
- (void)setMyBlock:(BarBlock)block;
- (BarBlock)myBlock;
@property (nonatomic,strong)DetailModel *model;
@end
