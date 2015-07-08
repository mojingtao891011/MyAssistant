//
//  TestAddTaskThreeCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/5.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"


@interface TaskDetailTagCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;

- (void)configureCellWithTable:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath taskModel:(Task*)taskModel ;

@end
