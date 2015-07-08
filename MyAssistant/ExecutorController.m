//
//  ExecutorController.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/21.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "ExecutorController.h"
#import "CoreDataStack.h"
#import "ExecutorCell.h"
#import "User.h"
#import "CoreDataModelService.h"

@interface ExecutorController ()<UITableViewDataSource , UITableViewDelegate , NSFetchedResultsControllerDelegate>
{
    User                                     *_receiveUser ;            //保存传过来的用户
    NSMutableArray              *_receiveFollowers ; //保存传过来的关注用户
}
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic , retain)NSFetchedResultsController        *fetchedResultsController ;
@property (nonatomic , retain)NSManagedObjectContext        *context ;
@property (nonatomic , retain)NSIndexPath             *selectedIndexPath ;
@property (nonatomic , retain)NSIndexPath             *lastselectedIndexPath ;

@end

@implementation ExecutorController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [CoreDataStack shareManaged].managedObjectContext ;
    
    _receiveUser = self.executorUser ;
    _receiveFollowers = [_follows mutableCopy];
    
    [self loadData];
    
    if (!self.follows) {
         self.follows = [NSMutableArray arrayWithCapacity:5];
    }
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.selectFollowersBlock && ![_follows isEqualToArray:_receiveFollowers]) {
        self.selectFollowersBlock(_follows);
    }
    
    if (self.selectExecutorBlock && ![_executorUser isEqual:_receiveUser]) {
        self.selectExecutorBlock(_executorUser);
    }
}
#pragma mark - private Funs
//加载假数据
- (void)loadData
{
    BOOL first = [[NSUserDefaults standardUserDefaults] boolForKey:@"first"];
    
    if (!first) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.context];
        
        NSArray *arr = @[@"Ricky" , @"Teddy" , @"Gary"];
        for (int i = 0 ; i < 3; i++) {
            User *user =[[ User alloc]initWithEntity:entity insertIntoManagedObjectContext:self.context];
            user.userName = arr[i];//[NSString stringWithFormat:@"%@%d" , [UIDevice currentDevice].name , i];
            switch (i) {
                case 0:
                    user.userMail = @"245891752@qq.com";
                    break;
                case 1:
                    user.userMail = @"371746111@qq.com";
                    break;
                case 2:
                    user.userMail = @"AppID_lierda@lierda.com";
                    break;
                    
                default:
                    break;
            }
            
            NSError *error = nil ;
            
            if (![self.context save:&error]) {
                NSLog(@"add user fail");
            }
        }

    }
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"first"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
}
- (void)setSelectRowState:(NSIndexPath*)indexPath
{
    
    if (_lastselectedIndexPath) {
        ExecutorCell *lastCell = (ExecutorCell*)[self.tableView cellForRowAtIndexPath:_lastselectedIndexPath];
        if ([_lastselectedIndexPath isEqual:indexPath]) {
            
            lastCell.selectedStateImg.hidden =  !lastCell.selectedStateImg.hidden ;
        }
        else{
            lastCell.selectedStateImg.hidden = YES ;
            
            ExecutorCell *curCell = (ExecutorCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            curCell.selectedStateImg.hidden  = NO ;
        }
        
    }
    else{
        ExecutorCell *curCell = (ExecutorCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        curCell.selectedStateImg.hidden  = NO ;
    }
    _lastselectedIndexPath = indexPath ;
    self.selectedIndexPath = indexPath ;
}

- (void)selectExecutor:(NSIndexPath*)indexPath
{
    [self setSelectRowState:indexPath];
    
    self.executorUser = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
}
- (void)selectFollowers:(NSIndexPath*)indexPath
{
    ExecutorCell *cell = (ExecutorCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.selectedStateImg.hidden = !cell.selectedStateImg.hidden ;
    
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (cell.selectedStateImg.hidden) {
        
         if ([_follows containsObject:user]) {
            [_follows removeObject:user];
        }
    }
    else {
        [_follows addObject:user];
    }
    
}
- (void)configureExecutorCell:(ExecutorCell*)cell indexPath:(NSIndexPath*)indexPath
{
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.userName.text = user.userName ;
    cell.userMailLabel.text = user.userMail ;
    if ([indexPath isEqual:self.selectedIndexPath]) {
        cell.selectedStateImg.hidden = NO ;
    }
    else{
         cell.selectedStateImg.hidden = YES ;
    }
    
    if ([_follows containsObject:user]) {
        cell.selectedStateImg.hidden = NO ;
    }
    
    if ([self.executorUser isEqual:user]) {
        cell.selectedStateImg.hidden = NO ;
        _lastselectedIndexPath = indexPath ;
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sections].count ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo>sectionInfo = [self.fetchedResultsController sections][section];
    
    return [sectionInfo numberOfObjects];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExecutorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExecutorCell" forIndexPath:indexPath];
    
    [self configureExecutorCell:cell indexPath:indexPath];
    
    return cell ;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectExecutorBlock) {
         [self selectExecutor:indexPath];
    }
   
    if (self.selectFollowersBlock) {
        [self selectFollowers:indexPath];
    }
    
   
    
}
#pragma mark - NSFetchedResultsControllerDelegate
- (NSFetchedResultsController*)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController ;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entityDescription];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"userName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
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
            ExecutorCell *cell = (ExecutorCell*)[self.tableView cellForRowAtIndexPath:indexPath] ;
            [self configureExecutorCell:cell indexPath:indexPath];
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
