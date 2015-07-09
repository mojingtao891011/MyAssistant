//
//  TabBarViewController.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/18.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "TabBarViewController.h"
#import "BaseNavgationController.h"
#import "CHTumblrMenuView.h"
#import "AddTaskController.h"
#import "AddScheduleController.h"
#import "AddTaskController.h"

@interface TabBarViewController ()<UINavigationControllerDelegate>
{
    UIView      *_tabbarView ;
    NSMutableArray      *_buttons ;
    NSMutableArray      *_labels ;
    UIButton                    *_lastSelectedButton ;
    UILabel                      *_lastSelectedLabel ;
}
@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initViewController];
    
    [self CustomTabbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI
/**
 *  初始化ViewController
 */
- (void)_initViewController
{
    NSArray     *storyboardIDArr = @[@"TodayNavCtl" ,@"MessageNavCtl" , @"MeNavCtl" ];
    NSMutableArray     *viewControllerArr = [NSMutableArray arrayWithCapacity:3];
    
    for (NSString * storyboardID in storyboardIDArr) {
        BaseNavgationController *navCtl = [self fetchViewControllerWithIdentifier:storyboardID];
        [viewControllerArr addObject:navCtl];
    }
    
    self.viewControllers = viewControllerArr ;
    self.selectedIndex = 0 ;
}
/**
 *  自定义标签栏
 */
- (void)CustomTabbar
{
    _tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49 , SCREEN_WIDTH , 49)];
    _tabbarView.backgroundColor = [UIColor whiteColor];
    self.tabBar.hidden = YES ;
    [self.view addSubview:_tabbarView];
    
    UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineImageView.image = [UIImage imageNamed:@"line"];
    [_tabbarView addSubview:lineImageView];
    
    NSArray *imgStateNormalArr = @[@"jintian-no" , @"tianjia" ,@"xiaoxi-no" ] ;
    NSArray *imgStateSelectedArr = @[@"jintian"  , @"tianjia" ,@"xiaoxi"  ];
    NSArray *titleArr = @[@"今天" ,@"", @"消息" ];
    _buttons = [NSMutableArray arrayWithCapacity:5];
    _labels = [NSMutableArray arrayWithCapacity:5];
    
    for (int i = 0 ; i < imgStateNormalArr.count; i++) {
        
        //button
        UIButton *tabBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat w = SCREEN_WIDTH/imgStateSelectedArr.count ;
        
        [tabBarButton setFrame:CGRectMake( w*i , 5, w, 40)];
        tabBarButton.backgroundColor = [UIColor clearColor];
        tabBarButton.tintColor = [UIColor clearColor];
        [tabBarButton setImage:[UIImage imageNamed:imgStateNormalArr[i]] forState:UIControlStateNormal];
        [tabBarButton setImage:[UIImage imageNamed:imgStateSelectedArr[i]] forState:UIControlStateSelected];
        [_buttons addObject:tabBarButton];
        
        if (i == 1) {
            [tabBarButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            if (i==0) {
                tabBarButton.tag = 0 ;
            }
            else if (i == 2)
            {
                tabBarButton.tag = 1;
            }
            [tabBarButton addTarget:self action:@selector(selectleViewController:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [_tabbarView addSubview:tabBarButton];
        
        //label
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(w*i, 32, w, 20)];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.backgroundColor = [UIColor clearColor];
        label.text = titleArr[i];
        label.font = [UIFont systemFontOfSize:8.0];
        label.textColor = LIGHTGREY_FONT_COLOR ;
        [_labels addObject:label];
        [_tabbarView addSubview:label];
    }
    
    UIButton *button =  _buttons[self.selectedIndex] ;
    button.selected = YES ;
    _lastSelectedButton = button ;
    
    UILabel *label = _labels[self.selectedIndex];
    label.textColor = ORANGE_COLOR ;
    _lastSelectedLabel = label ;
    
}
/**
 *  选中更换ViewController
 *
 *  @param sender 选中的Button
 */
- (void)selectleViewController:(UIButton*)sender
{
    
    self.selectedIndex = sender.tag ;
    
    _lastSelectedButton.selected = NO ;
    sender.selected = YES ;
    _lastSelectedButton = sender ;
    
    _lastSelectedLabel.textColor = LIGHTGREY_FONT_COLOR ;
    UILabel *label = _labels[sender.tag];
    label.textColor = ORANGE_COLOR ;
    _lastSelectedLabel = label ;
    
    if (sender.tag == 2) {
        sender.selected = NO ;
        label.textColor = LIGHTGREY_FONT_COLOR ;
    }
}

- (void)showMenu
{
    
   
    WS(weakSelf);
    CHTumblrMenuView *menuView = [[CHTumblrMenuView alloc] init];
    [menuView addMenuItemWithTitle:@"添加任务" andIcon:[UIImage imageNamed:@"tianjiaricheng"] andSelectedBlock:^{
        NSLog(@"添加任务 selected");
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf presentController:0];
            
        });
    }];
    [menuView addMenuItemWithTitle:@"添加日程" andIcon:[UIImage imageNamed:@"tianjiarenwu"] andSelectedBlock:^{
        NSLog(@"添加日程 selected");
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf presentController:1];
            
        });
    }];
    [menuView addMenuItemWithTitle:@"添加文件" andIcon:[UIImage imageNamed:@"shangchuanwenjian"] andSelectedBlock:^{
        NSLog(@"添加文件 selected");
        
    }];
    [menuView addMenuItemWithTitle:@"开始扫描" andIcon:[UIImage imageNamed:@"kuaisusaomiao"] andSelectedBlock:^{
        NSLog(@"开始扫描 selected");
        
    }];
    [menuView addMenuItemWithTitle:@"添加好友" andIcon:[UIImage imageNamed:@"tianjiahaoyou"] andSelectedBlock:^{
        NSLog(@"点击分享 selected");
        
    }];
    [menuView addMenuItemWithTitle:@"添加视频" andIcon:[UIImage imageNamed:@"tianjiarenwu"] andSelectedBlock:^{
        NSLog(@"Video selected");
        
    }];
    
    

    [menuView show];


}
 
/**
 *  响应菜单事件
 *
 *  @param index 点中的下标值
 */
- (void)presentController:(NSUInteger)index
{
    if (index == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BaseNavgationController *addTaskNavCtl = [storyboard instantiateViewControllerWithIdentifier:@"AddTaskNavCtl"];
        [self presentViewController:addTaskNavCtl animated:YES completion:nil];
    }
    else if (index == 1){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BaseNavgationController *addScheduleNavCtl = [storyboard instantiateViewControllerWithIdentifier:@"AddScheduleNavCtl"];
        [self presentViewController:addScheduleNavCtl animated:YES completion:nil];
    }
}
/**
 *  是否要显示BarItem
 *
 *  @param show YES显示 、NO 隐藏
 */
- (void)showBarItem:(BOOL)show
{
    [UIView animateWithDuration:0 animations:^{
        if (show) {
            
            [_tabbarView setFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH,49)];
        }else{
            
            [_tabbarView setFrame:CGRectMake(-SCREEN_WIDTH, SCREEN_HEIGHT-49, SCREEN_WIDTH,49)];
        }
        
    }];
    
    self.tabBar.hidden = YES ;
    
    
}

/**
 *  隐藏tabBar后调整frame
 *
 *  @param isFrame YES/NO
 */
- (void)resizeView:(BOOL)isFrame{
    
    //    self.tabBar.hidden = YES;
    //    self.tabBar.backgroundColor = [UIColor redColor];
    //    NSLog(@"%d" , self.tabBar.hidden);
    //    for (UIView *subView in self.view.subviews) {
    //
    //        if ([subView isKindOfClass:NSClassFromString(@"UITransitionView")]) {
    //            if (isFrame) {
    ////                [subView setFrame:CGRectMake(subView.frame.origin.x, subView.frame.origin.y, ScreenWidth, ScreenHeight-49  )];
    //                NSLog(@"%f" , subView.height);
    //                subView.height = ScreenHeight - 49 ;
    //
    //            }else{
    //                subView.height = ScreenHeight ;
    //            }
    //
    //        }
    //    }
    
}

#pragma mark- 私有方法
- (BaseNavgationController*)fetchViewControllerWithIdentifier:(NSString*)storyboardID
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BaseNavgationController*chatNavViewCtl = [mainStoryboard instantiateViewControllerWithIdentifier:storyboardID];
    chatNavViewCtl.delegate = self ;
    return chatNavViewCtl ;
}
#pragma mark-UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    NSInteger count = navigationController.viewControllers.count ;
    
    if (count == 1) {
        [self showBarItem:YES];
        
    }else{
        [self showBarItem:NO];
    }
}

@end
