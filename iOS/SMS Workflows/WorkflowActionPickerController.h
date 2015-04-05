//
//  WorkflowActionPickerController.h
//  
//
//  Created by Adrien on 4/4/15.
//
//

#import <UIKit/UIKit.h>

@interface WorkflowActionPickerController : UITableViewController

@property (nonatomic, copy) void (^completionHandler)(Class actionClass);

@end
