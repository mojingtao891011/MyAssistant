//
//  AddressBookFriendCell2.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/28.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressBookFriendCell2 : UITableViewCell<MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *addressBookFriendName;
@property (weak, nonatomic) IBOutlet UILabel *addressBookFriendPhone;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (nonatomic , retain)NSDictionary      *contact;

- (IBAction)inviteAction:(UIButton *)sender;
@end
