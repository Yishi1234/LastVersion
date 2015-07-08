//
//  BaseModel.h
//  IRiding
//
//  Created by qianfeng01 on 15-6-11.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
- (id)valueForUndefinedKey:(NSString *)key;
@end
