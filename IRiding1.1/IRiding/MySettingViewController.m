//
//  MySettingViewController.m
//  IRiding
//
//  Created by qianfeng01 on 15/7/1.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "MySettingViewController.h"
#import "MySettingModel.h"
#import "UIImageView+ImageViewEventBlock.h"
#import "ChangePasswdViewController.h"
@interface MySettingViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UIImagePickerController *pickerImage;
    UIActionSheet *photoSheet;
    NSInteger _currentGender;
    
}
@property (nonatomic)NSData *photoData;
@property (nonatomic,strong)MySettingModel *model;
@end

@implementation MySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.model = [[MySettingModel alloc]init];
    [self creatView];
    [self addTask];
    _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
}
#pragma mark - 用本地数据填充视图
- (void)creatView{
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 40;
    [self.headImage addClickEvent:^(UIImageView *imageView) {
        photoSheet = [[UIActionSheet alloc]initWithTitle:@"添加照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册上传", nil];
        //[self goToCamera];
        [photoSheet showInView:self.view];
    }];
    
    self.manButton.layer.masksToBounds = YES;
    self.manButton.layer.cornerRadius = 10;
    [self.manButton setImage:[[UIImage imageNamed:@"set_gender_boy"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.manButton setImage:[[UIImage imageNamed:@"set_gender_selected_boy"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    
    self.womanButton.layer.masksToBounds = YES;
    self.womanButton.layer.cornerRadius = 10;
    [self.womanButton setImage:[[UIImage imageNamed:@"set_gender_girl"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.womanButton setImage:[[UIImage imageNamed:@"set_gender_selected_girl"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    
    self.passwdGoForwoad.image = [UIImage imageNamed:@"gofoward"];
    [self passwdViewAddTarget:self action:@selector(goChangePasswd)];
}
#pragma mark - 给修改密码视图增加点击事件 增加手势
- (void)passwdViewAddTarget:(id)target action:(SEL)action{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [self.passwdView addGestureRecognizer:tap];
}
#pragma mark - 跳转到修改密码界面
- (void)goChangePasswd{
    ChangePasswdViewController *change = [[ChangePasswdViewController alloc]init];
    [self.navigationController pushViewController:change animated:YES];
}
#pragma mark - 增加任务 加载用户信息
- (void)addTask{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"other_uid":@(-1)}];
    [_manager POST:self.url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSLog(@"个人设置界面下载成功");
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *profileDict = responseDict[@"profile"];
            [self.model setValuesForKeysWithDictionary:profileDict];
            [self showDataWithModel:self.model];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"个人设置界面下载失败");
    }];
}
#pragma mark - 填充各个子视图
- (void)showDataWithModel:(MySettingModel *)model{
    if (model.gender.integerValue == 1) {
        _currentGender = 1;
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed:@"set_gender_selected_boy"]];
        self.manButton.selected = YES;
        self.womanButton.selected = NO;
    }else{
        _currentGender = 2;
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed:@"set_gender_selected_girl"]];
        self.manButton.selected = NO;
        self.womanButton.selected = YES;
    }
    self.userNameTextField.text = model.name;
}
#pragma mark - UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet == photoSheet) {
        switch (buttonIndex) {
            case 0://拍照
            {
                [self goToCameraWithSourceType:@"camera"];
            }
                break;
            case 1://从相册上传
            {
                [self goToCameraWithSourceType:@"library"];
            }
                break;
            case 2://取消
            {
                
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark - 封装调用相机
- (void)goToCameraWithSourceType:(NSString *)sourceType{
    if ([sourceType isEqualToString:@"camera"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            pickerImage = [[UIImagePickerController alloc]init];
            pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
            //相机的调用为照相模式
            pickerImage.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            //设置为NO 则隐藏拍照按钮
            pickerImage.showsCameraControls = YES;
            //设置相机摄像头 默认为前置
            pickerImage.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            //设置闪光灯开关
            pickerImage.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
            pickerImage.delegate = self;
            pickerImage.allowsEditing = YES;
            [self presentViewController:pickerImage animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"当前设备不支持相机功能" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else if([sourceType isEqualToString:@"library"]){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage = [[UIImagePickerController alloc]init];
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.delegate = self;
            pickerImage.allowsEditing = YES;
            [self presentViewController:pickerImage animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"当前设备不支持相册功能" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
#pragma mark - UIImagePickerControllerDelegate
//点击相册中的图片或照相机照完后点击use后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.photoData = UIImagePNGRepresentation(image);
    [self addPhotoTask];
    //[picker dismissViewControllerAnimated:YES completion:nil];
}
//点击cancel调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 封装方法 上传图片
- (void)addPhotoTask{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"dict"];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:@"照片上传中" status:@"uploading..."];
    __weak typeof (self)weakSelf = self;
    [_manager POST:[kPhotoUrl stringByAppendingString:dict[@"token"]] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:self.photoData name:@"pic" fileName:@"avatar.jpg" mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject){
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([responseDict[@"pic_url"]length]) {
                weakSelf.model.avatar_url = responseDict[@"pic_url"];
                [weakSelf showDataWithModel:weakSelf.model];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"照片上传失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alert show];
            }
            [pickerImage dismissViewControllerAnimated:YES completion:nil];
        }
        [MMProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MMProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"照片上传失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        [pickerImage dismissViewControllerAnimated:YES completion:nil];
    }];
}
#pragma mark - 按钮触发
- (IBAction)btnClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 201://男生按钮
        {
            if (button.selected) {
                
            }else{
                button.selected = YES;
                _currentGender = 1;
                UIButton *button = (UIButton *)[self.view viewWithTag:202];
                button.selected = NO;
            }
        }
            break;
        case 202://女生按钮
        {
            if (button.selected) {
                
            }else{
                button.selected = YES;
                _currentGender = 2;
                UIButton *button = (UIButton *)[self.view viewWithTag:201];
                button.selected = NO;
            }
        }
            break;
        case 203://保存按钮
        {
            [self addSaveInformationTask];
        }
            break;
        default:
            break;
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        
        if (buttonIndex == 1)
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        else
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController: imagePickerController
                           animated: YES
                         completion: nil];
    });
}
#pragma mark - 增加任务 保存个人信息
- (void)addSaveInformationTask{
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"gender":@(2),@"name":@"哈哈"}];
    [dict setObject:[NSNumber numberWithInteger:_currentGender] forKey:@"gender"];
    [dict setObject:self.userNameTextField.text forKey:@"name"];
    NSDictionary *tokenDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"dict"];
    //NSLog(@"%@",[kMyInformationUrl stringByAppendingString:tokenDict[@"token"]]);
    __weak typeof (self)weakSelf = self;
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:@"用户信息更新中" status:@"loading..."];
    [_manager POST:[kMyInformationUrl stringByAppendingString:tokenDict[@"token"]] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"保存个人信息成功");
        if (responseObject) {
             NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([responseDict[@"message"] isEqualToString:@"修改成功"]) {
                [MMProgressHUD dismissWithSuccess:@"用户信息更新成功" title:@"恭喜"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [MMProgressHUD dismissWithSuccess:@"用户信息更新失败" title:@"Sorry"];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"保存个人信息失败");
        [MMProgressHUD dismissWithError:@"用户信息更新失败" title:@"Sorry"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.photoData = nil;
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
