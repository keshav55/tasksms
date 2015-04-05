//
//  WorkflowSMSAction.h
//  SMS Workflows
//
//  Created by Adrien on 4/4/15.
//  Copyright (c) 2015 Adrien Truong. All rights reserved.
//

#import "WorkflowAction.h"

@interface WorkflowSMSAction : WorkflowAction

@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSArray *recipients;

@end
