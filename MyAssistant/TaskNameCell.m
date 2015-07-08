//
//  TaskNameCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/19.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "TaskNameCell.h"

@implementation TaskNameCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageFrame:(MessageFrame *)messageFrame
{
    if (_messageFrame != messageFrame) {
        _messageFrame = messageFrame ;
    }
    Task *taskModel = _messageFrame.task ;
    //任务名称
    self.taskNameLabel.text = taskModel.taskName;
    //完成时间
    [self.taskCompeletionTimeButton setTitle:[Tool stringFromFomate:taskModel.taskEndTime formate:@"MM-dd"] forState:UIControlStateNormal];
    //检查项
    //[self.checkButton setTitle:[NSString stringWithFormat:@"%@" , taskModel.checkNumber ] forState:UIControlStateNormal];
    //评论数
    [self.commentButton setTitle:[NSString stringWithFormat:@"%d" , (int)taskModel.comments.count ] forState:UIControlStateNormal];
    //任务描述
    self.TaskNoteLabel.text = taskModel.taskDescribe ;
    //附件
    [self.annexCount setTitle:@([taskModel.annexs count]).stringValue forState:UIControlStateNormal];
    self.desLabelHeight.constant = _messageFrame.describeHeight - 55 ;
}
@end
