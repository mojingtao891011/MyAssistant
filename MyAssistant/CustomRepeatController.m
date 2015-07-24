//
//  CustomController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/23.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "CustomRepeatController.h"
#import "PickerCell.h"
#import "WeekCell.h"
#import "MonthCell.h"
#import "YearCell.h"

typedef enum
{
    everyday = 0,
    everyWeek = 1,
    everyMonth = 2,
    everyYear = 3
}RepeatType;

@interface CustomRepeatController ()
<  UITableViewDataSource ,
    UITableViewDelegate ,
    PickerCellDelegate ,
    MonthCellDelegate,
    YearCellDelegate
>

@property (nonatomic , assign)NSInteger         firstSectionInteger;
@property (nonatomic , assign)BOOL                 isShowPicker1;
@property (nonatomic , assign)BOOL                 isShowPicker2;
@property (nonatomic , assign)NSInteger         secondSectionInteger;
@property (nonatomic , retain)NSMutableArray        *firstSectionDataSource ;
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic , assign)RepeatType  repeatType ;
@property (nonatomic ,retain)NSArray        *weekArr;
@property (nonatomic , copy)NSString *componentStr;
@property (nonatomic , assign)CGFloat   footerHeight;

@property (nonatomic , assign)NSInteger repeat1Number;
@property (nonatomic , retain)NSString *repeat2Number;

@property (nonatomic , retain)NSMutableArray        *selectedWeeks;
@property (nonatomic , retain)NSMutableArray        *selectedMonths;
@property (nonatomic , retain)NSMutableArray        *selectedYears;

@property (nonatomic , retain)NSString          *everyDayFooterTitle ;
@property (nonatomic , retain)NSString          *everyWeekFooterTitle ;
@property (nonatomic , retain)NSString          *everyMonthFooterTitle ;
@property (nonatomic , retain)NSString          *everyYearFooterTitle ;

@end

@implementation CustomRepeatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.footerHeight = 40.0;
    self.firstSectionInteger = 2 ;
    self.secondSectionInteger = 0 ;
    self.firstSectionDataSource = [NSMutableArray arrayWithArray:@[@"每天" , @"天"]];
    
    self.weekArr = @[@"星期日" ,@"星期一" ,@"星期二" ,@"星期三" ,@"星期四" ,@"星期五" ,@"星期六" ];
    
    self.repeatType = everyday ;
    self.everyDayFooterTitle = @"事件将每天重复一次";
    self.componentStr = @"天";
    
    self.selectedWeeks = [NSMutableArray arrayWithCapacity:7];
    self.selectedMonths = [NSMutableArray arrayWithCapacity:30];
    self.selectedYears = [NSMutableArray arrayWithCapacity:12];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - PickerCellDelegate
- (void)selectedComponent:(NSString *)repeat1 repeat2:(NSString *)repeat2 pickerType:(PickerType)pickerType
{
    
       
    if ([repeat1 isEqualToString:@"每天"]) {
        self.secondSectionInteger = 0 ;
        self.repeatType = everyday ;
        [self.firstSectionDataSource removeAllObjects];
        [self.firstSectionDataSource addObjectsFromArray:@[@"每天" , [NSString stringWithFormat:@"%@ 天" , repeat2]]];
        self.everyDayFooterTitle = [NSString stringWithFormat:@"事件将每%@天重复一次" , repeat2];
        self.componentStr = @"天";
        self.repeat1Number = 0 ;
    }
    else if ([repeat1 isEqualToString:@"每周"]){
          self.repeat1Number = 1 ;
        self.secondSectionInteger = 7;
        self.repeatType = everyWeek ;
        [self.firstSectionDataSource removeAllObjects];
        [self.firstSectionDataSource addObjectsFromArray:@[@"每周" , [NSString stringWithFormat:@"%@ 周" , repeat2]]];
        self.everyWeekFooterTitle = [NSString stringWithFormat:@"事件将每%@周重复一次",repeat2];
        
        
        NSArray *array= [self.selectedWeeks sortedArrayUsingSelector:@selector(compare:)];
        self.selectedWeeks = [NSMutableArray arrayWithArray:array];
        
        NSMutableString *footerStr = [NSMutableString new] ;
        NSDictionary *dict = @{
                               @"0":@"星期日",
                               @"1":@"星期一",
                               @"2":@"星期二",
                               @"3":@"星期三",
                               @"4":@"星期四",
                               @"5":@"星期五",
                               @"6":@"星期六"
                               };
        for (NSNumber *index in array) {
            NSString *keyStr =[NSString stringWithFormat:@"%@" , index];
            [footerStr appendFormat:@"%@、",dict[keyStr]];
        }
        
        self.everyWeekFooterTitle = [NSString stringWithFormat:@"事件将每%@周于%@重复" , repeat2 , footerStr];
        
        self.componentStr = @"周";
    }
    else if ([repeat1 isEqualToString:@"每月"]){
          self.repeat1Number = 2 ;
        self.secondSectionInteger = 1;
        self.repeatType = everyMonth ;
        [self.firstSectionDataSource removeAllObjects];
        [self.firstSectionDataSource addObjectsFromArray:@[@"每月" , [NSString stringWithFormat:@"%@ 月" , repeat2]]];
        
        
        NSMutableString *monthsDay = [NSMutableString new];
        for (NSNumber *buttonTag in self.selectedMonths) {
            
            [monthsDay appendFormat:@"%d日 ",(int)[buttonTag integerValue]+1];
        }
        self.everyMonthFooterTitle = [NSString stringWithFormat:@"事件将每%@个月于%@重复" , repeat2 , monthsDay];
        
        self.componentStr = @"月";
    }
    else if ([repeat1 isEqualToString:@"每年"]){
          self.repeat1Number = 3 ;
        self.secondSectionInteger = 1;
        self.repeatType = everyYear ;
        [self.firstSectionDataSource removeAllObjects];
        [self.firstSectionDataSource addObjectsFromArray:@[@"每年" , [NSString stringWithFormat:@"%@ 年" , repeat2]]];
        
        NSMutableString *monthsDay = [NSMutableString new];
        for (NSNumber *buttonTag in self.selectedYears) {
            
            [monthsDay appendFormat:@"%d月 ",(int)[buttonTag integerValue]+1];
        }
        self.everyYearFooterTitle = [NSString stringWithFormat:@"事件将每%@个年于%@重复" , repeat2, monthsDay];

        self.componentStr = @"年";
    }

    
     self.repeat2Number = repeat2 ;
    
    [self.tableView reloadData];
}
#pragma mark - MonthCellDelegate
- (void)selectedMonthDay:(NSMutableArray *)months
{
    NSArray *array= [months sortedArrayUsingSelector:@selector(compare:)];
    self.selectedMonths = [NSMutableArray arrayWithArray:array];
    
    NSMutableString *monthsDay = [NSMutableString new];
    for (NSNumber *buttonTag in array) {
        
        [monthsDay appendFormat:@"%d日 ",(int)[buttonTag integerValue]+1];
    }
    self.everyMonthFooterTitle = [NSString stringWithFormat:@"事件将每%@个月于%@重复" , self.repeat2Number , monthsDay];
    
    _isShowPicker1 = NO ;
    _isShowPicker2 = NO ;
    self.firstSectionInteger = 2 ;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - YearCellDelegate
- (void)selectedYearAction:(NSMutableArray *)years
{
    NSArray *array= [years sortedArrayUsingSelector:@selector(compare:)];
    self.selectedYears = [NSMutableArray arrayWithArray:array];
    
    NSMutableString *monthsDay = [NSMutableString new];
    for (NSNumber *buttonTag in array) {
        
        [monthsDay appendFormat:@"%d月 ",(int)[buttonTag integerValue]+1];
    }
    self.everyYearFooterTitle = [NSString stringWithFormat:@"事件将每%@个年于%@重复" , self.repeat2Number , monthsDay];
    
    _isShowPicker1 = NO ;
    _isShowPicker2 = NO ;
    self.firstSectionInteger = 2 ;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];

}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.firstSectionInteger;
    }
    
    return self.secondSectionInteger ;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 1&&_isShowPicker1) {
            PickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PickerCell" forIndexPath:indexPath];
            cell.pickerType = firstPicker ;
            [cell.pickerView selectRow:self.repeat1Number inComponent:0 animated:YES];
            cell.delegate = self ;
            return cell ;
        }
        
        if (indexPath.row == 2 && _isShowPicker2) {
            PickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PickerCell" forIndexPath:indexPath];
            cell.pickerType = secondPicker ;
            cell.componentStr = self.componentStr ;
            [cell.pickerView selectRow:[self.repeat2Number intValue]- 1 inComponent:0 animated:YES];
            cell.delegate = self ;
            return cell ;
        }
    }
    if (indexPath.section == 1) {
        if (self.repeatType == everyWeek) {
            WeekCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeekCell" forIndexPath:indexPath];
            for (NSNumber *index in self.selectedWeeks) {
                if (indexPath.row == index.integerValue) {
                    cell.redioImageView.highlighted = YES ;
                }
            }
            cell.weekLabel.text = self.weekArr[indexPath.row];
            return cell ;
        }
        else if (self.repeatType == everyMonth){
            MonthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonthCell" forIndexPath:indexPath];
            cell.delegate = self ;
            return cell;
        }
        else if (self.repeatType == everyYear){
            YearCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YearCell" forIndexPath:indexPath];
            cell.delegate = self ;
            return cell ;
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomRepeatCell" forIndexPath:indexPath];
    [self configureFirstSectionCell:cell indexPath:indexPath];
    return cell;
}
- (void)configureFirstSectionCell:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath
{
    UILabel *label1 = (UILabel*)[cell viewWithTag:1];
    UILabel *label2 = (UILabel*)[cell viewWithTag:2];
    
    if (indexPath.row == 0) {
        label1.text = @"周期性重复";
        label2.text = [self.firstSectionDataSource firstObject];
        if (_isShowPicker1 ) {
            label2.textColor = ORANGE_COLOR ;
        }
        else{
            label2.textColor = [UIColor blackColor];
        }
    }
    else{
        label1.text = @"每";
        label2.text = [self.firstSectionDataSource lastObject];
        if ( _isShowPicker2) {
            label2.textColor = ORANGE_COLOR ;
        }
        else{
            label2.textColor = [UIColor blackColor];
        }
    }

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            _isShowPicker2 = NO ;
            _isShowPicker1 = !_isShowPicker1 ;
            if (_isShowPicker1) {
                self.firstSectionInteger = 3 ;
            }
            else{
                self.firstSectionInteger = 2 ;
            }
        }
        else if (indexPath.row == 1){
            if (_isShowPicker1) {
                return ;
            }
            else{
                _isShowPicker1 = NO ;
                _isShowPicker2 = !_isShowPicker2 ;
                if (_isShowPicker2) {
                    self.firstSectionInteger = 3 ;
                }
                else{
                    self.firstSectionInteger = 2 ;
                }
            }
        }
        else if (indexPath.row == 2){
            if (_isShowPicker2) {
                return ;
            }
            else{
                _isShowPicker1 = NO ;
                _isShowPicker2 = !_isShowPicker2 ;
                if (_isShowPicker2) {
                    self.firstSectionInteger = 3 ;
                }
                else{
                    self.firstSectionInteger = 2 ;
                }
            }
        }
         [tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if(indexPath.section == 1){
        _isShowPicker1 = NO ;
        _isShowPicker2 = NO ;
        self.firstSectionInteger = 2 ;
        
        if (self.repeatType == everyWeek) {
            self.everyWeekFooterTitle = [self selectWeekDay:indexPath];
            
             [tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        else{
             if (self.repeatType == everyMonth){
                return;
            }
             [tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    }
    
   

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.section == 0) {
        if (indexPath.row == 1 && _isShowPicker1) {
            return 170 ;
        }
        
        if (indexPath.row == 2 && _isShowPicker2) {
            return 170;
        }
    }
    else if (indexPath.section == 1)
    {
        if (self.repeatType == everyMonth) {
            
            return 200.0;
        }
        else if (self.repeatType == everyYear){
            return 120.0;
        }
    }
    
    return 44.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
         return _footerHeight ;
    }
    return 10;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        footerView.backgroundColor = [UIColor clearColor];
        UILabel *footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 30)];
        footerLabel.numberOfLines = 0 ;
        footerLabel.font = [UIFont systemFontOfSize:15.0];
        footerLabel.backgroundColor = [UIColor clearColor];
        footerLabel.textColor = [UIColor grayColor];
        [footerView addSubview:footerLabel];
        
        CGFloat footer_height;
        switch (self.repeatType) {
            case everyday:
                footerLabel.text = self.everyDayFooterTitle ;
                footer_height = [self footerLabelHeight:self.everyDayFooterTitle];
                break;
            case everyWeek:
                footerLabel.text = self.everyWeekFooterTitle ;
                footer_height = [self footerLabelHeight:self.everyWeekFooterTitle ];
                break;
            case everyMonth:
                footerLabel.text = self.everyMonthFooterTitle ;
                footer_height = [self footerLabelHeight:self.everyMonthFooterTitle];
                break;
            case everyYear:
                footerLabel.text = self.everyYearFooterTitle ;
                footer_height = [self footerLabelHeight:self.everyYearFooterTitle];
                break;
                
            default:
                break;
        }
        
        footerLabel.height = footer_height ;
        footerView.height = footer_height ;
        _footerHeight = footer_height;
        
        return footerView ;
    }
    
    return nil ;
    
}
#pragma mark - private
- (CGFloat)footerLabelHeight:(NSString*)footerTitle
{
    //计算高度
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:15.0] forKey:NSFontAttributeName];
    CGSize size = [footerTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height +20;
}
- (NSString*)selectWeekDay:(NSIndexPath*)indexPath
{
    if ([self.selectedWeeks containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
        [self.selectedWeeks removeObject:[NSNumber numberWithInteger:indexPath.row]];
    }
    else{
        [self.selectedWeeks addObject:[NSNumber numberWithInteger:indexPath.row]];
    }
    NSArray *array= [self.selectedWeeks sortedArrayUsingSelector:@selector(compare:)];
    self.selectedWeeks = [NSMutableArray arrayWithArray:array];
    
    NSMutableString *footerStr = [NSMutableString new] ;
    NSDictionary *dict = @{
                           @"0":@"星期日",
                           @"1":@"星期一",
                           @"2":@"星期二",
                           @"3":@"星期三",
                           @"4":@"星期四",
                           @"5":@"星期五",
                           @"6":@"星期六"
                           };
    for (NSNumber *index in array) {
         NSString *keyStr =[NSString stringWithFormat:@"%@" , index];
        [footerStr appendFormat:@"%@、",dict[keyStr]];
    }
    
    
    return [NSString stringWithFormat:@"事件将每%@周于%@重复" , _repeat2Number , footerStr]; ;
}

@end
