//
//  TableViewController.m
//  SMS Workflows
//
//  Created by Adrien on 4/5/15.
//  Copyright (c) 2015 Adrien Truong. All rights reserved.
//

#import "TableViewController.h"
#import "CommandTableViewCell.h"
#import "Command.h"
#import <Firebase/Firebase.h>

@interface TableViewController ()

@property (nonatomic, strong) NSMutableArray *commands;
@property (nonatomic, strong) Firebase *firebase;

@end

@implementation TableViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.title = @"Commands";
    
    UINib *nib = [UINib nibWithNibName:@"CommandTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CommandTableViewCell"];
    
    self.commands = [NSMutableArray arrayWithObject:[[Command alloc] init]];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.firebase = [[Firebase alloc] initWithUrl:@"https://tasksms.firebaseio.com"];
    
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"PhoneNumber"];
    NSString *path = [NSString stringWithFormat:@"users/%@/codeWords/", phoneNumber];
    Firebase *codeWordsRef = [self.firebase childByAppendingPath:path];
    [codeWordsRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary *codeWords = snapshot.value;
        if ([codeWords count] > 0) {
            NSMutableArray *commands = [NSMutableArray array];
            for (NSString *codeWord in codeWords) {
                NSDictionary *commandDict = codeWords[codeWord];
                
                Command *command = [[Command alloc] init];
                command.codeWord = codeWord;
                command.recipients = commandDict[@"recipients"];
                command.message = commandDict[@"message"];
                
                [commands addObject:command];
            }
            
            [self.tableView reloadData];
        }
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(updateButtonTapped)];
}

- (void)updateButtonTapped
{
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"PhoneNumber"];
    NSString *path = [NSString stringWithFormat:@"users/%@/codeWords", phoneNumber];
    
    NSMutableDictionary *commandsByCodeWord = [NSMutableDictionary dictionary];
    for (Command *command in self.commands) {
        NSDictionary *dict = @{@"recipients": command.recipients,
                               @"message": command.message};
        commandsByCodeWord[command.codeWord] = dict;
    }
    
    Firebase *ref = [self.firebase childByAppendingPath:path];
    [ref setValue:commandsByCodeWord];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.commands count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [self.commands count]) {
        return 44;
    } else {
        return 216;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [self.commands count]) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"Add New Command";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:180.0f/255.0f blue:255.0f/255.0f alpha:1.0];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        return cell;
    }
    
    CommandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommandTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    if ([cell.codeWordTextField.allTargets count] == 0) {
        [cell.codeWordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.recipientsTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.messageTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == [self.commands count]) {
        [self.commands addObject:[[Command alloc] init]];
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    CGPoint correctedPoint = [textField convertPoint:textField.bounds.origin toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:correctedPoint];
    CommandTableViewCell *cell = (CommandTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    Command *command = self.commands[indexPath.section];
    command.codeWord = cell.codeWordTextField.text;
    command.recipients = [cell.recipientsTextField.text componentsSeparatedByString:@", "];
    command.message = cell.messageTextField.text;
}

@end
