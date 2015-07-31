//
//  ScheduleSubRemindCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/10.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "ScheduleSubRemindCell.h"
#import "Remind.h"

@implementation ScheduleSubRemindCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath scheduleModel:(Schedule *)scheduleModel
{
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"remindIndex" ascending:YES];
    NSArray *subReminds = [[scheduleModel.reminds allObjects] sortedArrayUsingDescriptors:@[sort]];
    
    Remind *subRemind =subReminds[indexPath.row];
    NSArray *arr = @[@"tixing1" , @"tixing2" , @"tixing3"];
    //NSArray *titleArr = @[@"提醒" , @"第二次提醒" , @"第三次提醒"];
    self.cellImageView.image = [UIImage imageNamed:arr[indexPath.row]];
    
    NSString *remindType = nil ;
    if (subRemind.remindType) {
        remindType = subRemind.remindType;
    }
    else{
        if (subRemind.remindTime) {
            remindType = [Tool stringFromFomate:subRemind.remindTime formate:@"MM-dd HH:mm"];
        }
        else{
            remindType = @"无";
        }
    }
    
    self.cellTextLabel.text = [NSString stringWithFormat:@"%@" , remindType];
    
}
@end
