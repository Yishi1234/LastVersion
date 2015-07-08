//
//  CommentView.h
//  IRiding
//
//  Created by qianfeng01 on 15/6/25.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
#import "LZXHelper.h"
@interface CommentView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *commentHeadView;
@property (weak, nonatomic) IBOutlet UILabel *commentName;
@property (weak, nonatomic) IBOutlet UILabel *commentTime;
@property (weak, nonatomic) IBOutlet UILabel *commentContent;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic) NSInteger rowHeight;
- (void)showDataWithHeadView:(NSString *)headImage userName:(NSString *)name time:(NSString *)time content:(NSString *)content gender:(NSInteger)gender replyUserName:(NSString *)replyUserName;
@end
