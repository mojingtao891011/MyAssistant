//
//  RepeatRemindController.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/24.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "RepeatRemindController.h"

@interface RepeatRemindController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView5;


@property (nonatomic , retain)UIImageView *lastSelectedImageView ;
@property (nonatomic , retain)NSArray       *imageViews ;

@end

@implementation RepeatRemindController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageViews = @[_imageView1 , _imageView2 , _imageView3 , _imageView4 , _imageView5];
    
    
    self.lastSelectedImageView = self.imageViews[_curRepeatType];
    self.lastSelectedImageView.hidden = NO ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
@end
