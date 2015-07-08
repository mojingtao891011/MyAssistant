//
//  TaskViewController.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/19.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "TaskListController.h"
#import "TaskCell.h"
#import "ScheduleCell.h"
#import "CoreDataStack.h"
#import "Task.h"
#import "TaskDetailsController.h"
#import "User.h"

@interface TaskListController ()<UITableViewDataSource , UITableViewDelegate , NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet BaseTableView                  *tableView;
@property (nonatomic , retain)NSFetchedResultsController        *fetchedResultsController ;
@property (nonatomic , retain)NSManagedObjectContext        *context ;
@property (nonatomic , retain)TaskDetailsController                     *detailsCtl ;

@end

@implementation TaskListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [CoreDataStack shareManaged].managedObjectContext ;
    
    [self managedAllNote];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   // self.fetchedResultsController.delegate = self ;
    
   
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //self.fetchedResultsController.delegate = nil ;
   
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PushTaskDetailsCtlSegue"]) {
        self.detailsCtl = segue.destinationViewController ;
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - ManagedAllNote
- (void)managedAllNote
{
     //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setFetchedResultsControllerDelegateNote:) name:NOTE_TASKCTL_SETDALEGATE object:nil];
    
}
- (void)setFetchedResultsControllerDelegateNote:(NSNotification*)note
{
    self.fetchedResultsController.delegate = self ;
}
#pragma mark - Private Fun
- (void)configureTaskCell:(TaskCell*)cell  indexPath:(NSIndexPath*)indexPath
{
   
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.taskName.text = task.taskName ;
    [cell.endTime setTitle:[Tool stringFromFomate:task.taskEndTime formate:@"MM-dd"] forState:UIControlStateNormal];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sections].count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo>sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects] ;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TaskCell *taskCell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
    [self configureTaskCell:taskCell indexPath:indexPath];
    return taskCell ;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo>sectionInfo = [self.fetchedResultsController sections][section];
    return sectionInfo.name;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.detailsCtl.taskModel = task ;
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
    
    

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"creatTaskUser.userName == %@" , CUR_USER.userName];
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
    [self.tableView beginUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation: UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation: UITableViewRowAnimationAutomatic];
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
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
            [self.tableView deleteRowsAtIndexPaths:@[newIndexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
        {
            TaskCell *cell = (TaskCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            [self configureTaskCell:cell indexPath:indexPath];
        }
            break;
            
        default:
            break;
    }

}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
