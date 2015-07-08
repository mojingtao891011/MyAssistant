//
//  MProgressBar.h
//  MyAssistant
//
//  Created by taomojingato on 15/6/29.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MRoundProgressBar : UIView

@property (nonatomic , assign)CGFloat       strokeStartValues ;
@property (nonatomic , assign)CGFloat       strokeEndValues ;
@property (nonatomic , retain)UIColor         *strokeColorValues ;
@property (nonatomic , copy)NSString         *labelTitle;
@property (nonatomic , assign)CGFloat       labelFontSize;

@end
