//
//  AdvModel.h
//  IRiding
//
//  Created by qianfeng01 on 15-6-11.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "BaseModel.h"

@interface AdvModel : BaseModel
@property (nonatomic,copy) NSNumber *specialId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *cover;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSNumber *status;

@end
