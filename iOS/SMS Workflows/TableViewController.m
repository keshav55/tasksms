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
#import <MyoKit/MyoKit.h>
#import <UNIRest.h>

@interface TableViewController ()

@property (nonatomic, strong) NSMutableArray *commands;
@property (nonatomic, strong) Firebase *firebase;
@property (strong, nonatomic) TLMPose *currentPose;


@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Commands";
    
    UINib *nib = [UINib nibWithNibName:@"CommandTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CommandTableViewCell"];
    
    self.commands = [NSMutableArray arrayWithObject:[[Command alloc] init]];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.firebase = [[Firebase alloc] initWithUrl:@"https://tasksms.firebaseio.com"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(updateButtonTapped)];
    
    
    [self attachToAdjacentMyo];
    [self pushMyoSettings];
    
    // Posted whenever a TLMMyo connects
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didConnectDevice:)
                                                 name:TLMHubDidConnectDeviceNotification
                                               object:nil];
    // Posted whenever a TLMMyo disconnects
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDisconnectDevice:)
                                                 name:TLMHubDidDisconnectDeviceNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSyncArm:)
                                                 name:TLMMyoDidReceiveArmSyncEventNotification
                                               object:nil];
    // Posted whenever Myo loses sync with an arm (when Myo is taken off, or moved enough on the user's arm).
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUnsyncArm:)
                                                 name:TLMMyoDidReceiveArmUnsyncEventNotification
                                               object:nil];
    
    
    
    // Posted when a new pose is available from a TLMMyo
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivePoseChange:)
                                                 name:TLMMyoDidReceivePoseChangedNotification
                                               object:nil];
    
    
    
    
    
    
    
    
    
    
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
        cell.textLabel.text = @"Add New Command...";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
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


#pragma Myo
//Myo Stuff

- (void)attachToAdjacentMyo {
    [[TLMHub sharedHub] attachToAdjacent];
}
- (void)pushMyoSettings {
    TLMSettingsViewController *settings = [[TLMSettingsViewController alloc] init];
    
    [self.navigationController pushViewController:settings animated:YES];
}

- (void)didConnectDevice:(NSNotification *)notification {
    // Align our label to be in the center of the view.
    NSLog(@"connected");
}

- (void)didDisconnectDevice:(NSNotification *)notification {
    // Remove the text of our label when the Myo has disconnected.
    NSLog(@"disconnected");
}


- (void)didRecognizeArm:(NSNotification *)notification {
    

    
}
- (void)didLoseArm:(NSNotification *)notification {
    // Reset the armLabel and helloLabel
    NSLog(@"lost arm");
}

- (void)didSyncArm:(NSNotification *)notification {
    // Retrieve the arm event from the notification's userInfo with the kTLMKeyArmSyncEvent key.
    TLMArmSyncEvent *armEvent = notification.userInfo[kTLMKeyArmSyncEvent];
    // Update the armLabel with arm information.
    NSString *armString = armEvent.arm == TLMArmRight ? @"Right" : @"Left";
    NSString *directionString = armEvent.xDirection == TLMArmXDirectionTowardWrist ? @"Toward Wrist" : @"Toward Elbow";
    NSLog(@"%@", armString);
}
- (void)didUnsyncArm:(NSNotification *)notification {
    // Reset the labels.
    NSLog(@"perform sync");
}

-(void) sendSMS{
    
    NSDictionary *headers = @{@"Authorization": @"Basic QUMxZDhhZTYxZTM3ZDc0ZDBlNDg5NDdkMDk1YzlhZTMyZDo0NDVmMmY5OGM4YTlkODJiNTUxMjNlM2VhMjRhOTgxNw==", @"X-Mashape-Key": @"5uiZBYWupumshcTKlKIZwuTP5PQNp1CQSWKjsnPckXGf0dufZs", @"Content-Type": @"application/x-www-form-urlencoded", @"Accept": @"text/plain"};
    NSDictionary *parameters = @{@"Body": @"This is what I should send", @"From": @"(925) 892-3685", @"To": @"5107097856"};
    UNIUrlConnection *asyncConnection = [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"https://twilio.p.mashape.com/AC1d8ae61e37d74d0e48947d095c9ae32d/SMS/Messages.json"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {
        NSInteger code = response.code;
        NSDictionary *responseHeaders = response.headers;
        UNIJsonNode *body = response.body;
        NSData *rawBody = response.rawBody;
    }];
    
    
    
}



- (void)didReceivePoseChange:(NSNotification *)notification {
    // Retrieve the pose from the NSNotification's userInfo with the kTLMKeyPose key.
    TLMPose *pose = notification.userInfo[kTLMKeyPose];
    self.currentPose = pose;
    
    // Handle the cases of the TLMPoseType enumeration, and change the color of helloLabel based on the pose we receive.
    switch (pose.type) {
        case TLMPoseTypeUnknown:
        case TLMPoseTypeRest:
            // Changes helloLabel's font to Helvetica Neue when the user is in a rest or unknown pose.
            NSLog(@"unknown");
            break;
        case TLMPoseTypeFist:
            // Changes helloLabel's font to Noteworthy when the user is in a fist pose.
            NSLog(@"fist");
            break;
        case TLMPoseTypeWaveIn:
            // Changes helloLabel's font to Courier New when the user is in a wave in pose.
            NSLog(@"redout");
            break;
        case TLMPoseTypeWaveOut:
            // Changes helloLabel's font to Snell Roundhand when the user is in a wave out pose.
            NSLog(@"wave");
        case TLMPoseTypeDoubleTap:
            NSLog(@"you got it!");
            [self sendSMS];
            
            
            

            
            
    
            
            break;
       
}
  



    
}



@end
