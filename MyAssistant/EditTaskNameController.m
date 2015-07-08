//
//  EditController.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/22.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "EditTaskNameController.h"
#import "Task.h"
#import "CoreDataStack.h"


@interface EditTaskNameController ()<UITextFieldDelegate , UITextViewDelegate>

@property (weak , nonatomic)IBOutlet UITextField     *taskNameTextField ;
@property (weak , nonatomic)IBOutlet UITextView     *taskNotesTextView ;
@property (weak, nonatomic) IBOutlet UILabel *textviewLabel;

@property (nonatomic , retain)NSManagedObjectContext            *context ;

@end

@implementation EditTaskNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [CoreDataStack shareManaged].managedObjectContext ;
   
    [self.taskNameTextField becomeFirstResponder];
    self.taskNameTextField.text = self.myTask.taskName ;
    self.taskNotesTextView.text = self.myTask.taskDescribe ;
    if (self.myTask.taskDescribe.length != 0) {
        self.textviewLabel.hidden = YES ;
    }
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (![self.taskNotesTextView.text isEqualToString:self.myTask.taskDescribe]) {
        self.myTask.taskDescribe = self.taskNotesTextView.text ;
        if (![self.context save:nil]) {
            NSLog(@"edit fail");
        }
        else{
            if (self.EditTaskCompleteBlock) {
                self.EditTaskCompleteBlock(self.myTask);
            }
            
        }
        
    }
    
    if (![self.taskNameTextField.text isEqualToString:self.myTask.taskName]) {
        self.myTask.taskName = self.taskNameTextField.text ;
        if (![self.context save:nil]) {
            NSLog(@"edit fail");
        }
        else{
            if (self.EditTaskCompleteBlock) {
                self.EditTaskCompleteBlock(self.myTask);
            }

        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES ;
}
- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length != 0) {
        self.textviewLabel.hidden = YES ;
    }
    else{
        self.textviewLabel.hidden = NO ;
    }
    
}
#pragma mark - Table view data source


@end
