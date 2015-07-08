//
//  ContentCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/6/19.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface TaskContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (nonatomic , retain)Task              *taskModel ;
@property (nonatomic , retain)Task              *taskModel1 ;

@end
