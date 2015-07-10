//
//  SceduleContentCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/10.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "ScheduleContentCell.h"
#import "User.h"

@implementation ScheduleContentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath scheduleModel:(Schedule *)scheduleModel
{
    if (indexPath.section == 1) {
        self.cellImageView.image = [UIImage imageNamed:@"canyuzhe"];
        self.cellTextLabel.text = [NSString stringWithFormat:@"参与者  %d位" , (int)scheduleModel.scheduleFollowers.count];
        
        NSMutableString *followerStr = [NSMutableString new];
        for (User *user in scheduleModel.scheduleFollowers) {
            [followerStr appendFormat:@"%@  ", user.userName];
        }
        
        self.cellSubTextLabel.text = followerStr ;
    }
    else if (indexPath.section == 3){
        self.cellImageView.image = [UIImage imageNamed:@"ico_fujian"];
        self.cellTextLabel.text = @"附件";
        self.cellSubTextLabel.text = [NSString stringWithFormat:@"%d", (int)scheduleModel.annexs.count];
    }
}
@end
