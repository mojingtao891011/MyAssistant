//
//  AddFriendsOneCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/28.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "AddFriendsOneCell.h"

@implementation AddFriendsOneCell

- (void)awakeFromNib {
    
    self.buttonWidthConstraint.constant = (SCREEN_WIDTH - 74 )/3 ;
    _searchBar.delegate = self;
   
    self.AddQQFriendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [_searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@" , searchText);
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}
@end
