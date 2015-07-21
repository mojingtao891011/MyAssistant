//
//  TestTaskListController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/17.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "TaskListController.h"
#import "BaseTableView.h"
#import "TaskListCell.h"
#import "User.h"
#import "TaskDetailsController.h"

@interface TaskListController ()<UIScrollViewDelegate , UITableViewDataSource , UITableViewDelegate , NSFetchedResultsControllerDelegate>

@property (nonatomic , retain)NSFetchedResultsController        *fetchedResultsController ;
@property (nonatomic , retain)NSManagedObjectContext        *context ;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic , retain)NSMutableArray         *tableViews ;
@property (weak, nonatomic) IBOutlet UIButton *defauleSelectButton;
@property (weak, nonatomic) IBOutlet UIImageView *moveImageView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic , retain)UITableView       *curTableView ;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moveViewWidthConstraint;

@end

@implementation TaskListController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [CoreDataStack shareManaged].managedObjectContext ;
    
    [self _initTableView];
}
#pragma mark - UI
- (void)_initTableView
{
    self.buttonWidthConstraint.constant = SCREEN_WIDTH / 4 ;
    self.moveViewWidthConstraint.constant = SCREEN_WIDTH/4 ;
    
    _tableViews = [NSMutableArray arrayWithCapacity:4];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 4, SCREEN_HEIGHT - 64 - 35 );
    self.scrollView.delegate = self ;
    self.scrollView.scrollsToTop = YES ;
    
    for (int i = 0 ; i < 4; i++) {
        BaseTableView *tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(i * SCREEN_WIDTH , 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 35) style:UITableViewStyleGrouped];
        tableView.delegate = self ;
        tableView.dataSource = self ;
        tableView.tag = i+1 ;
        tableView.scrollsToTop = YES ;
       
        [tableView registerNib:[UINib nibWithNibName:@"TaskListCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
        
        [self.scrollView addSubview:tableView];
        [self.tableViews addObject:tableView];
        
        if (i == 0) {
            self.curTableView = tableView ;
        }
    }
}
#pragma mark - Private fun

- (IBAction)buttonAction:(UIButton *)sender {
    
    // 改变按钮标题颜色并滑动底部游标
    self.defauleSelectButton.selected = NO ;
    sender.selected = YES ;
    self.defauleSelectButton = sender ;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.moveImageView.left = sender.left ;
    }];

    //滑动到指定tableView
    NSInteger buttonTag = sender.tag - 1;
    [self.scrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH*buttonTag, self.scrollView.top, SCREEN_WIDTH, self.scrollView.height) animated:YES];
    
    //
    self.curTableView = self.tableViews[buttonTag];
    self.fetchedResultsController = nil ;
    [self.curTableView reloadData];
}
- (NSPredicate*)setPredicate:(UITableView*)tableView
{
    NSPredicate *predicate = nil ;
    switch (tableView.tag) {
        case 1:
            //全部任务
             predicate = [NSPredicate predicateWithFormat:@"taskName!=nil" ];
            break;
        case 2:
            //我创建
            predicate = [NSPredicate predicateWithFormat:@"creatTaskUser.userName == %@" , CUR_USER.userName];
            break;
        case 3:
            //与我有关
            predicate = [NSPredicate predicateWithFormat:@"followers CONTAINS %@ || executor.userName == %@" , CUR_USER , CUR_USER.userName];
            break;
        case 4:
            //已完成
            predicate = [NSPredicate predicateWithFormat:@"taskIsFininsh == %@" , [NSNumber numberWithBool:YES]];
            break;
            
        default:
            break;
    }
    
    return predicate ;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo>sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects] ;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TaskListCell*cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    [self configureCell:cell indexPath:indexPath];
    return cell ;
}
- (void)configureCell:(TaskListCell*)cell indexPath:(NSIndexPath*)indexPath
{
    [cell configurCellWithIndexPath:indexPath taskModel:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0 ;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    TaskDetailsController *taskDetailCtl = [self fetchViewControllerByIdentifier:@"TaskDetailsController"];
    taskDetailCtl.taskModel = task ;
    [self.navigationController pushViewController:taskDetailCtl animated:YES];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 滑动结束改变按钮标题颜色
    int index = scrollView.contentOffset.x / SCREEN_WIDTH ;
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return ;
    }

    self.defauleSelectButton.selected = NO ;
    UIButton *curButton = (UIButton*)[self.headerView viewWithTag:index+1];
    curButton.selected = YES ;
    self.defauleSelectButton = curButton ;
    
    //滑动停止后刷新tableView
    self.curTableView = self.tableViews[index];
    self.fetchedResultsController = nil ;
    [self.curTableView reloadData];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return ;
    }
    
    int move = scrollView.contentOffset.x  ;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.moveImageView.left = move/4 ;
    }];
    
    ;
}
#pragma mark - NSFetchedResultsControllerDelegate
- (NSFetchedResultsController*)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController ;
    }
   
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entityDescription];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"taskCreatTime" ascending:NO];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSPredicate *predicate = [self setPredicate:self.curTableView];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setFetchBatchSize:20];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self ;
    
    NSError *error = nil ;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"NSFetchedResultsController alloc fail");
        abort();
    }
    
    
    return _fetchedResultsController ;
}
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.curTableView beginUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.curTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation: UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.curTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation: UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            
            break;
        case NSFetchedResultsChangeUpdate:
            
            break;
            
        default:
            break;
    }
    
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.curTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.curTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.curTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
            [self.curTableView deleteRowsAtIndexPaths:@[newIndexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
        {
            TaskListCell *cell = (TaskListCell*)[self.curTableView cellForRowAtIndexPath:indexPath];
            [self configureCell:cell indexPath:indexPath];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.curTableView endUpdates];
}

@end
