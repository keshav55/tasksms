//
//  WorkflowActionPickerController.m
//  
//
//  Created by Adrien on 4/4/15.
//
//

#import "WorkflowActionPickerController.h"
#import "WorkflowSMSAction.h"
#import "WorkflowActionCollectionViewCell.h"

@interface WorkflowActionPickerController ()

@property (nonatomic, strong) NSArray *actionClasses;

@end

@implementation WorkflowActionPickerController

- (NSArray *)actionClasses
{
    return @[[WorkflowSMSAction class]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.actionClasses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    Class actionClass = self.actionClasses[indexPath.row];
    
    cell.textLabel.text = [actionClass title];
    cell.imageView.image = [actionClass image];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.completionHandler(self.actionClasses[indexPath.row]);
}

@end
