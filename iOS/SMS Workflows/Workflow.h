//
//  Workflow.h
//  SMS Workflows
//
//  Created by Adrien on 4/4/15.
//  Copyright (c) 2015 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Workflow : NSObject

@property (nonatomic, copy) NSString *command;
@property (nonatomic, strong) NSMutableArray *actions;

- (NSDictionary *)dictionaryRepresentation;

@end
