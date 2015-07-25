//
//  RepeatRemindController.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/24.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "RepeatRemindController.h"
#import "CustomRepeatController.h"

@interface RepeatRemindController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView5;
@property (weak, nonatomic) IBOutlet UIImageView *imageView6;
@property (weak, nonatomic) IBOutlet UIImageView *imageView7;


@property (nonatomic , retain)UIImageView *lastSelectedImageView ;
@property (nonatomic , retain)NSArray       *imageViews ;

@end

@implementation RepeatRemindController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageViews = @[_imageView1 , _imageView2 , _imageView3 , _imageView4 , _imageView5 , _imageView6 ];
    
    if (self.imageViews.count <= _curRepeatType) {
        self.imageView7.hidden = NO ;
    }
    else{
        self.lastSelectedImageView = self.imageViews[_curRepeatType];
        self.lastSelectedImageView.hidden = NO ;

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CustomRepeatController *customRepeatCtl = segue.destinationViewController;
    customRepeatCtl.scheduleRemindTime = self.remindTime;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0) {
    
        self.imageView7.hidden = YES ;
        UIImageView *imageView = self.imageViews[indexPath.row];
        
        if (self.lastSelectedImageView) {
            if ([self.lastSelectedImageView isEqual:imageView]) {
                
                self.lastSelectedImageView.hidden = !self.lastSelectedImageView.hidden ;
            }
            else{
                imageView.hidden = NO ;
                self.lastSelectedImageView.hidden = YES ;
            }
        }
        else{
            imageView.hidden = !imageView.hidden ;
        }
        
        self.lastSelectedImageView = imageView ;
        
        if (self.selectedRepeatTypeBlock) {
            self.selectedRepeatTypeBlock(indexPath.row);
        }
        
        [self.navigationController popViewControllerAnimated:YES];

    }
    else{
        self.lastSelectedImageView.hidden = YES ;
        self.imageView7.hidden = NO ;
        if (self.selectedRepeatTypeBlock) {
            self.selectedRepeatTypeBlock(indexPath.row +[tableView numberOfRowsInSection:0]);
        }
    }
    
}
@end
