//
//  BaseTableController.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/26.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseTableController.h"

@interface BaseTableController ()

@property (nonatomic , retain)UIButton *leftButton;
@property (nonatomic , retain)UIButton *rightButton;

@end

@implementation BaseTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self leftBarButton:@"back"];
    
    [self rightBarButton:@"ico_queding"];
    
    self.isHidenRightButton = YES ;
    self.isHidenLeftButton = NO ;
    
    if (self.tableView.style == UITableViewStyleGrouped) {
        self.tableView.contentInset = UIEdgeInsetsMake(-22, 0, 0, 0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Funs
- (void)leftBarButton:(NSString*)imageName
{
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setFrame:CGRectMake(0, 0, 40, 40)];
    [self.leftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    self.leftButton.hidden = self.isHidenLeftButton ;
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem =  leftBarButton;
}
- (void)rightBarButton:(NSString*)imageName
{
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setFrame:CGRectMake(0, 0, 40, 40)];
    [self.rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.hidden = self.isHidenRightButton ;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem =  rightBarButton;
}
#pragma mark - Action
- (void)leftAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightAction
{
    
}

@synthesize leftButtonImageName = _leftButtonImageName ;
@synthesize rightButtonImageName = _rightButtonImageName ;
@synthesize isHidenRightButton = _isHidenRightButton ;
@synthesize isHidenLeftButton = _isHidenLeftButton ;

- (void)setLeftButtonImageName:(NSString *)leftButtonImageName
{
    if (_leftButtonImageName != leftButtonImageName) {
        _leftButtonImageName = leftButtonImageName ;
    }
    [self.leftButton setImage:[UIImage imageNamed:leftButtonImageName] forState:UIControlStateNormal];
}
- (void)setRightButtonImageName:(NSString *)rightButtonImageName
{
    if (_rightButtonImageName != rightButtonImageName) {
        _rightButtonImageName = rightButtonImageName ;
    }
    [self.rightButton setImage:[UIImage imageNamed:rightButtonImageName] forState:UIControlStateNormal];
}
-(void)setIsHidenRightButton:(BOOL)isShowRightButton
{
    if (_isHidenRightButton != isShowRightButton) {
        _isHidenRightButton = isShowRightButton ;
    }
    
    self.rightButton.hidden = _isHidenRightButton ;
}
- (void)setIsHidenLeftButton:(BOOL)isHidenLeftButton
{
    if (_isHidenLeftButton != isHidenLeftButton) {
        _isHidenLeftButton = isHidenLeftButton ;
    }
    
    self.leftButton.hidden = isHidenLeftButton ;
}
- (id)fetchViewControllerByIdentifier:(NSString*)Identifier
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    id viewCtl = [mainStoryboard instantiateViewControllerWithIdentifier:Identifier];
    
    return viewCtl ;
}

@end
