//
//  LogModel.h
//  IRiding
//
//  Created by qianfeng01 on 15-6-11.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "BaseModel.h"

@interface LogModel : BaseModel
@property (nonatomic,copy) NSNumber *id;
@property (nonatomic,copy) NSString *date_time;
@property (nonatomic,copy) NSString *end_time;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSNumber *distance;
@property (nonatomic,copy) NSNumber *duration;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *cover_image;
@property (nonatomic,copy) NSNumber *width;
@property (nonatomic,copy) NSNumber *height;
@property (nonatomic,copy) NSNumber *uid;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *avatar_url;
@property (nonatomic,copy) NSNumber *gender;
@property (nonatomic,copy) NSNumber *like_count;
@property (nonatomic,copy) NSNumber *comment_count;
@property (nonatomic,copy) NSNumber *visit_count;
@property (nonatomic,copy) NSNumber *display_order;
@property (nonatomic,copy) NSNumber *image_count;
@property (nonatomic,copy) NSNumber *favorite_count;
@property (nonatomic,copy) NSNumber *digested;
@property (nonatomic,copy) NSNumber *hotValue;
@property (nonatomic,copy) NSNumber *from;
@property (nonatomic,copy) NSNumber *publish_time;

@property (nonatomic) CGFloat rowHeight;

@end
