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
        
        if (indexPath.row == 3 + scheduleModel.subReminds.count - 1) {
            self.cellImageView.image = [UIImage imageNamed:@"chongfu"];
            self.cellTextLabel.text = @"重复";
            
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
                    self.cellSubTextLabel.text = @"每工作日重复";
                    break;
                case 3:
                    self.cellSubTextLabel.text = @"每周末重复";
                    break;
                case 4:
                    self.cellSubTextLabel.text = @"每月重复";
                    break;
                case 5:
                    self.cellSubTextLabel.text = @"每年重复";
                    break;
                case 6:
                    self.cellSubTextLabel.text = @"自定义";
                    break;
                default:
                    break;
            }

        }
        else{
            
             SubRemind *subRemind = [CoreDataModelService fetchSubRemindBySubRemindNumber:indexPath.row-2 schedule:scheduleModel];
            
            if (scheduleModel.subReminds.count > 1) {
                NSArray *imgNameArr = @[@"tixing1" , @"tixing2" , @"tixing3"];
                NSArray *titleArr = @[@"提醒" , @"第二次提醒" , @"第三次提醒"];
                
                self.cellImageView.image = [UIImage imageNamed:imgNameArr[indexPath.row - 2]];
                self.cellTextLabel.text = titleArr[indexPath.row - 2];
                
                NSString *remindType = nil ;
                if (subRemind.subRemindType) {
                    remindType = subRemind.subRemindType ;
                }
                else{
                    remindType = [Tool stringFromFomate:subRemind.subRemindTime formate:@"MM-dd HH:mm"];
                }
                
                 self.cellSubTextLabel.text = remindType ;
                
            }
            else
            {
                NSString *remindType = nil ;
                if (subRemind.subRemindType) {
                    remindType = subRemind.subRemindType ;
                }
                else{
                    if (subRemind.subRemindTime) {
                         remindType = [Tool stringFromFomate:subRemind.subRemindTime formate:@"MM-dd HH:mm"];
                    }
                    else{
                        remindType = @"无";
                    }
                }

                self.cellImageView.image = [UIImage imageNamed:@"zidingyitixing"];
                self.cellTextLabel.text = @"提醒";
                self.cellSubTextLabel.text = remindType ;
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
