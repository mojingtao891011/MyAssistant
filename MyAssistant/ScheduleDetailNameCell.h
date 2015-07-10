//
//  ScheduleDetailNameCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/10.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"

@interface ScheduleDetailNameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *scheduleName;
@property (weak, nonatomic) IBOutlet UILabel *scheduleTime;
@property (weak, nonatomic) IBOutlet UILabel *scheduleYear;
@property (weak, nonatomic) IBOutlet UILabel *scheduleAddress;

- (void)configureCellWithIndexPath:(NSIndexPath*)indexPath  scheduleModel:(Schedule*)scheduleModel ;

@end
