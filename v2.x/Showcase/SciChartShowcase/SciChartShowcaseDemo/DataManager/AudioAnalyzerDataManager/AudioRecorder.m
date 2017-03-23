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
    AudioQueueEnqueueBuffer(recordState->queue, inBuffer, 0, NULL);
    
//    if ([date timeIntervalSince1970] - [rec.runningTimeInterval timeIntervalSince1970] > 0.01){
        rec.runningTimeInterval = [NSDate date];
        int* samples = (AUDIO_DATA_TYPE_FORMAT*)inBuffer->mAudioData;
        [rec formSamplesToEngine:inNumberPacketDescriptions samples:samples];
//    }
//    else {
    
//    }
}

- (id)init {
    self = [super init];
    if (self) {
        refToSelf = (__bridge void *)(self);
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
            AudioQueueAllocateBuffer(recordState.queue, 2048*recordState.dataFormat.mBytesPerFrame, &recordState.buffers[i]);
            AudioQueueEnqueueBuffer(recordState.queue, recordState.buffers[i], 0, nil);
        }
        
        recordState.recording = true;
        
        status = AudioQueueStart(recordState.queue, NULL);
        
        length = (uint)floor(log2(80));
        fftSetup = vDSP_create_fftsetup(length, kFFTRadix2);
    }
}

- (void)stopRecording {
    vDSP_destroy_fftsetup(fftSetup);
    
    recordState.recording = false;
    AudioQueueStop(recordState.queue, true);
    
    for (int i = 0; i < NUM_BUFFERS; i++) {
        AudioQueueFreeBuffer(recordState.queue, recordState.buffers[i]);
    }
    
    AudioQueueDispose(recordState.queue, true);
    AudioFileClose(recordState.audioFile);
}

- (void)formSamplesToEngine: (int)capacity samples: (int*)samples {
    AudioRecorder *rec = (__bridge AudioRecorder *) refToSelf;
    
    if ([rec sampleToEngineDelegate] != nil){
        [rec sampleToEngineDelegate](samples);
        
    }
    
//    AUDIO_DATA_TYPE_FORMAT* fftArray = [self calculateFFT:samples size:capacity];
//    
//    if ([rec fftSamplesDelegate] != nil){
//        [rec fftSamplesDelegate]((AUDIO_DATA_TYPE_FORMAT* )fftArray);
//    }
//    if ([rec spectrogramSamplesDelegate] != nil){
//        [rec spectrogramSamplesDelegate]((AUDIO_DATA_TYPE_FORMAT* )fftArray);
//    }
}

- (float*) calculateFFT: (float[])data size:(uint)numSamples{
    DSPSplitComplex tempSplitComplex;
    tempSplitComplex.imagp = malloc(sizeof(AUDIO_DATA_TYPE_FORMAT)*(numSamples));
    tempSplitComplex.realp = malloc(sizeof(AUDIO_DATA_TYPE_FORMAT)*(numSamples));
    
    vDSP_ctoz((COMPLEX*)data, 1.0, &tempSplitComplex, 1.0, numSamples);
    vDSP_fft_zip(fftSetup, &tempSplitComplex, 1.0, length, FFT_FORWARD);
    
    AUDIO_DATA_TYPE_FORMAT* result = malloc(sizeof(AUDIO_DATA_TYPE_FORMAT)*(numSamples));
    for (int i =0 ; i<numSamples; i++) {
        result[i] = sqrt(tempSplitComplex.realp[i]*tempSplitComplex.realp[i] + tempSplitComplex.imagp[i]*tempSplitComplex.imagp[i]) * 0.025;
    }
    
    return result;
}

@end
