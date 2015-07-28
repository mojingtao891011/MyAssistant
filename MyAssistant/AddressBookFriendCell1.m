//
//  AddressBookFriendCell1.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/28.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "AddressBookFriendCell1.h"

@implementation AddressBookFriendCell1

- (void)awakeFromNib {

    self.addAddressBookFriendButton.layer.cornerRadius = 5.0 ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addAddressBookFriendAction:(UIButton *)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"好友验证" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput ;
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.placeholder = @"请输入验证信息" ;
    [alertView show];
    
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //UITextField *textField = [alertView textFieldAtIndex:0];
    
}
@end
