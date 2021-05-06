//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AudioRecorder.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "AudioRecorder.h"
#import <Accelerate/Accelerate.h>

#define AUDIO_DATA_TYPE_FORMAT int

@implementation AudioRecorder {
    FFTSetup fftSetup;
    unsigned int length;
    float _max;
    float _min;
}

void *refToSelf;

void AudioInputCallback(void *inUserData,
                        AudioQueueRef inAQ,
                        AudioQueueBufferRef inBuffer,
                        const AudioTimeStamp *inStartTime,
                        unsigned int inNumberPacketDescriptions,
                        const AudioStreamPacketDescription *inPacketDescs) {
    __weak AudioRecorder *rec = (__bridge AudioRecorder *)refToSelf;
    RecordState *recordState = (RecordState *)inUserData;
    
    if (!recordState->recording) return;
    
    AudioQueueEnqueueBuffer(recordState->queue, inBuffer, 0, NULL);
    
    int *samples = (AUDIO_DATA_TYPE_FORMAT *)inBuffer->mAudioData;
    if (inNumberPacketDescriptions != 2048) return;
    
    [rec formSamplesToEngine:inNumberPacketDescriptions samples:samples];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        refToSelf = (__bridge void *)(self);
        _max = 0.0f;
        _min = 0.0f;
    }
    return self;
}

- (void)startRecording:(int)sampleRate andMinBufferSize:(int)minBufferSize {
    [self setupAudioFormat:&recordState.dataFormat withSampleRate:sampleRate];
    recordState.currentPacket = 0;
    
    OSStatus status = AudioQueueNewInput(&recordState.dataFormat, AudioInputCallback, &recordState, CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &recordState.queue);
    if (status == errSecSuccess) {
        for (int i = 0; i < NUM_BUFFERS; i++) {
            AudioQueueAllocateBuffer(recordState.queue, minBufferSize * recordState.dataFormat.mBytesPerFrame, &recordState.buffers[i]);
            AudioQueueEnqueueBuffer(recordState.queue, recordState.buffers[i], 0, nil);
        }
    }
    
    recordState.recording = true;
    status = AudioQueueStart(recordState.queue, NULL);
    if (status == errSecSuccess) {
        length = (unsigned int)floor(log2(minBufferSize));
        fftSetup = vDSP_create_fftsetup(length, kFFTRadix2);
    }
}

- (void)setupAudioFormat:(AudioStreamBasicDescription *)format withSampleRate:(int)sampleRate {
    format->mSampleRate       = sampleRate;
    format->mFormatID         = kAudioFormatLinearPCM;
    format->mFormatFlags      = kAudioFormatFlagIsSignedInteger;
    format->mFramesPerPacket  = 1;
    format->mChannelsPerFrame = 1;
    format->mBytesPerFrame    = sizeof(AUDIO_DATA_TYPE_FORMAT);
    format->mBytesPerPacket   = sizeof(AUDIO_DATA_TYPE_FORMAT);
    format->mBitsPerChannel   = sizeof(AUDIO_DATA_TYPE_FORMAT) * 8;
}

- (void)stopRecording {
    recordState.recording = false;
    
    vDSP_destroy_fftsetup(fftSetup);
    AudioQueueStop(recordState.queue, true);
    
    for (int i = 0; i < NUM_BUFFERS; i++) {
        AudioQueueFreeBuffer(recordState.queue, recordState.buffers[i]);
    }
    
    AudioQueueDispose(recordState.queue, true);
    AudioFileClose(recordState.audioFile);
}

- (void)formSamplesToEngine:(int)capacity samples: (int*)samples {
    self.samples = samples;
    self.fftData = [self calculateFFT:samples size:capacity];
}

- (float *)calculateFFT:(int *)data size:(unsigned int)numSamples {
    float *dataFloat = malloc(sizeof(float) * numSamples);
    vDSP_vflt32(data, 1, dataFloat, 1, numSamples);
    
    DSPSplitComplex tempSplitComplex;
    tempSplitComplex.imagp = malloc(sizeof(float) * numSamples);
    tempSplitComplex.realp = malloc(sizeof(float) * numSamples);
    
    DSPComplex *audioBufferComplex = malloc(sizeof(DSPComplex) * numSamples);
    
    for (unsigned int i = 0; i < numSamples; i++) {
        audioBufferComplex[i].real = dataFloat[i];
        audioBufferComplex[i].imag = 0.0f;
    }
    
    vDSP_ctoz(audioBufferComplex, 2, &tempSplitComplex, 1, numSamples);
    vDSP_fft_zip(fftSetup, &tempSplitComplex, 1, length, FFT_FORWARD);
    
    float *result = malloc(sizeof(float) * numSamples);
    for (unsigned int i = 0 ; i < numSamples; i++) {
        float current = sqrt(tempSplitComplex.realp[i] * tempSplitComplex.realp[i] + tempSplitComplex.imagp[i] * tempSplitComplex.imagp[i]) * 0.000025;
        current = log10(current) * 10;
        result[i] = current;
    }
    
    free(dataFloat);
    free(audioBufferComplex);
    free(tempSplitComplex.imagp);
    free(tempSplitComplex.realp);
    
    return result;
}

@end
