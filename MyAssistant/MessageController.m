//
//  MessageViewController.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/18.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "MessageController.h"
#import "TabBarViewController.h"


@interface MessageController ()<UITableViewDataSource , UITableViewDelegate>


@end

@implementation MessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftBarButtonItem];
    
    
}
#pragma mark - DefaultUI
- (void)addLeftBarButtonItem
{
    //leftBarButtonItem
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 40, 35)];
    leftButton.tag = 2 ;
    [leftButton setImage:[UIImage imageNamed:@"icon_self"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton ;

}
#pragma mark - Action
- (void)leftBarButtonItemAction:(UIButton*)sender
{
    
    TabBarViewController *taBarCtl = (TabBarViewController*)self.tabBarController ;
    [taBarCtl selectleViewController:sender];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2 ;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    
    return cell ;
}
@end
