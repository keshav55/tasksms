//
//  WorkflowViewController.h
//  SMS Workflows
//
//  Created by Adrien on 4/4/15.
//  Copyright (c) 2015 Adrien Truong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workflow.h"

@interface WorkflowViewController : UITableViewController

@property (nonatomic, strong) Workflow *workflow;
@property (nonatomic, copy) void (^completionHandler)();

@end
