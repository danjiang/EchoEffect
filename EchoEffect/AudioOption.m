//
//  AudioOption.m
//  EchoEffect
//
//  Created by Dan Jiang on 2021/2/8.
//

#import "AudioOption.h"

@implementation AudioOption

- (instancetype)initWithName:(NSString *)name option:(AVAudioSessionCategoryOptions)option {
    self = [super init];
    if (self) {
        self.name = name;
        self.option = option;
    }
    return self;
}

@end
