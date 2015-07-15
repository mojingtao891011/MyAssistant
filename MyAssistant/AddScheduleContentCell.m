//
//  AddScheduleCellStyle3.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "AddScheduleContentCell.h"
#import "User.h"

@implementation AddScheduleContentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath scheduleModel:(Schedule *)scheduleModel
{
    if (indexPath.section == 0) {
        if (indexPath.row < 4) {
            NSArray *arr = @[@"zidingyitixing" , @"chongfu"];
            NSString *remindTime = nil ;
            if (scheduleModel.scheduleRemindType) {
                remindTime = scheduleModel.scheduleRemindType ;
            }
            else{
                 remindTime = [Tool stringFromFomate:scheduleModel.scheduleRemindTime formate:@"MM-dd HH:mm"];
            }
            NSArray*arr1 = @[@"提醒", @"重复"];
            UIImage *image = [UIImage imageNamed:arr[indexPath.row - 2]];
            self.cellImageView.image = image ;
            self.cellTextLabel.text = arr1[indexPath.row - 2];
            self.cellSubTextLabel.text = remindTime;
            
            if (indexPath.row == 3) {
                self.cellSubTextLabel.text = scheduleModel.schedulerepeat.stringValue ;
                NSInteger selectedIndex = scheduleModel.schedulerepeat.integerValue ;
                switch (selectedIndex) {
                    case 0:
                        self.cellSubTextLabel.text = @"永不";
                        break;
                    case 1:
                        self.cellSubTextLabel.text = @"每日重复";
                        break;
                    case 2:
                        self.cellSubTextLabel.text = @"每周重复";
                        break;
                    case 3:
                        self.cellSubTextLabel.text = @"每月重复";
                        break;
                    case 4:
                        self.cellSubTextLabel.text = @"每年重复";
                        break;
                        
                    default:
                        break;
                }

            }
        }
        
    }
    else if (indexPath.section == 1){
        self.cellImageView.image = [UIImage imageNamed:@"canyuzhe"] ;
        self.cellTextLabel.text = @"参与者";
        
        NSMutableString *appStr = [NSMutableString new];
        for (User *user in [scheduleModel.scheduleFollowers  allObjects]) {
            [appStr appendFormat:@" %@" , user.userName];
        }
        self.cellSubTextLabel.text = appStr ;
    }
    else if (indexPath.section == 2){
        self.cellImageView.image = [UIImage imageNamed:@"ico_weizhi"] ;
        self.cellTextLabel.text = @"地点";
        self.cellSubTextLabel.text = scheduleModel.scheduleAddress ;
    }
    else if (indexPath.section == 3 ){
        self.cellImageView.image = [UIImage imageNamed:@"fujian"] ;
        self.cellTextLabel.text = @"附件";
        self.cellSubTextLabel.text = [NSString stringWithFormat:@"%d", (int)scheduleModel.annexs.count];
    }
}
@end
