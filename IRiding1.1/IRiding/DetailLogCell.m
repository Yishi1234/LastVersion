//
//  DetailLogCell.m
//  IRiding
//
//  Created by qianfeng01 on 15-6-17.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "DetailLogCell.h"
#import "LZXHelper.h"
@implementation DetailLogCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    CGRect lineViewFrame = self.lineView.frame;
    lineViewFrame.origin.x = 136;
    lineViewFrame.size.width = kScreenSize.width-136;
    self.lineView.frame = lineViewFrame;
}
#pragma mark - 填充cell
- (void)showDataWithModel:(DetailModel *)model indexPath:(NSIndexPath *)indexPath{
    //填充内容
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [df stringFromDate:date];
    NSDictionary *dict = model.photos[indexPath.row];
    NSString *str = dict[@"date_time"];
    if ([dateStr isEqualToString:[str substringToIndex:10]]) {
        self.timeLabel.text = [NSString stringWithFormat:@"今天 %@",[str substringWithRange:NSMakeRange(11, 5)]];
    }else{
        self.timeLabel.text = [str substringWithRange:NSMakeRange(0, 16)];
    }
    [self.logImage sd_setImageWithURL:[NSURL URLWithString:dict[@"url"]] placeholderImage:[UIImage imageNamed: @"LaunchImage-600-480h"]];
    self.logLabel.text = dict[@"desc"];
    
    //设置视图frame
    CGRect logImageFrame = self.logImage.frame;
    logImageFrame.origin.x = 1;
    logImageFrame.size.width = kScreenSize.width-2;
    
    if ([dict[@"url"]length]) {
        logImageFrame.size.height = 275;
    }else{
        logImageFrame.size.height = 0;
    }
    self.logImage.frame = logImageFrame;
    
    CGRect frame = self.logLabel.frame;
    frame.origin.x = 10;
    frame.origin.y = self.logImage.frame.origin.y+self.logImage.frame.size.height+7;
    frame.size.width = kScreenSize.width-20;
    if ([dict[@"desc"]length]) {
        frame.size.height = [LZXHelper textHeightFromTextString:self.logLabel.text width:frame.size.width fontSize:16];
    }else{
        frame.size.height = 0;
    }
    self.logLabel.frame = frame;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
