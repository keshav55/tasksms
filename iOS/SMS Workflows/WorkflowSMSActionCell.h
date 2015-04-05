//
//  WorkflowSMSActionCell.h
//  SMS Workflows
//
//  Created by Adrien on 4/4/15.
//  Copyright (c) 2015 Adrien Truong. All rights reserved.
//

#import "WorkflowActionCell.h"

@interface WorkflowSMSActionCell : WorkflowActionCell

@property (nonatomic, weak) IBOutlet UITextField *messageTextField;
@property (nonatomic, weak) IBOutlet UITextField *recipientsTextField;

@end
