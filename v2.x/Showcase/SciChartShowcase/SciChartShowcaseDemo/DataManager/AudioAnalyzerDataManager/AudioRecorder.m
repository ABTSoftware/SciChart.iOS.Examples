//
//  AudioRecorder.m
//  AudioAnalyzer
//
//  Created by Yaroslav Pelyukh on 2/23/17.
//  Copyright © 2017 Yaroslav Pelyukh. All rights reserved.
//

#import "AudioRecorder.h"
#import <Accelerate/Accelerate.h>

#define AUDIO_DATA_TYPE_FORMAT int

@implementation AudioRecorder{
    FFTSetup fftSetup;
    uint length;
    float _max;
    float _min;
}

void *refToSelf;

@synthesize sampleToEngineDelegate;
@synthesize fftSamplesDelegate;
@synthesize spectrogramSamplesDelegate;

void AudioInputCallback(void * inUserData,
                        AudioQueueRef inAQ,
                        AudioQueueBufferRef inBuffer,
                        const AudioTimeStamp * inStartTime,
                        UInt32 inNumberPacketDescriptions,
                        const AudioStreamPacketDescription * inPacketDescs) {
    __weak AudioRecorder *rec = (__bridge AudioRecorder *) refToSelf;
//    NSDate* date = [NSDate date];
    RecordState * recordState = (RecordState*)inUserData;
    
    if (!recordState->recording) {
        return;
    }
    AudioQueueEnqueueBuffer(recordState->queue, inBuffer, 0, NULL);
    
//    if ([date timeIntervalSince1970] - [rec.runningTimeInterval timeIntervalSince1970] > 0.01){
        rec.runningTimeInterval = [NSDate date];
        int* samples = (AUDIO_DATA_TYPE_FORMAT*)inBuffer->mAudioData;
    
    
    if (inNumberPacketDescriptions != 4096) {
        return;
    }
    
        [rec formSamplesToEngine:inNumberPacketDescriptions samples:samples];
//    }
//    else {
    
//    }
}

- (id)init {
    self = [super init];
    if (self) {
        refToSelf = (__bridge void *)(self);
        _max = 0.0f;
        _min = 0.0f;
    }
    return self;
}

- (void)setupAudioFormat:(AudioStreamBasicDescription*)format {
    format->mSampleRate = 44100;
    
    format->mFormatID = kAudioFormatLinearPCM;
    format->mFormatFlags = kAudioFormatFlagIsSignedInteger;
    format->mFramesPerPacket  = 1;
    format->mChannelsPerFrame = 1;
    format->mBytesPerFrame    = sizeof(AUDIO_DATA_TYPE_FORMAT);
    format->mBytesPerPacket   = sizeof(AUDIO_DATA_TYPE_FORMAT);
    format->mBitsPerChannel   = sizeof(AUDIO_DATA_TYPE_FORMAT) * 8;
}

- (void)startRecording{
    
    [self setupAudioFormat:&recordState.dataFormat];
    recordState.currentPacket = 0;
    
    _runningTimeInterval = [NSDate date];
    
    OSStatus status;
    status = AudioQueueNewInput(&recordState.dataFormat,
                                AudioInputCallback,
                                &recordState,
                                CFRunLoopGetCurrent(),
                                kCFRunLoopCommonModes,
                                0,
                                &recordState.queue);
    
    if (status == 0) {
        
        for (int i = 0; i < NUM_BUFFERS; i++) {
            AudioQueueAllocateBuffer(recordState.queue, 4096*recordState.dataFormat.mBytesPerFrame, &recordState.buffers[i]);
            AudioQueueEnqueueBuffer(recordState.queue, recordState.buffers[i], 0, nil);
        }
        
        recordState.recording = true;
        
        status = AudioQueueStart(recordState.queue, NULL);
        
        length = (uint)floor(log2(2048));

        fftSetup = vDSP_create_fftsetup(length, kFFTRadix2);
    }
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
    
//    NSLog(@"max FFT Value = %i and min FFT Value = %i", _max, _min);
}

- (void)formSamplesToEngine: (int)capacity samples: (int*)samples {
    AudioRecorder *rec = (__bridge AudioRecorder *) refToSelf;
    
    if ([rec sampleToEngineDelegate] != nil){
        [rec sampleToEngineDelegate](samples);
    }

    float* fftArray = [self calculateFFT:samples size:capacity];
    if ([rec fftSamplesDelegate] != nil){
        [rec fftSamplesDelegate]((float* )fftArray);
    }

    float *heatMap = malloc(sizeof(float)*capacity);
    memcpy(heatMap, fftArray, sizeof(float)*capacity);
    if ([rec spectrogramSamplesDelegate] != nil){
        [rec spectrogramSamplesDelegate]((float* )heatMap);
    }
    
}

- (float*) calculateFFT: (int*)data size:(uint)numSamples{
    
    float *dataFloat = malloc(sizeof(float)*numSamples);
    for (int i = 0; i < numSamples; i++) {
        dataFloat[i] = (float)data[i]*1.0f;
    }
    
    
    DSPSplitComplex tempSplitComplex;
    tempSplitComplex.imagp = malloc(sizeof(float)*(numSamples/2));
    tempSplitComplex.realp = malloc(sizeof(float)*(numSamples/2));
    
    
    COMPLEX* complex = (COMPLEX*)dataFloat;
    
    vDSP_ctoz(complex, 2, &tempSplitComplex, 1, numSamples/2);
    
    vDSP_fft_zip(fftSetup, &tempSplitComplex, 1, length, FFT_FORWARD);
    
    float* result = malloc(sizeof(float)*(numSamples/2));

    for (int i = 0 ; i < numSamples/2; i++) {
        
        float current = (sqrt(tempSplitComplex.realp[i]*tempSplitComplex.realp[i] + tempSplitComplex.imagp[i]*tempSplitComplex.imagp[i]) * 0.000025);
        current = log10(current);
        result[i] = current;
        
        if (current > _max && !isinf(current)) {
            _max = current;
        }
        if (current < _min && !isinf(current)) {
            _min = current;
        }
    }
    
    free(dataFloat);
    free(tempSplitComplex.imagp);
    free(tempSplitComplex.realp);
    
    return result;
}


@end
