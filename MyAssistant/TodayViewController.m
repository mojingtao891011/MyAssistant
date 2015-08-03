//
//  TodayViewController.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/18.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "TodayViewController.h"
#import "BaseTableView.h"
#import "TodayTaskCell.h"
#import "TodayScheduleCell.h"
#import "CoreDataStack.h"
#import "User.h"
#import "Task.h"
#import "Schedule.h"
#import "CoreDataModelService.h"
#import "ScheduleDetailController.h"
#import "MJTCalendar.h"
#import "TabBarViewController.h"
#import "TodayCalendCell.h"
#import "TaskDetailsController.h"


@interface TodayViewController ()<UITableViewDataSource , UITableViewDelegate  ,NSFetchedResultsControllerDelegate >
{
    CGFloat  _headHeight ;
}

@property (nonatomic , retain)UILabel       *titleLabel ;
@property (retain, nonatomic) MJTCalendar *calendView;
@property (nonatomic , retain)NSDate            *curDate ;

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic , retain)NSArray                              *myCreatTasks ;
@property (nonatomic , retain)NSArray                               *myCreatSchedules ;
@property (nonatomic , retain) ScheduleDetailController *scheduleDetailCtl ;

@property (nonatomic , retain)NSFetchedResultsController        *fetchedResultsController ;
@property (nonatomic , retain)NSManagedObjectContext        *context ;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    //默认选中的时间为今天
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDate *date = [calendar dateFromComponents:comp1];
    [[NSUserDefaults standardUserDefaults]setObject:date forKey:@"curSelectedDate"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    _headHeight = 100.0 ;
    
    self.curDate = [NSDate date];
    
    self.context = [CoreDataStack shareManaged].managedObjectContext ;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushScheduleDetailCtl:) name:NOTE_ADDSCHEDULECOMPLETE object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushTaskDetailCtl:) name:NOTE_ADDTASKCOMPLETE object:nil];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMessage:) name:NOTE_RECEIVE_MESSAGE object:nil];

    [self _initDefaultUI];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadDataSource];
}
#pragma mark - UI
- (void)_initDefaultUI
{
    
//leftBarButtonItem
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 40, 35)];
    leftButton.tag = 2 ;
    [leftButton setImage:[UIImage imageNamed:@"icon_self"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton ;
    
//titleView
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    bgView.backgroundColor = [UIColor clearColor];
    
    //label
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 130, 20)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = GREY_FONT_COLOR;
//    self.titleLabel.text = [Tool stringFromFomate:self.calendView.calendar.currentDate formate:@"yyyy年MM月dd日"];
//    
//    __weak TodayViewController *weakSelf = self ;
//    self.calendView.selectedDateBlock = ^(NSDate *selectedDate){
//        weakSelf.titleLabel.text = [Tool stringFromFomate:selectedDate formate:@"yyyy年MM月dd日"];
//    };
    
    [bgView addSubview:_titleLabel];
    
    //UIbutton
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(130 , 5, 20, 20)];
    [button setBackgroundImage:[UIImage imageNamed:@"today"] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [button addTarget:self action:@selector(backToday:) forControlEvents:UIControlEventTouchUpInside];
//    button.layer.cornerRadius = button.width/2 ;
//    button.layer.borderWidth = 1.;
//    button.layer.borderColor = ORANGE_COLOR.CGColor ;
    [bgView addSubview:button];
    
    self.navigationItem.titleView = bgView ;

}


#pragma mark - Note
- (void)pushScheduleDetailCtl:(NSNotification*)sender
{
    Schedule *schedule = [sender object];
    [self.calendView createRandomEvents:schedule.schedulestartTime];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScheduleDetailController *scheduleDetailCtl = [storyboard instantiateViewControllerWithIdentifier:@"ScheduleDetailController"];
    scheduleDetailCtl.scheduleModel = sender.object ;
    [self.navigationController pushViewController:scheduleDetailCtl animated:YES];
}
- (void)pushTaskDetailCtl:(NSNotification*)sender
{
    Task *task = [sender object];
    [self.calendView createRandomEvents:task.taskStartTime];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TaskDetailsController *taskDetailCtl = [storyboard instantiateViewControllerWithIdentifier:@"TaskDetailsController"];
    //taskDetailCtl.myTask = sender.object ;
    taskDetailCtl.taskModel = sender.object ;
    [self.navigationController pushViewController:taskDetailCtl animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PushTaskDetailControllerSague"]) {
        
        TaskDetailsController *detailsCtl = segue.destinationViewController ;
        detailsCtl.taskModel = [self.myCreatTasks firstObject];
        
    }
    else if ([segue.identifier isEqualToString:@"pushTodayScheduleDetailCtl"]){
        self.scheduleDetailCtl = segue.destinationViewController ;
        
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private funs

- (void)backToday:(UIButton *)sender {
    
    [self.calendView didGoTodayTouch];
    
    self.curDate = self.calendView.calendar.currentDate ;
    
    [self loadDataSource];
    
     self.titleLabel.text = [Tool stringFromFomate:self.calendView.calendar.currentDate formate:@"yyyy年MM月dd日"];
}
- (IBAction)changeMode:(UIBarButtonItem *)sender {
    
    [_calendView didChangeModeTouch];
    

    static BOOL flag = YES ;
    
    if (flag) {
         _headHeight = 220 ;
    }
    else{
         _headHeight = 100 ;
    }
    
    flag = !flag ;
    
    [self.tableView reloadData];
    

}

- (void)dateEventsTask:(NSArray*)tasks  schedules:(NSArray*)schedules
{
    
}
- (void)leftBarButtonItemAction:(UIButton*)sender
{
    
    TabBarViewController *taBarCtl = (TabBarViewController*)self.tabBarController ;
    [taBarCtl selectleViewController:sender];
}
- (void)configureTodayCalendCell:(TodayCalendCell*)cell  indexPath:(NSIndexPath*)indexPath
{
    self.titleLabel.text = [Tool stringFromFomate:CUR_SELECTEDDATE formate:@"yyyy年MM月dd日"];
    self.curDate = cell.calendarView.calendar.currentDate ;
    
    cell.calendarView.selectedDateBlock = ^(NSDate *selectedDate){
        self.titleLabel.text = [Tool stringFromFomate:selectedDate formate:@"yyyy年MM月dd日"];
        self.curDate = selectedDate ;
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        NSDateComponents* comp1 = [calendar components:unitFlags fromDate:selectedDate];
        NSDate *date = [calendar dateFromComponents:comp1];
        
       
        //保存选中的时间
        [[NSUserDefaults standardUserDefaults]setObject:date forKey:@"curSelectedDate"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        
        [self loadDataSource];
    };
    
    self.calendView = cell.calendarView ;

}
- (void)configureTodayTableviewTaskCell:(TodayTaskCell*)cell    indexPath:(NSIndexPath*)indexPath
{
    Task *myTask = self.myCreatTasks[indexPath.row - 1];
    cell.myTask = myTask ;
    
    
}
- (void)configureTodayTableviewScheduleCell:(TodayScheduleCell*)cell    indexPath:(NSIndexPath*)indexPath
{
    Schedule *scheduleModel = self.myCreatSchedules[indexPath.row - 1];
    cell.myschedule = scheduleModel ;
    
}
#pragma mark - DataSource
- (void)loadDataSource
{
   
    
    User *curUser = [CoreDataModelService fetchUserByName:USER_ID];
    
    NSArray *curUserCreatAllTasks = [CoreDataModelService fetchAllTask];
    NSSortDescriptor *sortTaskTag = [NSSortDescriptor sortDescriptorWithKey:@"taskTag" ascending:NO];
    NSSortDescriptor *sortTaskEndTime = [NSSortDescriptor sortDescriptorWithKey:@"taskEndTime" ascending:NO];
    NSSortDescriptor *sortTaskCreatTime = [NSSortDescriptor sortDescriptorWithKey:@"taskCreatTime" ascending:NO];
    NSArray *sortTaskArr = [curUserCreatAllTasks sortedArrayUsingDescriptors:@[sortTaskTag , sortTaskEndTime , sortTaskCreatTime]];
    
    NSPredicate *predicateTask = [NSPredicate predicateWithFormat:@"taskTheDate = %@" , CUR_SELECTEDDATE];
    NSPredicate *predicateUser = [NSPredicate predicateWithFormat:@"creatTaskUser.userName = %@" , curUser.userName];
    self.myCreatTasks = [[sortTaskArr filteredArrayUsingPredicate: predicateTask] filteredArrayUsingPredicate:predicateUser];
    
    
    
    NSArray *curUserCreatSchedules = [CoreDataModelService fetchAllSchedule];
    NSSortDescriptor *sortCreatScheduleTime = [NSSortDescriptor sortDescriptorWithKey:@"scheduleCreatTime" ascending:NO];
    NSArray *sortScheduleArr= [curUserCreatSchedules sortedArrayUsingDescriptors:@[sortCreatScheduleTime]];
    
    NSPredicate *predicateSchedule = [NSPredicate predicateWithFormat:@"scheduleTheDay == %@" , CUR_SELECTEDDATE];
     NSPredicate *predicateScheduleUser = [NSPredicate predicateWithFormat:@"creatScheduleUser.userName = %@" , curUser.userName];
    self.myCreatSchedules = [sortScheduleArr filteredArrayUsingPredicate:predicateSchedule];
    self.myCreatSchedules = [self.myCreatSchedules filteredArrayUsingPredicate:predicateScheduleUser];
    
    [self.tableView reloadData];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1 ;
    }
    if (section == 1) {
        if (self.myCreatSchedules.count == 0 || !self.myCreatSchedules) {
            return 2 ;
        }
        return self.myCreatSchedules.count + 1;
    }
    
    if (self.myCreatTasks.count == 0 || !self.myCreatTasks) {
        return 2 ;
    }
    return 2 ;
    
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        TodayCalendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todayCalendCell" forIndexPath:indexPath];
        [self configureTodayCalendCell:cell indexPath:indexPath];
        return cell ;
    }
    
    //section1
    if (indexPath.section == 1) {
        
        
        if (indexPath.row == 0) {
            UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SectionOneCell" forIndexPath:indexPath];
            UILabel *itemsLabel= (UILabel*)[cell viewWithTag:1];
            
            itemsLabel.text = [NSString stringWithFormat:@"所有%d项" , (int)[CoreDataModelService fetchAllSchedule].count];
            return cell ;
        }
        else{
            
            if (self.myCreatSchedules.count != 0) {
                TodayScheduleCell *scheduleCell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCell" forIndexPath:indexPath];
                [self configureTodayTableviewScheduleCell:scheduleCell indexPath:indexPath];
                 return scheduleCell ;
            }
           
            //没有日程
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemindCell" forIndexPath:indexPath];
            UILabel *remindLabel = (UILabel*)[cell viewWithTag:3];
            remindLabel.text = @"今天没有日程";
            return cell ;
            
        }
        
    }
    
    //section2
    
    if (indexPath.row == 0) {
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SectionTwoCell" forIndexPath:indexPath];
        UILabel *itemsLabel = (UILabel*)[cell viewWithTag:2];
        
        itemsLabel.text = [NSString stringWithFormat:@"所有%d项" , (int)[CoreDataModelService fetchAllTask].count];
        return cell ;
    }
    
    if (self.myCreatTasks.count != 0) {
        TodayTaskCell *taskCell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
        [self configureTodayTableviewTaskCell:taskCell indexPath:indexPath];
         return taskCell ;
    }
    
    //没有任务
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemindCell" forIndexPath:indexPath];
    UILabel *remindLabel = (UILabel*)[cell viewWithTag:3];
    remindLabel.text = @"暂时没有任务";
    return cell ;
    
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row != 0 && _myCreatSchedules.count != 0) {
        Schedule *scheduleModel = self.myCreatSchedules[indexPath.row - 1];
        self.scheduleDetailCtl.scheduleModel = scheduleModel ;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return _headHeight ;
    }
    
    if (indexPath.row == 0) {
        return 40.0 ;
    }
    if (indexPath.section == 1) {
        
        return 60.0 ;
    }
    
    return 50.0 ;
}
#pragma mark - delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0 ) {
        return NO ;
    }
    if (indexPath.section == 1 &&self.myCreatSchedules.count == 0) {
        return NO ;
    }
    if (indexPath.section == 2 && self.myCreatTasks.count == 0) {
        return NO ;
    }
    
    return YES ;
}
- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 1) {
            Schedule *scheduleModel = self.myCreatSchedules[indexPath.row - 1];
            NSDate *scheduleStartTime= scheduleModel.schedulestartTime ;
            if ([CoreDataModelService deleteScheduleByScheduleModel:scheduleModel]) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTE_DELETEMODEL object:scheduleStartTime];
                });
                [self loadDataSource];
            }
        }
        else if (indexPath.section == 2){
            Task *taskModel = self.myCreatTasks[indexPath.row - 1];
            NSDate *taskStartTime = taskModel.taskStartTime ;
            if ([CoreDataModelService deleteTaskByTaskModel:taskModel]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTE_DELETEMODEL object:taskStartTime];
                });
                [self loadDataSource];
            }
        }
    }
}
@end
