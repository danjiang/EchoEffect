//
//  ViewController.m
//  EchoEffect
//
//  Created by Dan Jiang on 2021/2/6.
//

#import "ViewController.h"
#import "AudioEcho.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, AudioEchoDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) AudioEcho *audioEcho;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.audioEcho = [AudioEcho new];
    self.audioEcho.delegate = self;
    [self.audioEcho start];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
            
    // TODO: 3. Inject Effect
    // TODO: 4. Input Music App
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Options";
    } else if (section == 1) {
        return @"Inputs";
    } else {
        return @"Outputs";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.audioEcho numberOfOptions];
    } else if (section == 1) {
        return [self.audioEcho numberOfInputs];
    } else {
        return [self.audioEcho numberOfOutputs];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (indexPath.section == 0) {
        cell.textLabel.text = [self.audioEcho nameForOptionWithIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = [self.audioEcho nameForInputWithIndex:indexPath.row];
    } else {
        cell.textLabel.text = [self.audioEcho nameForOutputWithIndex:indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        [self.audioEcho toggleOptionWithIndex:indexPath.row];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - AudioEchoDelegate

- (void)audioEchoDidChanged:(AudioEcho *)audioEcho {
    [self.tableView reloadData];
}

@end
