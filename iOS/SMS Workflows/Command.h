//
//  Command.h
//  SMS Workflows
//
//  Created by Adrien on 4/5/15.
//  Copyright (c) 2015 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Command : NSObject

@property (nonatomic, copy) NSString *codeWord;
@property (nonatomic, strong) NSArray *recipients;
@property (nonatomic, copy) NSString *message;

@end
