//
//  TaskListController.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/21.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "TaskStateListController.h"

@interface TaskStateListController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;



@end

@implementation TaskStateListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self selectedTaskList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - private Funs
- (void)selectedTaskList
{
    if ([self.curTaskState isEqualToString:@"要做"]) {
        self.imageView1.hidden = NO ;
        self.imageView2.hidden = YES ;
        self.imageView3.hidden = YES ;
    }
    else if ([self.curTaskState isEqualToString:@"在做"]) {
        self.imageView1.hidden = YES ;
        self.imageView2.hidden = NO ;
        self.imageView3.hidden = YES ;
    }
    else if ([self.curTaskState isEqualToString:@"待定"]) {
        self.imageView1.hidden = YES ;
        self.imageView2.hidden = YES ;
        self.imageView3.hidden = NO ;
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *arr = @[@"要做" , @"在做" , @"待定"];
    
    if (_taskListControllerDelegate && [_taskListControllerDelegate respondsToSelector:@selector(selectedTaskState:)]) {
        [_taskListControllerDelegate selectedTaskState:arr[indexPath.row]];
    }
    
    if (indexPath.row == 0) {
        self.imageView1.hidden = NO ;
        self.imageView2.hidden = YES ;
        self.imageView3.hidden = YES ;
    }
    else if (indexPath.row == 1){
        self.imageView1.hidden = YES ;
        self.imageView2.hidden = NO ;
        self.imageView3.hidden = YES ;
    }
    else if (indexPath.row == 2){
        self.imageView1.hidden = YES ;
        self.imageView2.hidden = YES ;
        self.imageView3.hidden = NO ;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
