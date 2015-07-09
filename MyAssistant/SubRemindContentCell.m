//
//  SubRemindCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/9.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "SubRemindContentCell.h"
#import "SubRemind.h"

@implementation SubRemindContentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWithIndexPath:(NSIndexPath*)indexPath scheduleModel:(Schedule*)scheduleModel
{
    SubRemind *subRemindModel = [scheduleModel.subReminds allObjects][indexPath.row-4];
    NSArray *arr = @[@"tixing1" , @"tixing2" ,@"tixing3"];
    self.cellImageView.image = [UIImage imageNamed:arr[indexPath.row - 4]];
    NSString *dateStr = [Tool stringFromFomate:subRemindModel.subRemindTime formate:@"HH:mm"];
    NSString *remindTypeStr ;
    switch (subRemindModel.subRemindType.integerValue) {
        case 0:
            remindTypeStr = @"永不";
            break;
        case 1:
             remindTypeStr = @"每日重复";
            break;
        case 2:
             remindTypeStr = @"每周重复";
            break;
        case 3:
             remindTypeStr = @"每月重复";
            break;
        case 4:
             remindTypeStr = @"每年重复";
            break;
            
        default:
            break;
    }
    self.cellTextLabel.text = [NSString stringWithFormat:@"%@     %@" ,dateStr  , remindTypeStr];
}
@end
