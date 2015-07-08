//
//  ADView.h
//  UITableView_Cell定制
//
//  Created by LZXuan on 14-12-18.
//  Copyright (c) 2014年 LZXuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvModel.h"
//广告位 视图  按页显示
@interface ADView : UIView <UIScrollViewDelegate>
- (void)creatViewWithAdvArr:(NSMutableArray *)arr;
@end
