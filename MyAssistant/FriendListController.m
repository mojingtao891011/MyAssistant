//
//  AFriendListController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/29.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "FriendListController.h"
#import "FriendListCell1.h"
#import "FriendListCell2.h"
#import "FriendListCell3.h"
#import "FriendListCell4.h"
#import "User.h"
#import "NSString+PinYin.h"
#import "PinYin4Objc.h"

@interface FriendListController ()<UITableViewDataSource , UITableViewDelegate , NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@property (nonatomic , retain)NSManagedObjectContext        *context;
@property (nonatomic , retain)NSFetchedResultsController         *fetchedResultsController;
@property (nonatomic , retain)NSMutableArray                                *selectedFriends ;

@end

@implementation FriendListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [CoreDataStack shareManaged].managedObjectContext;
    
     //[self creatFriends];
    [self loadDataSource];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Model
- (void)loadDataSource
{
    User *user = [CoreDataModelService fetchUserByName:USER_ID];
    self.colletionDataSources = [NSMutableArray arrayWithArray:[user.friends allObjects]];
   // self.colletionDataSources = [NSMutableArray arrayWithArray:[[user.friends allObjects] arrayWithPinYinFirstLetterFormat]];
    
    [self.tableView reloadData];
}
#pragma mark - Private
- (void)backAction
{
    if (self.selectedFriendBlock && self.selectedFriends) {
        self.selectedFriendBlock(self.selectedFriends);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2 ;
    }

    return _colletionDataSources.count ;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            FriendListCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendListCell4" forIndexPath:indexPath];
            return cell ;
        }
        else if (indexPath.row == 1){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendListCell2" forIndexPath:indexPath];
            return cell ;
        }
    }
    
    FriendListCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendListCell3" forIndexPath:indexPath];
    [self configureCell:cell indexPath:indexPath];
    return cell ;
}
- (void)configureCell:(FriendListCell3*)cell indexPath:(NSIndexPath*)indexPath
{
    User *friendModel = _colletionDataSources[indexPath.row];
    cell.friendNameLabel.text = friendModel.userName ;
    cell.friendImage.image = [UIImage imageWithData:friendModel.userImg];
    if ([_selectedFriends containsObject:friendModel]) {
        cell.radioImageView.highlighted = YES ;
    }
    else{
        cell.radioImageView.highlighted = NO ;
    }
}
#pragma mark - UITableDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    else if (indexPath.section == 1) {
        
        User *friendModel = _colletionDataSources[indexPath.row];

        if (!_selectedFriends) {
            _selectedFriends = [NSMutableArray arrayWithCapacity:10];
        }
        
        if (_isExecutor) {
            if ([_selectedFriends containsObject:friendModel]) {
                [_selectedFriends removeObject:friendModel];
            }
            else{
                if (_selectedFriends.count != 0) {
                    [_selectedFriends replaceObjectAtIndex:0 withObject:friendModel];
                }
                else{
                    [_selectedFriends addObject:friendModel];
                }
            }
        }
        else{
            if ([_selectedFriends containsObject:friendModel]) {
                [_selectedFriends removeObject:friendModel];
            }
            else{
                [_selectedFriends addObject:friendModel];
            }
        }

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTE_REFRESH_COLLECTIONVIEW object:_selectedFriends userInfo:nil];
        });
        
        [tableView reloadData];
    }
   
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableCellWithIdentifier:@"headerView"];
        if (!headerView) {
            headerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"headerView"];
            UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
            headerLabel.font = [UIFont systemFontOfSize:10.0];
            headerLabel.tag = 1;
            [headerView addSubview:headerLabel];
        }
        
        UILabel *label = (UILabel*)[headerView viewWithTag:1];
        label.text = @"hello";
        return headerView ;
        
    }
    
    return nil ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0 ;
    }
    
    return 22.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 60.0 ;
    }
    
    return 44.0 ;
}

@end
