//
//  CommentCommitViewController.m
//  IRiding
//
//  Created by qianfeng01 on 15/6/26.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "CommentCommitViewController.h"
@interface CommentCommitViewController ()<UITextViewDelegate>
{
    UITextView *commentTextView ;
    UILabel *guideLabel;
    NSString *commentUrl;
}
@end

@implementation CommentCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"写评论";
    //self.view.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
    [self creatItemsWithIsLeft];
    [self creatTextView];
}
- (void)creatItemsWithIsLeft{
    //UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
   UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"confirm_highlighted"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)creatTextView{
    commentTextView = [[UITextView alloc]initWithFrame:self.view.bounds];
    commentTextView.backgroundColor = [UIColor colorWithRed:0.95 green:0.7 blue:0.2 alpha:0.3];
    commentTextView.delegate = self;
    commentTextView.font = [UIFont systemFontOfSize:17];
    guideLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, 180, 40)];
    guideLabel.font = [UIFont systemFontOfSize:17];
    guideLabel.text = @"在这里写下你的评论吧";
    guideLabel.textColor = [UIColor darkGrayColor];
    [commentTextView addSubview:guideLabel];
    
    [self.view addSubview:commentTextView];
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length) {
        guideLabel.hidden = YES;
    }
}
- (void)rightItemClick:(UIBarButtonItem *)item{
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"dict"];
    if ([userDict[@"token"]length]) {
        if (commentTextView.text.length) {
            commentUrl = [kCommentUrl stringByAppendingString:userDict[@"token"]];
            [self addCommitCommentTask];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"评论内容不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"请先登录账号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}
- (void)addCommitCommentTask{
    NSMutableDictionary *commentDict = [NSMutableDictionary dictionaryWithDictionary:@{@"content":@"棒棒哒",@"reply_uid":@(0),@"track_id":@(6094)}];
    [commentDict setObject:commentTextView.text forKey:@"content"];
    [commentDict setObject:[NSNumber numberWithInteger:self.track_id] forKey:@"track_id"];
    [_manager POST:commentUrl parameters:commentDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"评论成功");
        if (responseObject) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"评论失败");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
