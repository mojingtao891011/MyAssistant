//
//  FriendListController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/13.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "FriendListController.h"
#import "User.h"
#import "FriendCell.h"
#import "AddressBookController.h"


@interface FriendListController ()<UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , UITableViewDataSource ,UITableViewDelegate , UITextFieldDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *colletionView;

@property (nonatomic , retain)NSFetchedResultsController        *fetchedResultsController ;
@property (nonatomic , retain)NSManagedObjectContext       *context ;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *telTextField;

@end

@implementation FriendListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.colletionDataSources == nil) {
         self.colletionDataSources = [NSMutableArray arrayWithCapacity:5];
    }
   
    self.context = [CoreDataStack shareManaged].managedObjectContext ;
}

#pragma mark - Action

- (void)backAction
{
    if (self.selectedFriendBlock) {
        self.selectedFriendBlock(self.colletionDataSources);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemAction:(UIButton*)sender
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushAddressBookCtlSegue"]) {
        AddressBookController *addressBookCtl = segue.destinationViewController;
        addressBookCtl.SelectedTelBlock = ^(NSMutableArray *telArr){
            
        };
    }
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES ;
}
#pragma mark -UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _colletionDataSources.count + 1 ;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _colletionDataSources.count ) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"lastCollectionView" forIndexPath:indexPath];
        return cell ;
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionView" forIndexPath:indexPath];
    return cell ;
}
#pragma mark -UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _colletionDataSources.count) {
        return CGSizeMake(180, 40);
    }
    return CGSizeMake(30, 30);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 10, 1, 1);
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sections].count ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo>sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    [self configureCell:cell WithIndexPath:indexPath];
    return cell ;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    FriendCell *cell = (FriendCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.cellImageView.highlighted  = !cell.cellImageView.highlighted;
    
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (_isExecutor) {
        if ([_colletionDataSources containsObject:user]) {
            [_colletionDataSources removeObject:user];
        }
        else{
            if (_colletionDataSources.count != 0) {
                [_colletionDataSources replaceObjectAtIndex:0 withObject:user];
            }
            else{
                [_colletionDataSources addObject:user];
            }
        }
    }
    else{
        if ([_colletionDataSources containsObject:user]) {
            [_colletionDataSources removeObject:user];
        }
        else{
            [_colletionDataSources addObject:user];
        }

    }
    
    [self.colletionView reloadData];
    [self.tableView reloadData];
}

- (void)configureCell:(FriendCell*)cell WithIndexPath:(NSIndexPath*)indexPath
{
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.cellTextlabel.text = user.userName ;
    if ([_colletionDataSources containsObject:user]) {
        cell.cellImageView.highlighted = YES ;
    }
    else{
        cell.cellImageView.highlighted = NO ;
    }
}
#pragma mark - NSFetchedResultsControllerDelegate
- (NSFetchedResultsController*)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController ;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"userName" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *afetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
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
//            ScheduleCell *cell = (ScheduleCell*)[self.tableView cellForRowAtIndexPath:indexPath];
//            [self configureScheduleCell:cell indexPath:indexPath];
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
