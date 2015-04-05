//
//  CommandTableViewCell.h
//  SMS Workflows
//
//  Created by Adrien on 4/5/15.
//  Copyright (c) 2015 Adrien Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommandTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UITextField *codeWordTextField;
@property (nonatomic, weak) IBOutlet UITextField *recipientsTextField;
@property (nonatomic, weak) IBOutlet UITextField *messageTextField;

@end
