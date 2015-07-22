//
//  LoginController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/22.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()

@property (weak, nonatomic) IBOutlet UIView *userNameViewBg;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UIView *passwordViewBg;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _initDefaultUI];
}
#pragma mark - UI
- (void)_initDefaultUI
{
    self.userNameViewBg.layer.cornerRadius = 3.0 ;
    self.passwordViewBg.layer.cornerRadius = 3.0 ;
    self.loginButton.layer.cornerRadius = 3.0 ;
    
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 50, 44)];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    backButton.imageEdgeInsets = edgeInsets;
    [backButton addTarget:self action:@selector(cancelLogin) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBrttonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = barBrttonItem ;
    
}
#pragma mark - Action
- (void)cancelLogin
{

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)loginAction:(UIButton *)sender {
    
    if (self.loginControllerBlock) {
        self.loginControllerBlock(YES);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)forgetPasswordAction:(UIButton *)sender {
}
- (IBAction)verificationCodeLoginAction:(UIButton *)sender {
}

@end
