//
//  FollowersCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/16.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "FollowersCell.h"

@implementation FollowersCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath userModel:(User *)userModel
{
    self.userNameLabel.text = userModel.userName ;
}
@end
