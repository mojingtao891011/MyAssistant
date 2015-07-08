//
//  TaskDetailNameCellFrame.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/1.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "MessageFrame.h"
#import "Comment.h"


@implementation MessageFrame
@synthesize describeHeight = _describeHeight ;

@synthesize task = _task ;

- (void)setTask:(Task *)task
{
    if (_task != task) {
        _task = task ;
    }
    
    //
    CGSize size_des = [Tool calculateMessage:_task.taskDescribe fontOfSize:12.0 maxWidth:SCREEN_WIDTH - 73 maxHeight:MAXFLOAT];
    _describeHeight = 70 + size_des.height ;
    
    //
    NSSortDescriptor *sortTime = [NSSortDescriptor sortDescriptorWithKey:@"commentContentTime" ascending:YES];
    NSArray *sortArr = [_task.comments sortedArrayUsingDescriptors:@[sortTime]];
    
    for (Comment *comment in sortArr) {
        CGSize size_comment = [Tool calculateMessage:comment.commentContent fontOfSize:12.0 maxWidth:SCREEN_WIDTH - 90 maxHeight:MAXFLOAT];
        if (!_commentHeightArr) {
            _commentHeightArr = [NSMutableArray arrayWithCapacity:_task.comments.count];
        }
        NSNumber *commentHeight = [NSNumber numberWithFloat:size_comment.height + 50 ];
        [_commentHeightArr addObject:commentHeight];
    }
    
}
- (Task*)task
{
    return _task ;
}

@end
