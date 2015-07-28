//
//  AddressBookFriendCell1.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/28.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressBookFriendCell1 : UITableViewCell<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *friendImages;
@property (weak, nonatomic) IBOutlet UILabel *friendNick;
@property (weak, nonatomic) IBOutlet UILabel *friendAddressBookName;
@property (weak, nonatomic) IBOutlet UIButton *addAddressBookFriendButton;

- (IBAction)addAddressBookFriendAction:(UIButton *)sender;

@end
