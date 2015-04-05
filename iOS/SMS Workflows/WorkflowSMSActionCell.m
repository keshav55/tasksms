//
//  WorkflowSMSActionCell.m
//  SMS Workflows
//
//  Created by Adrien on 4/4/15.
//  Copyright (c) 2015 Adrien Truong. All rights reserved.
//

#import "WorkflowSMSActionCell.h"
#import "WorkflowSMSAction.h"

@interface WorkflowSMSActionCell () <UITextFieldDelegate>


@end

@implementation WorkflowSMSActionCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithAction:(WorkflowAction *)action
{
    [super configureWithAction:action];
    
    WorkflowSMSAction *smsAction = (WorkflowSMSAction *)action;
    self.messageTextField.text = smsAction.message;
    self.recipientsTextField.text = [smsAction.recipients componentsJoinedByString:@", "];
}

- (IBAction)textFieldDidChange
{
    WorkflowSMSAction *smsAction = (WorkflowSMSAction *)self.action;
    smsAction.message = self.messageTextField.text;
    smsAction.recipients = [self.recipientsTextField.text componentsSeparatedByString:@", "];
}

@end
