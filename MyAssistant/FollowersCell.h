//
//  FollowersCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/16.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface FollowersCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellSubTextLabel;


- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath userModel:(User *)userModel ;
@end
