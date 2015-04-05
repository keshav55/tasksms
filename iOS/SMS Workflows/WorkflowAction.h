//
//  WorkflowAction.h
//  SMS Workflows
//
//  Created by Adrien on 4/4/15.
//  Copyright (c) 2015 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface WorkflowAction : NSObject

+ (NSString *)title;
+ (UIImage *)image;

- (NSDictionary *)dictionaryRepresentation;

@end
