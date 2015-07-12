//
//  ScheduleSubRemindCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/10.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "ScheduleSubRemindCell.h"
#import "SubRemind.h"

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
    
    if (indexPath.row == 0) {
        self.cellImageView.image = [UIImage imageNamed:@"zidingyitixing"];
        self.cellTextLabel.text = @"正点提醒";
        if (scheduleModel.scheduleRemindTime) {
            NSString *remindtime = [Tool stringFromFomate:scheduleModel.scheduleRemindTime formate:@"HH:mm"];
             self.cellTextLabel.text = [NSString stringWithFormat:@"%@     %@" , remindtime , [self remindType:scheduleModel.schedulerepeat]];
        }
    }
    else{
        SubRemind *subRemind = [scheduleModel.subReminds allObjects][indexPath.row - 1];
        
        NSArray *arr = @[@"tixing1" , @"tixing2" , @"tixing3"];
        self.cellImageView.image = [UIImage imageNamed:arr[indexPath.row - 1]];
        
        NSString *remindtime = [Tool stringFromFomate:subRemind.subRemindTime formate:@"HH:mm"];
       
        self.cellTextLabel.text = [NSString stringWithFormat:@"%@     %@" , remindtime , [self remindType:subRemind.subRemindType]];
    }
    
}
- (NSString*)remindType:(NSNumber*)remindType
{
    NSString *remindString = nil ;
    switch (remindType.integerValue) {
        case 0:
            remindString = @"永不";
            break;
        case 1:
            remindString = @"每日重复";
            break;
        case 2:
            remindString = @"每周重复";
            break;
        case 3:
            remindString = @"每月重复";
            break;
        case 4:
            remindString = @"每年重复";
            break;
            
        default:
            break;
    }
    
    return remindString ;
}
@end
