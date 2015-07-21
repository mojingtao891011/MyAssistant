//
//  RemindTimeController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/15.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "RemindTimeController.h"
#import "RemindCell.h"


@interface RemindTimeController ()<UITableViewDataSource , UITableViewDelegate>

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic , retain)NSMutableArray   *dataSources ;
@property (nonatomic , assign)BOOL isOpenDatePicker;
@property (nonatomic , retain)UIDatePicker  *datePicker ;
@property (nonatomic , retain)NSTimer       *timer ;
@property (nonatomic , retain)NSDate *selecteTime ;
@property (nonatomic , copy)NSString *selectedRemindType;
@property (nonatomic , retain)NSMutableArray  *timeArr ;
@property (nonatomic , retain)NSIndexPath  *lastIndexPath ;

@end

@implementation RemindTimeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.timeArr = [NSMutableArray arrayWithArray:@[@"" ,@"", self.scheduleStartTime , [self beforeTime:5],[self beforeTime:15] , [self beforeTime:30] , [self beforeTime: 60] ,[self beforeTime:2*60], [self beforeTime:24*60] , [self beforeTime:24*2*60] , [self beforeTime:24*7*60]]];
    
    self.dataSources = [NSMutableArray arrayWithArray:@[@"无" ,@"自定义",@"事件发生时" , @"5分钟前",@"15分钟前" ,@"30分钟前" , @"1小时前",@"2小时前" ,@"1天前" , @"2天前",@"1周前" ]];
    
    self.selectedRemindType = @"无";
}
- (NSDate*)beforeTime:(NSInteger)interval
{
    return [NSDate dateWithTimeInterval:60*-interval sinceDate:self.scheduleStartTime];
}
#pragma mark - Action
- (void)updateTime
{
    if (_datePicker) {
        [_dataSources replaceObjectAtIndex:1 withObject:[Tool stringFromFomate:_datePicker.date formate:@"MM-dd HH:mm"]];
        [self.tableView reloadData];
        
        [_timeArr replaceObjectAtIndex:1 withObject:_datePicker.date];
        
        _selecteTime = _datePicker.date ;
        _selectedRemindType = nil ;
    }
    
}
- (void)backAction
{
    
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil ;
    }
    
    if (self.remindDateBlock) {
        self.remindDateBlock(_selecteTime,_selectedRemindType , _subRemindNumber);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSources.count ;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isOpenDatePicker && indexPath.row == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"datePickerCell" forIndexPath:indexPath];
        self.datePicker = (UIDatePicker*)[cell viewWithTag:1];
        return cell ;
    }
    
    RemindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemindCell" forIndexPath:indexPath];
    [self configureCell:cell indexPath:indexPath];
    return cell ;
}
- (void)configureCell:(RemindCell*)cell indexPath:(NSIndexPath*)indexPath
{
    cell.cellTextLabel.text = self.dataSources[indexPath.row];
    
    if ([indexPath isEqual:_lastIndexPath]) {
        cell.cellStateImgView.hidden = NO ;
    }
    else{
        cell.cellStateImgView.hidden = YES ;
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _lastIndexPath = indexPath ;

    //1
    if (indexPath.row == 1) {
        
        _isOpenDatePicker = !_isOpenDatePicker ;
        
        if (_isOpenDatePicker) {
            
            [_dataSources insertObject:@"" atIndex:2];
            [_timeArr insertObject:@"" atIndex:2];
        
            if (![_timer isValid]) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
            }
            
        }
        else{
            
            if ([_timer isValid]) {
                [_timer invalidate];
                _timer = nil ;
            }
            
            [_dataSources removeObjectAtIndex:2];
            [_timeArr removeObjectAtIndex:2];
        }
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    else{
        if (_isOpenDatePicker) {
            _isOpenDatePicker = NO ;
            
            if ([_timer isValid]) {
                [_timer invalidate];
                _timer = nil ;
            }
            
            [_dataSources removeObjectAtIndex:2];
            [_timeArr removeObjectAtIndex:2];
            
            if (indexPath.row != 0) {
                _lastIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0];
            }
            
             [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
        else{
              [tableView reloadData];
        }
        
        
       
    }
    
    _selecteTime = _timeArr[indexPath.row];
    
    _selectedRemindType = _dataSources[indexPath.row];
    
    if (indexPath.row == 0) {
        _selecteTime = nil ;
    }
    else if (indexPath.row == 1){
        _selecteTime = _datePicker.date ;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isOpenDatePicker && indexPath.row == 2) {
        
        return 165.0 ;
    }
    
    return 44.0;
}
@end
