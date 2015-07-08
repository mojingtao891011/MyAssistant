//
//  CommentCell.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/19.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "TaskCommentCell.h"
#import "Comment.h"
#import "User.h"

@implementation TaskCommentCell

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
    
    NSArray *comments = [_messageFrame.task.comments allObjects];
    
    NSSortDescriptor *sortTime = [NSSortDescriptor sortDescriptorWithKey:@"commentContentTime" ascending:YES];
    NSArray *sortArr = [comments sortedArrayUsingDescriptors:@[sortTime]];
    
    Comment *comment = sortArr[self.tag - 1];
    
    self.commentContentLabel.text = comment.commentContent ;
    
    self.commentTimeLabel.text = [Tool stringFromFomate:comment.commentContentTime formate:@"MM-dd HH:mm"];
    self.userNameLabel.text = comment.user.userName ;
    self.commentHeight.constant = [_messageFrame.commentHeightArr[self.tag - 1] floatValue] - 40;
}
@end
