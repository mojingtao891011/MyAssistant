//
//  AddScheduleCellStyle2.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"

@interface AddScheduleTimeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *startDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *endDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UISwitch *rimindSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

- (IBAction)switchAction:(UISwitch *)sender;

- (void)configureCellWith:(UITableView*)tableView  indexPath:(NSIndexPath*)indexPath scheduleModel:(Schedule*)scheduleModel;

@end
