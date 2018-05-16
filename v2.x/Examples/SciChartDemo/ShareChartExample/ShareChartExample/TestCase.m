//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// TestCase.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "TestCase.h"

static NSString *kFIFOTypeTest = @"FIFOSpeedTestSciChart";
static NSString *kSeriesTypeTest = @"NxMSeriesSpeedTestSciChart";
static NSString *kScatterTypeTest = @"ScatterSpeedTestSciChart";
static NSString *kAppendTypeTest = @"AppendSpeedTestSciChart";
static NSString *kSeriesAppendTypetest = @"SCDSeriesAppendingTestSciChart";

@implementation TestCase{
    __weak UIView<SpeedTest>* _chartUIView;
    double             fpsdata;
    double             cpudata;
    NSMutableArray*    result;
    NSString*          testcaseName;
    NSDate*            chartProviderStartTime;
    NSTimeInterval     chartTakenTime;
    Boolean            calculateStartTime;
    BOOL _timeIsOut;
}

- (instancetype)initWithVersion:(NSString*)version
                    chartUIView:(UIView<SpeedTest>*)chartUIView {
    
    self = [super init];
    if(self){
        self.chartTypeTest = NSStringFromClass([chartUIView class]);
        self.testParameters = [self parametersForTypeTest:self.chartTypeTest];
        self.version = version;
        _chartUIView = chartUIView;
    }
    return self;
}

- (TestParameters)parametersForTypeTest:(NSString*)typeTest {
    if ([typeTest isEqualToString:kScatterTypeTest]) {
        return (TestParameters){ .PointCount = 20000, .Duration = 10.0};
    }
    else if ([typeTest isEqualToString:kFIFOTypeTest]) {
        return (TestParameters){ .PointCount = 1000, .StrokeThikness = 1, .Duration = 10.0};
    }
    else if ([typeTest isEqualToString:kSeriesTypeTest]) {
        return (TestParameters){.SeriesNumber = 100, .PointCount = 100, .StrokeThikness = 1, .Duration = 10.0};
    }
    else if ([typeTest isEqualToString:kAppendTypeTest]) {
        return (TestParameters){ .PointCount = 10000, .AppendPoints = 1000, .StrokeThikness = 1, .Duration = 10.0};
    }
    else if ([typeTest isEqualToString:kSeriesAppendTypetest]) {
        return (TestParameters){ .PointCount = 500, .AppendPoints = 500, .StrokeThikness = 0.5, .Duration = 30.0, .SeriesNumber = 3};
    }
    return (TestParameters){ .PointCount = 1000, .Duration = 10.0};;
}

-(void)runTest{
    result = [[NSMutableArray alloc]init];
    [self running];
}

-(void)running{
    _timeIsOut = NO;
    chartProviderStartTime = [NSDate date];
    
    if([_chartUIView conformsToProtocol:@protocol(SpeedTest)]){
//        _chartUIView.delegate = self;
        [_chartUIView runTest:_testParameters];
        [self startDisplayLink];
    }
}

#pragma Drawing protocol callback function

-(void)processCompleted{
    if (!_timeIsOut) {
        [self pv_prepareResults];
    }
    [self stopDisplayLink];
    [_chartUIView processCompleted:result];
}

-(void)chartExampleStarted{
    if(calculateStartTime){
        chartTakenTime = fabs([chartProviderStartTime timeIntervalSinceNow]);
        calculateStartTime = false;
    }
}

#pragma Calcualting FPS & CPU Usage data

- (void)startDisplayLink{
    self.completed = NO;
    calculateStartTime = true;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(calcFps:)];
    
    self.startTime = CACurrentMediaTime();
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopDisplayLink{
    self.completed = YES;
    [self.displayLink invalidate];
    self.displayLink = nil;
}

-(void)calcFps:(CADisplayLink *)displayLink {
    self.frameCount++;
    
    CFTimeInterval elapsed = [displayLink timestamp] - self.startTime;
    
    if (elapsed >= _testParameters.Duration) {
        _timeIsOut = YES;
        [self pv_prepareResults];
        [_chartUIView stopTest];
    }
    else{
        [_chartUIView updateChart];
    }
}

-(float) cpu_usage{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0;
    
    basic_info = (task_basic_info_t)tinfo;
    
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    }
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

- (void)pv_prepareResults {

    CFTimeInterval elapsed = [self.displayLink timestamp] - self.startTime;
    
    fpsdata = self.frameCount / elapsed;
    cpudata = [self cpu_usage];
    
    self.frameCount = 0;
    self.startTime = [self.displayLink timestamp];

    if (_chartUIView) {
        [result addObject:@[@"", _chartUIView.chartProviderName, [[NSNumber alloc]initWithDouble:fpsdata], [[NSNumber alloc]initWithDouble:cpudata], [NSDate dateWithTimeIntervalSinceReferenceDate:chartTakenTime]]];
    }
}

- (void)interaptTest {
    [self.displayLink invalidate];
    self.displayLink = nil;
    _chartUIView = nil;
}

@end
