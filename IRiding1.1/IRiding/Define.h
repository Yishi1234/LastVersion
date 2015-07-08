//
//  Define.h
//  IRiding
//
//  Created by qianfeng01 on 15-6-8.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#ifndef IRiding_Define_h
#define IRiding_Define_h

#define kScreenSize [UIScreen mainScreen].bounds.size
#import "MMProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "JHRefresh.h"
#import "AFNetworking.h"
#import "MyControl.h"
//应用界面接口
#define kAppUrl @"http://www.cookee.com.cn:9002/getRideTracksTimeLine?token="

//"last_id"的值是上一页最后一个数据的"display_order":6899 对应的值,首次是0
//"uid"对应的是伊始的数据的id
//"last_id"的值是上一页最后一个数据的"display_order":6899 对应的值,首次是0
//最新界面  "filter_type":2
//热门界面 "filter_type":1
//收藏界面  "filter_type":3
//个人中心接口  我的骑行日志  "filter_type":0
     //{"uid":11410,"filter_type":0,"page":0,"last_id":0,"city":""}


//详情界面接口
#define kDetailUrl @"http://www.cookee.com.cn:9002/getRideTrackDetail?token="
//#define kDetailDict @{"trackId":%ld}
//"trackId"的值是用户数据的"id": 4588 对应的值

//注册接口
//手机号注册接口
#define kPhoneRegisterUrl @"http://www.cookee.com.cn:9002/getVerifyCode"

//提交注册信息接口
#define kRegisterUrl @"http://www.cookee.com.cn:9002/register"

//赞接口
#define kLikeUrl @"http://www.cookee.com.cn:9002/likeTrack?token="
//#define kLikeDict @{"new_state":%ld,"track_id":%ld}
//"trackId"的值是用户数据的"id": 4588 对应的值
//点赞 "new_state":1
//取消赞 "new_state":2

//评论接口
#define kCommentUrl @"http://www.cookee.com.cn:9002/comment?token="
//#define kCommentDict @{"content":%@,"reply_uid":%ld,"track_id":%ld}
//"content"的值是评论的内容
//"reply_uid"如果是评论本人，值就是0 @别人,即回复别人，就是 那个人的值 对应数据"id": 6375,
//"trackId"的值是用户数据的"id": 4588 对应的值

//收藏接口
#define kFavoriteUrl @"http://www.cookee.com.cn:9002/favoriteTrack?token="
//#define kFavoriteDict @{"new_state":%ld,"track_id":%ld}
//"trackId"的值是用户数据的"id": 4588 对应的值
//收藏 "new_state":1
//取消收藏  "new_state":0

//登陆接口
#define kLoginUrl @"http://www.cookee.com.cn:9002/login"
//#define kLoginDict @{"password":%@,"phone":%@}
//"password":"15041043","phone":"13523743361"

//公共自行车
//#define kPubBikeUrl @"http://www.cookee.com.cn:9002/searchStation?token="
//#define kPubBikeDict @{"radius":3000,"lon":113.675749,"page":1,"lat":34.772671,"city":"Xiamen"}
//{"radius":3000,"lon":113.675749,"page":1,"lat":34.772671,"city":"Xiamen"}

//消息中心：
//#define kMessageUrl @"http://www.cookee.com.cn:9002/getMessageTimeLine?token="
//#define kMessageDict @{"last_id":0}

//重置密码 获取验证码
#define kResetCodeUrl @"http://www.cookee.com.cn:9002/getResetPwdVerifyCode"
//重置密码 提交新信息
#define kResetPasswdUrl @"http://www.cookee.com.cn:9002/resetPassword"
//下拉加载评论
#define kCommentMessageUrl @"http://www.cookee.com.cn:9002/getComments?token="
//点赞列表接口
#define kLikeListUrl @"http://www.cookee.com.cn:9002/getRideTrackLikeList?token="
//个人设置接口
#define kMySettingUrl @"http://www.cookee.com.cn:9002/getProfile?token="
//上传图片接口
#define kPhotoUrl @"http://www.cookee.com.cn:9002/uploadAvatar?token="
//保存个人信息设置接口
#define kMyInformationUrl @"http://www.cookee.com.cn:9002/uploadProfile?token="
//个人设置修改密码接口
#define kChangePasswdUrl @"http://www.cookee.com.cn:9002/changePassword?token="
#endif
