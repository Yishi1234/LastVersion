//
//  UIImageView+ImageViewEventBlock.m
//  IRiding
//
//  Created by qianfeng01 on 15/6/22.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "UIImageView+ImageViewEventBlock.h"
#import <objc/runtime.h>
@interface UIImageView()
@property (nonatomic,copy)ImageViewBlock myBlock;
@end

@implementation UIImageView (ImageViewEventBlock)
- (void)setMyBlock:(ImageViewBlock)myBlock{
    objc_setAssociatedObject(self, @"myBlock", myBlock, OBJC_ASSOCIATION_COPY);
}
- (ImageViewBlock)myBlock{
    return objc_getAssociatedObject(self, @"myBlock");
}
- (void)addClickEvent:(ImageViewBlock)block{
    self.userInteractionEnabled = YES;
    self.myBlock = block;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.myBlock) {
        self.myBlock(self);
    }
}
@end
