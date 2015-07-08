//
//  MySettingModel.h
//  IRiding
//
//  Created by qianfeng01 on 15/7/1.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "BaseModel.h"

@interface MySettingModel : BaseModel
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *avatar_url;
@property (nonatomic,copy) NSNumber *gender;
@property (nonatomic,copy) NSNumber *ride_count;
@property (nonatomic,copy) NSNumber *ride_mile;
@property (nonatomic,copy) NSNumber *uid;
@property (nonatomic,copy) NSNumber *role;
@property (nonatomic,copy) NSNumber *status;
@property (nonatomic,copy) NSString *create_time;

@end
