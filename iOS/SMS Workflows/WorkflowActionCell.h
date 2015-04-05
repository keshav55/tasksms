//
//  WorkflowActionCell.h
//  SMS Workflows
//
//  Created by Adrien on 4/4/15.
//  Copyright (c) 2015 Adrien Truong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkflowAction.h"

@interface WorkflowActionCell : UITableViewCell

@property (nonatomic, weak) WorkflowAction *action;

- (void)configureWithAction:(WorkflowAction *)action;

@end
