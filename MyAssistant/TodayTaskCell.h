//
//  TodayTaskCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/6/23.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRoundProgressBar.h"
#import "Task.h"

@interface TodayTaskCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *taskTagImageView;
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskEndtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskEndDayLabel;
@property (weak, nonatomic) IBOutlet MRoundProgressBar *taskStateView;

@property (nonatomic , retain)Task *myTask ;

@end
