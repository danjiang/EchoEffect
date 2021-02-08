//
//  AudioEcho.h
//  EchoEffect
//
//  Possible Route:
//      Build-In Mic -> Build-In Receiver
//      Build-In Mic -> Build-In Speaker
//      Build-In Mic -> Headphones
//      HeadsetMic -> Headphones
//
//  Created by Dan Jiang on 2021/2/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AudioEcho;

@protocol AudioEchoDelegate <NSObject>

- (void)audioEchoDidChanged:(AudioEcho *)audioEcho;

@end

@interface AudioEcho : NSObject

@property (nonatomic, weak) id<AudioEchoDelegate> delegate;

- (void)start;
- (void)stop;
- (NSInteger)numberOfOptions;
- (NSInteger)numberOfInputs;
- (NSInteger)numberOfOutputs;
- (NSString *)nameForOptionWithIndex:(NSInteger)index;
- (NSString *)nameForInputWithIndex:(NSInteger)index;
- (NSString *)nameForOutputWithIndex:(NSInteger)index;
- (void)toggleOptionWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
