//
//  ViewController.m
//  EchoEffect
//
//  Created by Dan Jiang on 2021/2/6.
//

#import "ViewController.h"
#import "AudioEcho.h"

@interface ViewController ()

@property (nonatomic, strong) AudioEcho *audioEcho;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.audioEcho = [AudioEcho new];
    [self.audioEcho start];
    
    // TODO: 1. Select Input Device
    // TODO: 2. Select Output Device
    // TODO: 3. Inject Effect
    // TODO: 4. Input Music App
}

@end
