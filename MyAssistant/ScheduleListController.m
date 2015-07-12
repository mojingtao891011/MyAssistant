//
//  ScheduleViewController.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/19.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "ScheduleListController.h"
#import "ScheduleCell.h"
#import "CoreDataStack.h"
#import "Schedule.h"
#import "ScheduleDetailController.h"
#import "NSDate+Utilities.h"

@interface ScheduleListController ()<UITableViewDelegate , UITableViewDataSource , NSFetchedResultsControllerDelegate>

@property (nonatomic , retain)NSFetchedResultsController        *fetchedResultsController ;
@property (nonatomic , retain)NSManagedObjectContext        *context ;
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic , retain) ScheduleDetailController *scheduleDetailCtl ;

@end

@implementation ScheduleListController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.context = [CoreDataStack shareManaged].managedObjectContext ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - private Funs
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    self.scheduleDetailCtl = segue.destinationViewController ;
   
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sections].count ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo>sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects] ;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleCell *scheduleCell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCell" forIndexPath:indexPath];
    [self configureScheduleCell:scheduleCell indexPath:indexPath];
    return scheduleCell ;
}
#pragma mark - UITableViewDelegate
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   // id<NSFetchedResultsSectionInfo>sectionInfo = [self.fetchedResultsController sections][section];
    
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:0 inSection:section];
    Schedule *schedule = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *sectionName = [NSString stringWithFormat:@"%@        %@" ,[Tool stringFromFomate:schedule.scheduleTheDay  formate:@"MM-dd"],[Tool  curDateOfWeek:schedule.scheduleTheDay] ];
    
    return sectionName;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Schedule *scheduleModel = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.scheduleDetailCtl.scheduleModel = scheduleModel ;
}
- (void)configureScheduleCell:(ScheduleCell*)cell indexPath:(NSIndexPath*)indexPath
{
    Schedule *scheduleModel = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.scheduleTimeLabel.text = [Tool stringFromFomate:scheduleModel.scheduleTheDay formate:@"MM-dd"];
    cell.scheduleTitleLabel.text = scheduleModel.scheduleName ;
}
#pragma mark - NSFetchedResultsControllerDelegate
- (NSFetchedResultsController*)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController ;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"scheduleTheDay" ascending:NO];
    NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:@"scheduleCreatTime" ascending:NO];
    [fetchRequest setSortDescriptors:@[sort1 , sort2]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *afetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:@"scheduleTheDay" cacheName:nil];
    afetchedResultsController.delegate = self ;
    self.fetchedResultsController = afetchedResultsController ;
    
    if (![self.fetchedResultsController performFetch:nil]) {
        NSLog(@"fetchedResultsController schedule fail");
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
            ScheduleCell *cell = (ScheduleCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            [self configureScheduleCell:cell indexPath:indexPath];
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
