//
//  EditScheduleController.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/30.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "EditScheduleController.h"

@interface EditScheduleController ()<UITextFieldDelegate , UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *scheduleNameTF;
@property (weak, nonatomic) IBOutlet UITextField *scheduleAdressTF;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *desTextViewLabel;

@end

@implementation EditScheduleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHidenRightButton = NO ;
    
    self.scheduleNameTF.text = self.scheduleModel.scheduleName ;
    self.scheduleAdressTF.text = self.scheduleModel.scheduleAddress ;
    self.descriptionTextView.text = self.scheduleModel.scheduleDescribe ;
    
    if (self.scheduleModel.scheduleDescribe.length != 0) {
        self.desTextViewLabel.hidden = YES ;
    }
    else{
        self.desTextViewLabel.hidden = NO ;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Action
- (void)rightAction
{
    if (self.scheduleNameTF.text == 0) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"日程名称不能留空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
        return ;
    }
    
        
    self.scheduleModel.scheduleName = self.scheduleNameTF.text ;
    self.scheduleModel.scheduleAddress = self.scheduleAdressTF.text ;
    self.scheduleModel.scheduleDescribe = [Tool removeLastSpace:self.descriptionTextView.text] ;
    
    if (![[CoreDataStack shareManaged].managedObjectContext save:nil]) {
        debugLog(@"modity schedule name fail");
    }
    if (self.modityScheduleNameBlock) {
        self.modityScheduleNameBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES ;
}
#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length != 0) {
        self.desTextViewLabel.hidden = YES ;
    }
    else{
        self.desTextViewLabel.hidden = NO ;
    }
    
}
@end
