//
//  AudioEcho.m
//  EchoEffect
//
//  Created by Dan Jiang on 2021/2/6.
//

#import "AudioEcho.h"
#import "AudioOption.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioEcho ()

@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, assign, getter=isRunning) BOOL running;
@property (nonatomic, copy) NSArray<AudioOption *> *options;

@end

@implementation AudioEcho

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.options = @[[[AudioOption alloc] initWithName:@"AllowBluetooth" option:AVAudioSessionCategoryOptionAllowBluetooth],
                         [[AudioOption alloc] initWithName:@"AllowBluetoothA2DP" option:AVAudioSessionCategoryOptionAllowBluetoothA2DP],
                         [[AudioOption alloc] initWithName:@"DefaultToSpeaker" option:AVAudioSessionCategoryOptionDefaultToSpeaker]];
        
        [self resetAudioSession];
        [self resetAudioEngine];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(audioSessionRouteDidChanged:)
                                                     name:AVAudioSessionRouteChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)start {
    if (self.isRunning) {
        return;
    }
    
    [self startSession];
    self.running = YES;
}

- (void)stop {
    if (!self.isRunning) {
        return;
    }
    
    [self stopSession];
    self.running = NO;
}

- (NSInteger)numberOfOptions {
    return self.options.count;
}

- (NSInteger)numberOfInputs {
    return AVAudioSession.sharedInstance.currentRoute.inputs.count;
}

- (NSInteger)numberOfOutputs {
    return AVAudioSession.sharedInstance.currentRoute.outputs.count;
}

- (NSString *)nameForOptionWithIndex:(NSInteger)index {
    AudioOption *option = self.options[index];
    NSString *name = option.name;
    if (option.isOn) {
        name = [NSString stringWithFormat:@"%@ [ON]", name];
    }
    return name;
}

- (NSString *)nameForInputWithIndex:(NSInteger)index {
    AVAudioSessionPortDescription *input = AVAudioSession.sharedInstance.currentRoute.inputs[index];
    return input.portName;
}

- (NSString *)nameForOutputWithIndex:(NSInteger)index {
    AVAudioSessionPortDescription *output = AVAudioSession.sharedInstance.currentRoute.outputs[index];
    return output.portName;
}

- (void)toggleOptionWithIndex:(NSInteger)index {    
    AudioOption *option = self.options[index];
    option.on = !option.on;
    [self resumeSession];
}

#pragma mark - Private

- (void)resetAudioSession {
    AVAudioSessionCategoryOptions options = AVAudioSessionCategoryOptionMixWithOthers;
    for (AudioOption *option in self.options) {
        if (option.isOn) {
            options = options | option.option;
        }
    }
    
    AVAudioSession *session = AVAudioSession.sharedInstance;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord
                                          mode:AVAudioSessionModeDefault
                                       options:options
                                         error:nil];
}

- (void)resetAudioEngine {
    if (self.audioEngine) {
        [self.audioEngine stop];
        self.audioEngine = nil;
    }
    
    self.audioEngine = [AVAudioEngine new];
    [self.audioEngine connect:self.audioEngine.inputNode to:self.audioEngine.mainMixerNode format:nil];
    [self.audioEngine connect:self.audioEngine.mainMixerNode to:self.audioEngine.outputNode format:nil];
}

- (void)startSession {
    [AVAudioSession.sharedInstance setActive:YES error:nil];
    [self.audioEngine startAndReturnError:nil];
}

- (void)stopSession {
    [self.audioEngine stop];
    [AVAudioSession.sharedInstance setActive:NO error:nil];
}

- (void)resumeSession {
    [self resetAudioSession];
    [self resetAudioEngine];
    if (self.isRunning) {
        [self startSession];
    }
}

#pragma mark - Notification

- (void)audioSessionRouteDidChanged:(NSNotification *)notification {
    NSNumber *reasonValue = (NSNumber *)notification.userInfo[AVAudioSessionRouteChangeReasonKey];
    AVAudioSessionRouteChangeReason reason = reasonValue.unsignedIntegerValue;
    if (reason == AVAudioSessionRouteChangeReasonNewDeviceAvailable ||
        reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        [self resumeSession];
    }
    [self.delegate audioEchoDidChanged:self];
}

@end
