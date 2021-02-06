//
//  AudioEcho.m
//  EchoEffect
//
//  Created by Dan Jiang on 2021/2/6.
//

#import "AudioEcho.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioEcho ()

@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, assign, getter=isRunning) BOOL running;

@end

@implementation AudioEcho

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self resetAudioSession];
        [self resetAudioEngine];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(audioSessionDidInterrupt:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:nil];
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

#pragma mark - Private

- (void)resetAudioSession {
    AVAudioSession *session = AVAudioSession.sharedInstance;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord
                                          mode:AVAudioSessionModeDefault
                                       options:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionAllowBluetoothA2DP
                                         error:nil];
    for (AVAudioSessionPortDescription *description in session.availableInputs) {
        NSLog(@"%@", description);
        if ([description.UID isEqualToString:@"Wired Microphone"]) {
            [session setPreferredInput:description error:nil];
            break;
        }
    }
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

- (void)audioSessionDidInterrupt:(NSNotification *)notification {
}

- (void)audioSessionRouteDidChanged:(NSNotification *)notification {
    NSLog(@"%@", AVAudioSession.sharedInstance.currentRoute);
}

@end
