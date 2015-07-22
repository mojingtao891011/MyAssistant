//
//  RegisterController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/22.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "RegisterController.h"

@interface RegisterController ()

@property (weak, nonatomic) IBOutlet UIView *userNameViewBg;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UIButton *fetchVCodeButton;
@property (weak, nonatomic) IBOutlet UIView *vcodeViewBg;
@property (weak, nonatomic) IBOutlet UITextField *vcodeTF;
@property (weak, nonatomic) IBOutlet UIView *passwordViewBg;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *regsiterButton;

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
    self.userNameViewBg.layer.cornerRadius = 3.0 ;
    self.fetchVCodeButton.layer.cornerRadius = 2.0 ;
    self.vcodeViewBg.layer.cornerRadius = 3.0 ;
    self.passwordViewBg.layer.cornerRadius = 3.0 ;
    self.regsiterButton.layer.cornerRadius = 3.0 ;
}
#pragma mark - Action
- (IBAction)fetchVcodeAction:(UIButton *)sender {
}
- (IBAction)showPasswordAction:(UIButton *)sender {
}
- (IBAction)registerAction:(UIButton *)sender {
}
- (IBAction)agreeAction:(UIButton *)sender {
}
- (IBAction)readAgree:(UIButton *)sender {
}

@end
