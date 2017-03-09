//
//  AudioRecorder.h
//  AudioAnalyzer
//
//  Created by Yaroslav Pelyukh on 2/23/17.
//  Copyright © 2017 Yaroslav Pelyukh. All rights reserved.
//

#ifndef SpeechBookWormSwift_AudioRecorder_h
#define SpeechBookWormSwift_AudioRecorder_h

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioFile.h>
#import <SciChart/SciChart.h>

#define NUM_BUFFERS 60
typedef void (^samplesToEngine)(float*);

typedef struct
{
    AudioStreamBasicDescription dataFormat;
    AudioQueueRef               queue;
    AudioQueueBufferRef         buffers[NUM_BUFFERS];
    AudioFileID                 audioFile;
    SInt64                      currentPacket;
    bool                        recording;
}RecordState;

void AudioInputCallback(void * inUserData,  // Custom audio metadata
                        AudioQueueRef inAQ,
                        AudioQueueBufferRef inBuffer,
                        const AudioTimeStamp * inStartTime,
                        UInt32 inNumberPacketDescriptions,
                        const AudioStreamPacketDescription * inPacketDescs);

@interface AudioRecorder : NSObject {
    RecordState recordState;
}

- (void)setupAudioFormat:(AudioStreamBasicDescription*)format;
- (void)startRecording;
- (void)stopRecording;

//- (void)formSamplesToEngine: (int) capacity samples:(float*) samples;
//- (void)formFFTSamples: (int) capacity samples:(float*) samples;

@property samplesToEngine sampleToEngineDelegate;
@property samplesToEngine fftSamplesDelegate;
@property samplesToEngine spectrogramSamplesDelegate;
@property NSDate *runningTimeInterval;

@end
#endif
