//
//  WorkflowSMSAction.m
//  SMS Workflows
//
//  Created by Adrien on 4/4/15.
//  Copyright (c) 2015 Adrien Truong. All rights reserved.
//

#import "WorkflowSMSAction.h"

@implementation WorkflowSMSAction

+ (NSString *)title
{
    return @"Send Text Message";
}

+ (UIImage *)image
{
    return [UIImage imageNamed:@"smsicon.png"];
}

- (NSDictionary *)dictionaryRepresentation
{
    return @{@"type": @"SMS",
             @"message": self.message,
             @"recipients": self.recipients};
}

@end
