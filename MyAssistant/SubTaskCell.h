//
//  SubTaskCellTableViewCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/8.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSquareProgressBar.h"

@class  Task ,SubTask;
@protocol SubTaskCellDelegate <NSObject>

- (void)setSubTaskState:(BOOL)isFininsh index:(NSInteger)index;

@end

@interface SubTaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *subTaskName;
@property (weak, nonatomic) IBOutlet UILabel *subTaskExecutor;
@property (weak, nonatomic) IBOutlet MSquareProgressBar *subtaskProgress;
@property (weak, nonatomic) IBOutlet UILabel *subTaskEndTime;
@property (nonatomic , assign)id<SubTaskCellDelegate>delegate ;

- (void)configureCellWithTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath subTaskModel:(SubTask*)subTask ;

- (IBAction)selectButtonAction:(UIButton *)sender;

@end
