//
//  AddUserController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/3.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "AddUserController.h"
#import "User.h"
#import <CoreData/CoreData.h>
#import "CoreDataStack.h"

@interface AddUserController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userTF;
@property (weak, nonatomic) IBOutlet UITextField *mailTF;
@property (weak, nonatomic) IBOutlet UITextField *mobieTF;
@property (nonatomic , retain)NSManagedObjectContext            *context ;

@end

@implementation AddUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_userTF becomeFirstResponder];

    self.isHidenRightButton = NO ;
    
    self.context = [CoreDataStack shareManaged].managedObjectContext ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - private Funs
- (void)leftAction
{
    //[self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)rightAction
{
    
    if ([Tool removeFirstSpace:self.userTF.text].length == 0) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"用户名不能留空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show ];
        return ;
    }
    
    if ([Tool removeFirstSpace:self.mailTF.text].length == 0) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"邮箱不能留空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show ];
        return ;
    }
    
    if ([Tool removeFirstSpace:self.mobieTF.text].length == 0) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"手机号码不能留空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show ];
        return ;
    }
    
    NSEntityDescription  *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.context];
    User *user = [[User alloc]initWithEntity:entity insertIntoManagedObjectContext:self.context];
    
    user.userName = self.userTF.text ;
    user.userMail = self.mailTF.text ;
    user.userMobile = self.mobieTF.text ;
    
    if (![self.context save:nil]) {
        debugLog(@"add user fail");
    }
    //[self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES ;
}

@end
