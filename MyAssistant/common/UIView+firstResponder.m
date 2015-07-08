//
//  UIView+firstResponder.m
//  SmartClock
//
//  Created by taomojingato on 15/5/6.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "UIView+firstResponder.h"

@implementation UIView (firstResponder)
- (UIView*)firstResponder
{
    
    for(UIView *v in self.subviews){
        if([v isFirstResponder]){
            
            return v;
        }else{
            UIView *vf = [v firstResponder];
            if(vf){
                
                return vf;
            }
        }
    }
    return nil;
    
}

@end
