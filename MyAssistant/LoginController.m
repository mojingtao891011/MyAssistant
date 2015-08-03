//
//  LoginController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/22.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "LoginController.h"
#import "TabBarViewController.h"
#import "RegisterController.h"
#import "User.h"

@interface LoginController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic , retain)NSManagedObjectContext        *context;

@end

@implementation LoginController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [CoreDataStack shareManaged].managedObjectContext ;
    
    [self _initDefaultUI];
}
#pragma mark - UI
- (void)_initDefaultUI
{
    self.loginButton.layer.cornerRadius = 3.0 ;
    
    if (USER_ID) {
        self.userNameTF.text = USER_ID ;
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES ;
}
#pragma mark - Action
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WS(weakSelf);
    if ([segue.identifier isEqualToString:@"forgetButtonPushSegue"]) {
        
        RegisterController *registerCtl = segue.destinationViewController ;
        registerCtl.isForgetBttonPushSegue = YES ;
    }
    else if ([segue.identifier isEqualToString:@"registerSegue"]){
        RegisterController *registerCtl = segue.destinationViewController ;
        registerCtl.moblieBlock = ^(NSString *moblie){
            weakSelf.userNameTF.text = moblie ;
        };
    }
}
- (IBAction)clickBgView:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (IBAction)loginAction:(UIButton *)sender {
    
    
    
    //判断
    if ([Tool removeFirstSpace:_userNameTF.text].length == 0) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"用户名不能留空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
        return ;
    }
    
    if ([Tool removeFirstSpace:_passwordTF.text].length == 0) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"密码不能留空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
        return ;
    }
    
    //网络
    [self startLogin];
    
}
#pragma mark - NetWork
- (void)startLogin
{
    WS(weakSelf);
    
    [SVProgressHUD show];
    
    NSDictionary *parmDict  = @{
                                @"publickey":PUBLICKEY,
                                @"command":@"102",
                                @"mobile":_userNameTF.text,
                                @"passwd":_passwordTF.text
                                };
    
    [[NetworkService sharedClient]startNetworkUrl:@"" andParmDict:parmDict andNetworkServiceDelegate:nil andCompletionBlock:^(id result){
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDict = (NSDictionary*)result ;
            if ([resultDict[@"command"] integerValue] == 102 && [resultDict[@"result"] integerValue] == 0) {
                
                //保存privatekey
                [[NSUserDefaults standardUserDefaults]setObject:resultDict[@"privatekey"] forKey:@"privatekey"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                //保存userID
                [[NSUserDefaults standardUserDefaults]setObject:_userNameTF.text forKey:@"userID"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                //保存密码
                [[NSUserDefaults standardUserDefaults]setObject:_passwordTF.text forKey:@"password"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                //创建user
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:weakSelf.context];
                User *curUser = [[User alloc]initWithEntity:entity insertIntoManagedObjectContext:weakSelf.context];
                curUser.userID = _userNameTF.text;
                NSError *error ;
                if ([weakSelf.context save:&error]) {
                    if (error) {
                        debugLog(@"save user Fail");
                    }
                    else{
                        
                    }
                }
                
                //返回主界面
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    TabBarViewController *tabBarCtl = [storyboard instantiateViewControllerWithIdentifier:@"TabBarCtl"];
                    [self presentViewController:tabBarCtl animated:YES completion:nil];
                    
                    [SVProgressHUD dismiss];
                });
                
                
            }
            else
            {
                
                if ([resultDict[@"command"] integerValue] == 102 ) {
                    switch ([resultDict[@"result"] integerValue]) {
                        case -201:
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[[UIAlertView alloc]initWithTitle:nil message:@"用户不存在" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
                            });
                            break;
                        case -202:
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[[UIAlertView alloc]initWithTitle:nil message:@"密码错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
                            });
                            break;
                            
                        default:
                            break;
                    }
                    [SVProgressHUD dismiss];
                }
               
            }
        }
    }andFailBlock:^(NSString *fail){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc]initWithTitle:nil message:@"网络超时" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
             [SVProgressHUD dismiss];
        });
        
       
    }];
}
@end
