//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AudioRecorder.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioFile.h>
#import <AVFoundation/AVFoundation.h>

#define NUM_BUFFERS 30

typedef void (^samplesToEngine)(int *);
typedef void (^samplesToEngineFloat)(float *);
typedef void (^samplesToEngineDouble)(double *);

typedef struct {
    AudioStreamBasicDescription dataFormat;
    AudioQueueRef               queue;
    AudioQueueBufferRef         buffers[NUM_BUFFERS];
    AudioFileID                 audioFile;
    SInt64                      currentPacket;
    bool                        recording;
} RecordState;

void AudioInputCallback(void *inUserData, // Custom audio metadata
                        AudioQueueRef inAQ,
                        AudioQueueBufferRef inBuffer,
                        const AudioTimeStamp *inStartTime,
                        unsigned int inNumberPacketDescriptions,
                        const AudioStreamPacketDescription *inPacketDescs);

@interface AudioRecorder : NSObject {
    RecordState recordState;
}

@property (nonatomic) int *samples;
@property (nonatomic) float *fftData;

- (void)startRecording:(int)sampleRate andMinBufferSize:(int)minBufferSize;
- (void)stopRecording;

- (float *)calculateFFT:(int *)data size:(unsigned int)numSamples;

@end
