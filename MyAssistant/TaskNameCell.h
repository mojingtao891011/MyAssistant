//
//  TaskNameCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/6/19.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "MessageFrame.h"

@interface TaskNameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *taskStautButton;
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *taskCompeletionTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *TaskNoteLabel;
@property (weak, nonatomic) IBOutlet UIButton *annexCount;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desLabelHeight;


@property (nonatomic , retain)MessageFrame      *messageFrame ;

@end
