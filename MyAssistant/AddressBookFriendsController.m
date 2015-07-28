//
//  AddressBookFriendsController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/28.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "AddressBookFriendsController.h"
#import "AddressBookFriendCell1.h"
#import "AddressBookFriendCell2.h"
#import "KTSContactsManager.h"

@interface AddressBookFriendsController ()<UITableViewDataSource , UITableViewDelegate , KTSContactsManagerDelegate>

@property (nonatomic , retain)NSArray *tableData;
@property (strong, nonatomic) KTSContactsManager *contactsManager;
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@end

@implementation AddressBookFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contactsManager = [KTSContactsManager sharedManager];
    self.contactsManager.delegate = self;
    self.contactsManager.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES] ];
    [self loadData];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - model
- (void)loadData
{
    [self.contactsManager importContacts:^(NSArray *contacts)
     {
         self.tableData = contacts;
         [self.tableView reloadData];
          
     }];
}
#pragma mark - KTSContactsManagerDelegate
-(void)addressBookDidChange
{
    [self loadData];
}
-(BOOL)filterToContact:(NSDictionary *)contact
{
    return YES;
    return ![contact[@"company"] isEqualToString:@""];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5 ;
    }
    return self.tableData.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        AddressBookFriendCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressBookFriendCell1" forIndexPath:indexPath];
        return cell ;
    }
    
    AddressBookFriendCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressBookFriendCell2" forIndexPath:indexPath];
    cell.inviteButton.tag = indexPath.row ;
    cell.contact=  [self.tableData objectAtIndex:indexPath.row];
    return cell ;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50.0;
    }
    
    return 44.0 ;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableCellWithIdentifier:@"headerView"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"headerView"];
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, 150, 20)];
        headerLabel.textColor = [UIColor grayColor];
        headerLabel.font = [UIFont systemFontOfSize:10.0];
        headerLabel.tag = 1 ;
        [headerView addSubview:headerLabel];
    }
    
    NSArray *arr = @[@"5个好友待添加" ,[NSString stringWithFormat:@"%d个好友可邀请",(int)self.tableData.count]];
    UILabel *label = (UILabel*)[headerView viewWithTag:1];
    label.text = arr[section];
    return headerView ;
}
@end
