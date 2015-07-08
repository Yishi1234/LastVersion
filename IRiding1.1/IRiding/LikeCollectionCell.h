//
//  LikeCollectionCell.h
//  IRiding
//
//  Created by qianfeng01 on 15/6/29.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
@interface LikeCollectionCell : UICollectionViewCell
- (void)showDataWithHeadImage:(NSString *)image name:(NSString *)name gender:(NSInteger)gender;
//+ (CGFloat)itemHeightWithName:(NSString *)name;
@end
