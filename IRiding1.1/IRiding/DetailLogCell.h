//
//  DetailLogCell.h
//  IRiding
//
//  Created by qianfeng01 on 15-6-17.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
@interface DetailLogCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logImage;
@property (weak, nonatomic) IBOutlet UILabel *logLabel;

- (void)showDataWithModel:(DetailModel *)model indexPath:(NSIndexPath *)indexPath;
@end
