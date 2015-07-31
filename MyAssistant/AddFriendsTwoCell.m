//
//  AddFriendsCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/28.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "AddFriendsTwoCell.h"
#import "User.h"

@implementation AddFriendsTwoCell

- (void)awakeFromNib {
    
    self.inviteButton.layer.cornerRadius = 5.0 ;
    self.friendsImage.layer.cornerRadius = 5.0 ;
    self.friendsImage.clipsToBounds = YES ;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
- (void)setFriends:(NSArray *)friends
{
    if (_friends != friends) {
        _friends = friends ;
    }
    User *user = _friends[self.inviteButton.tag];
    self.friendsImage.image = [UIImage imageWithData:user.userImg];
    self.friendNick.text = user.userName ;
}
- (IBAction)inviteAction:(UIButton *)sender {
   
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"好友验证" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput ;
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.placeholder = DEVICE_NAME ;
    [alertView show];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //UITextField *textField = [alertView textFieldAtIndex:0];
    
}
@end
