//
//  WorkflowListTableViewController.m
//  SMS Workflows
//
//  Created by Adrien on 4/4/15.
//  Copyright (c) 2015 Adrien Truong. All rights reserved.
//

#import "WorkflowListTableViewController.h"
#import "Workflow.h"
#import "WorkflowViewController.h"
#import <Firebase/Firebase.h>

#define kFirechatNS @"https://tasksms.firebaseio.com"

@interface WorkflowListTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Firebase *firebase;

@end

@implementation WorkflowListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Workflows";
    
    self.workflows = [NSMutableArray array];
    
    self.firebase = [[Firebase alloc] initWithUrl:kFirechatNS];
    [self.firebase setValue:@"Test"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];
    
    // Do any additional setup after loading the view.
}

- (void)addButtonTapped
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Pick a Command" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:nil];

    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        WorkflowViewController *workflowViewController = [[WorkflowViewController alloc] init];
        workflowViewController.workflow = [[Workflow alloc] init];
        workflowViewController.workflow.command = [[alertController.textFields firstObject] text];
        Workflow *workflow = workflowViewController.workflow;
        workflowViewController.completionHandler = ^{
            Firebase *mainRef = [self.firebase childByAppendingPath:@"users/7143885687/workflows"];
            Firebase *ref = [mainRef childByAppendingPath:workflow.command];
            [ref setValue:[workflow dictionaryRepresentation] withCompletionBlock:^(NSError *error, Firebase *ref) {
                if (error) {
                    NSLog(@"%@", error);
                } else {
                    NSLog(@"Compelted!!");
                }
            }];
            [self.workflows addObject: workflow];
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:workflowViewController];
        
        [self presentViewController:navController animated:YES completion:nil];
    }];
    
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.workflows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    Workflow *workflow = self.workflows[indexPath.row];
    
    cell.textLabel.text = workflow.command;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Workflow *workflow = self.workflows[indexPath.row];
    
    WorkflowViewController *workflowViewController = [[WorkflowViewController alloc] init];
    workflowViewController.workflow = workflow;
    
    [self.navigationController pushViewController:workflowViewController animated:YES];
}

@end
