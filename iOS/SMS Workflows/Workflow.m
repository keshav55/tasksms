//
//  Workflow.m
//  SMS Workflows
//
//  Created by Adrien on 4/4/15.
//  Copyright (c) 2015 Adrien Truong. All rights reserved.
//

#import "Workflow.h"
#import "WorkflowAction.h"

@implementation Workflow

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.actions = [NSMutableArray array];
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableArray *actionDicts = [NSMutableArray array];
    for (WorkflowAction *action in self.actions) {
        NSDictionary *dict = [action dictionaryRepresentation];
        [actionDicts addObject:dict];
    }
    
    return @{
             @"command": self.command,
             @"actions": actionDicts};
}

@end
