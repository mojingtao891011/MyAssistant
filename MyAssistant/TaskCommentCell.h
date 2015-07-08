//
//  CommentCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/6/19.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageFrame.h"

@interface TaskCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *commentUserImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentHeight;

@property (nonatomic , retain)MessageFrame      *messageFrame ;

@end
