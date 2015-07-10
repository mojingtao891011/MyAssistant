//
//  ScheduleSubRemindCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/10.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"

@interface ScheduleSubRemindCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellTextLabel;
@property (weak, nonatomic) IBOutlet UISwitch *cellSwitch;

- (void)configureCellWithIndexPath:(NSIndexPath*)indexPath scheduleModel:(Schedule *)scheduleModel ;

@end
