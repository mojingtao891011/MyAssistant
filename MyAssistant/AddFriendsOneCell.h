//
//  AddFriendsOneCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/28.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendsOneCell : UITableViewCell<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *AddQQFriendButton;

@end
