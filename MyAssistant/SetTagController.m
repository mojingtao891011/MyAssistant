//
//  SetTagController.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/23.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "SetTagController.h"

@interface SetTagController ()

@property (nonatomic , retain)NSArray *imageViews ;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

@end

@implementation SetTagController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageViews = @[_imageView1 , _imageView2 , _imageView3 , _imageView4],
    
    [self judgeTaskTagType];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)judgeTaskTagType
{
    for (UIImageView *imageView in _imageViews) {
        imageView.hidden = YES ;
    }
    UIImageView *curSelectedTagImaageView = _imageViews[_curTaskTagType];
    curSelectedTagImaageView.hidden = NO ;
    
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    for (int i = 0 ; i < _imageViews.count ; i++) {
        UIImageView *imageView = _imageViews[i];
        if (i == indexPath.row) {
            imageView.hidden = !imageView.hidden ;
        }
        else{
            imageView.hidden = YES ;
        }
    }
    
    
    if (_setTagControllerDelegate && [_setTagControllerDelegate respondsToSelector:@selector(setTaskTag:)]) {
        
        switch (indexPath.row) {
            case 0:
                [_setTagControllerDelegate setTaskTag:OrdinaryType];
                break;
            case 1:
                [_setTagControllerDelegate setTaskTag:UrgentType];
                break;
            case 2:
                [_setTagControllerDelegate setTaskTag: ImportantType];
                break;
            case 3 :
                 [_setTagControllerDelegate setTaskTag:VeryUrgentType];
                break;
                
            default:
                break;
        }
    }
    
    if (self.selectedTaskTagBlock) {
        self.selectedTaskTagBlock(indexPath.row);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
     
}

@end
