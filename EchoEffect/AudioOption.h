//
//  AudioOption.h
//  EchoEffect
//
//  Created by Dan Jiang on 2021/2/8.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioOption : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) AVAudioSessionCategoryOptions option;
@property (nonatomic, assign, getter=isOn) BOOL on;

- (instancetype)initWithName:(NSString *)name option:(AVAudioSessionCategoryOptions)option;

@end

NS_ASSUME_NONNULL_END
