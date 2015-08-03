//
//  RegisterController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/22.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "RegisterController.h"

@interface RegisterController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UIButton *regsiterButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

@end
@implementation RegisterController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _initDefaultUI];
}
#pragma mark - UI
- (void)_initDefaultUI
{
   
    self.regsiterButton.layer.cornerRadius = 3.0 ;
    
    if (_isForgetBttonPushSegue) {
        
        [self.regsiterButton setTitle:@"确 定" forState:UIControlStateNormal];
        self.agreeButton.hidden = YES ;
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES ;
}
#pragma mark - Action

- (IBAction)clickBgView:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)registerAction:(UIButton *)sender {
    
    
    if([Tool removeFirstSpace:_userNameTF.text].length == 0){
        [[[UIAlertView alloc]initWithTitle:nil message:@"请输入手机号码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
        return ;
    }
    
    if (![Tool checkTelNumber:_userNameTF.text]) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
        return ;
    }
    
    NSString *manmand ;
    // 忘记密码
    if (_isForgetBttonPushSegue) {
        manmand = @"106";
    }
    else{
        manmand = @"101";
    }

    //注册
    WS(weakSelf);
    
    [SVProgressHUD show];
    
    NSDictionary *parmDict = @{
                               @"publickey":PUBLICKEY,
                               @"command":manmand,
                               @"mobile":_userNameTF.text
                               };
    
    [[NetworkService sharedClient]startNetworkUrl:@"" andParmDict:parmDict andNetworkServiceDelegate:nil andCompletionBlock:^(id result){
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)result;
            NSInteger manmandInt = [manmand integerValue];
            
            if ([dict[@"command"] integerValue] == manmandInt && [dict[@"result"] integerValue] == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc]initWithTitle:nil message:@"初始密码已发送到您手机请注意查收" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
                    //push LoginCtl
                    [weakSelf dismissViewControllerAnimated:YES completion:^{
                        weakSelf.moblieBlock(weakSelf.userNameTF.text);
                    }];
                });
            }
            else{
                if ([dict[@"command"] integerValue] == manmandInt && [dict[@"result"] integerValue] == -110) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc]initWithTitle:nil message:@"手机号码已注册" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
                    });
                }
                else if([dict[@"command"] integerValue] == manmandInt && [dict[@"result"] integerValue] == -201) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc]initWithTitle:nil message:@"用户不存在" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc]initWithTitle:nil message:@"信息发送失败请稍后再试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
                    });
                }
                
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
             [SVProgressHUD dismiss];
        });
       
    }andFailBlock:^(NSString *fail){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc]initWithTitle:nil message:@"信息发送失败请稍后再试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
            [SVProgressHUD dismiss];
        });
    
        
    }];
    
}

- (IBAction)readAgree:(UIButton *)sender {
    
}
- (IBAction)backLoginAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
