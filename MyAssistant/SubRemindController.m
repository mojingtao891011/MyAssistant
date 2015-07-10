//
//  SubRemindController.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/9.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "SubRemindController.h"

@interface SubRemindController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIImageView *selectImg1;
@property (weak, nonatomic) IBOutlet UIImageView *selectImg2;
@property (weak, nonatomic) IBOutlet UIImageView *selectImg3;
@property (weak, nonatomic) IBOutlet UIImageView *selectImg4;
@property (weak, nonatomic) IBOutlet UIImageView *selectImg5;

@property (nonatomic , retain)UIImageView *lastSelectedImgView;
@property (nonatomic , retain)NSArray *selectImgArr;
@property (nonatomic , assign)NSInteger selectedRemindType;
@property (nonatomic , assign)BOOL      isCreatRemind;
@property (nonatomic , retain)NSManagedObjectContext    *context ;

@end

@implementation SubRemindController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _selectImgArr = @[_selectImg1 , _selectImg2 , _selectImg3 , _selectImg4 , _selectImg5];
    
    self.context = [CoreDataStack shareManaged].managedObjectContext ;
    
    [self _initDefaultUI];
    
}
#pragma mark - UI
- (void)_initDefaultUI
{
    if (!self.subRemindModel) {
        self.selectedRemindType = 0;
        self.isHidenRightButton = YES ;
        self.isCreatRemind = YES ;
        return ;
    }
    
    self.isHidenRightButton = NO ;
    self.isCreatRemind = NO ;
    self.rightButtonImageName = @"nav_delete_btn";
    
    self.selectedRemindType = self.subRemindModel.subRemindType.integerValue ;
    //1
    [self.datePicker setDate:_subRemindModel.subRemindTime animated:YES];
    
    //2
    NSInteger selectRemindType = self.subRemindModel.subRemindType.integerValue;
    UIImageView *selectImg = _selectImgArr[selectRemindType];
    selectImg.hidden = NO ;
    _lastSelectedImgView = selectImg ;
    
}
#pragma mark - Action
- (void)leftAction
{
    if (_subRemindBlock && (![_datePicker.date isEqualToDate:self.subRemindModel.subRemindTime] || _selectedRemindType != self.subRemindModel.subRemindType.integerValue)) {
        self.subRemindBlock(_datePicker.date , _selectedRemindType , _isCreatRemind);
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightAction
{
    [[[UIAlertView alloc]initWithTitle:nil message:@"你确定要删除子提醒" delegate:self cancelButtonTitle:@"取 消" otherButtonTitles:@"确 定", nil]show ];
}
#pragma mark - UITableViewDate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIImageView *imageViewState = _selectImgArr[indexPath.row];
   
    if (_lastSelectedImgView) {
        if ([_lastSelectedImgView isEqual:imageViewState]) {
            imageViewState.hidden = !imageViewState.hidden;
        }
        else{
            _lastSelectedImgView.hidden = YES ;
            imageViewState.hidden = NO ;
        }
    }
    else{
        
        imageViewState.hidden = NO ;
    }
    _lastSelectedImgView = imageViewState ;
    
    //2
    if (!imageViewState.hidden) {
        self.selectedRemindType = indexPath.row ;
    }
}
#pragma mark - 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && self.deleteRemindBlock) {
        self.deleteRemindBlock();
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
