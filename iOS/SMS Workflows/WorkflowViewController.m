//
//  WorkflowViewController.m
//  SMS Workflows
//
//  Created by Adrien on 4/4/15.
//  Copyright (c) 2015 Adrien Truong. All rights reserved.
//

#import "WorkflowViewController.h"
#import "WorkflowActionPickerController.h"
#import "WorkflowAction.h"
#import "WorkflowActionCell.h"

@interface WorkflowViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation WorkflowViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    style = UITableViewStyleGrouped;
    
    return [super initWithStyle:style];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 88;
    self.title = self.workflow.command;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add Action" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonTapped)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
    // Do any additional setup after loading the view.
}

- (void)addButtonTapped
{
    WorkflowActionPickerController *actionPickerController = [[WorkflowActionPickerController alloc] init];
    
    actionPickerController.completionHandler = ^(Class actionClass) {
        WorkflowAction *action = [[actionClass alloc] init];
        [self.workflow.actions addObject:action];
        
        [self.tableView reloadData];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:actionPickerController];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)doneButtonTapped
{
    self.completionHandler();
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.workflow.actions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkflowAction *action = self.workflow.actions[indexPath.row];
    
    NSString *cellClassName = [NSStringFromClass([action class]) stringByAppendingString:@"Cell"];
    Class cellClass = NSClassFromString(cellClassName);
    UINib *nib = [UINib nibWithNibName:cellClassName bundle:nil];
    
    [tableView registerNib:nib forCellReuseIdentifier:cellClassName];
    
    WorkflowActionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellClassName forIndexPath:indexPath];
    [cell configureWithAction:action];
    
    return cell;
}

@end
