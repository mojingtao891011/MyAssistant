//
//  ExecutorCell.h
//  MyAssistant
//
//  Created by taomojingato on 15/6/21.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExecutorCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImgview;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *selectedStateImg;
@property (weak, nonatomic) IBOutlet UILabel *userMailLabel;

@end
