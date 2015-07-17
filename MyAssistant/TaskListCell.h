//
//  TestCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/17.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRoundProgressBar.h"
#import "Task.h"

@interface TaskListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *taskStateImageView;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet MRoundProgressBar *taskProgressBar;

- (void)configurCellWithIndexPath:(NSIndexPath*)indexPath   taskModel:(Task*)taskModel ;

@end
