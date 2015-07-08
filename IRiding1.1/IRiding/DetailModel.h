//
//  DetailModel.h
//  IRiding
//
//  Created by qianfeng01 on 15-6-17.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "LogModel.h"

@interface DetailModel : LogModel
@property (nonatomic,copy) NSNumber *code;
@property (nonatomic,copy) NSNumber *trip_id;
@property (nonatomic,copy) NSNumber *max_speed;
@property (nonatomic,copy) NSNumber *ave_speed;
@property (nonatomic,copy) NSNumber *calorie;
@property (nonatomic,copy) NSNumber *like_state;
@property (nonatomic,copy) NSNumber *is_favorited;
@property (nonatomic,copy) NSArray *tracks;
@property (nonatomic,copy) NSArray *photos;
@property (nonatomic,copy) NSArray *like;
@property (nonatomic,copy) NSArray *comments;


@end
