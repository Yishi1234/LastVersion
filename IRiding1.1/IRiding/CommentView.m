//
//  CommentView.m
//  IRiding
//
//  Created by qianfeng01 on 15/6/25.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "CommentView.h"
@implementation CommentView
- (void)awakeFromNib{
    self.commentHeadView.layer.masksToBounds = YES;
    self.commentHeadView.layer.cornerRadius = 30;
    
}
#pragma mark - 填充cell
- (void)showDataWithHeadView:(NSString *)headImage userName:(NSString *)name time:(NSString *)time content:(NSString *)content gender:(NSInteger)gender replyUserName:(NSString *)replyUserName{
    //先设置各个视图的frame
    CGRect contentFrame = self.commentContent.frame;
    contentFrame.origin.y = self.commentTime.frame.origin.y+self.commentTime.frame.size.height+7;
    contentFrame.size.width = kScreenSize.width-80-10;
    if(replyUserName.length){
        contentFrame.size.height = [LZXHelper textHeightFromTextString:[[NSString stringWithFormat:@"回复 %@：",replyUserName]stringByAppendingString:content] width:kScreenSize.width-80-10 fontSize:14];
    }else{
        contentFrame.size.height = [LZXHelper textHeightFromTextString:content width:kScreenSize.width-80-10 fontSize:14];
    }
    self.commentContent.frame = contentFrame;
    
    CGRect lineFrame = self.lineView.frame;
    lineFrame.origin.y = self.commentContent.frame.origin.y+self.commentContent.frame.size.height+7;
    self.lineView.frame = lineFrame;
    self.rowHeight = self.lineView.frame.origin.y+2;
    
    //填充各个视图内容
    if (gender == 1) {
        [self.commentHeadView sd_setImageWithURL:[NSURL URLWithString:headImage] placeholderImage:[UIImage imageNamed:@"set_gender_selected_boy"]];
    }else{
        [self.commentHeadView sd_setImageWithURL:[NSURL URLWithString:headImage] placeholderImage:[UIImage imageNamed:@"set_gender_selected_girl"]];
    }
    self.commentName.text = name;
    self.commentTime.text = time;
    if(replyUserName.length){
        self.commentContent.text = [[NSString stringWithFormat:@"回复 %@：",replyUserName]stringByAppendingString:content];
    }else{
        self.commentContent.text = content;
    }
}
@end
