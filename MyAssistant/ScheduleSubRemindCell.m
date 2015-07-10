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
    SubRemind *subRemind = [scheduleModel.subReminds allObjects][indexPath.row];
    
    NSArray *arr = @[@"tixing1" , @"tixing2" , @"tixing3"];
    self.cellImageView.image = [UIImage imageNamed:arr[indexPath.row]];
    
    NSString *remindtime = [Tool stringFromFomate:subRemind.subRemindTime formate:@"HH:mm"];
    NSString *remindType = [subRemind.subRemindType stringValue];
    self.cellTextLabel.text = [NSString stringWithFormat:@"%@     %@" , remindtime , remindType];
    
}
@end
