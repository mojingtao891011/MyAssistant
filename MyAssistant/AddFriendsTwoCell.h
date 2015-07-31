//
//  AddFriendsCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/28.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendsTwoCell : UITableViewCell<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *friendsImage;
@property (weak, nonatomic) IBOutlet UILabel *friendNick;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (nonatomic , retain)NSArray *friends;

- (IBAction)inviteAction:(UIButton *)sender;

@end
