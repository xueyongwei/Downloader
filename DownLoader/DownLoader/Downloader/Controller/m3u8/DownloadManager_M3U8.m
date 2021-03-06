//
//  DownloadManager_M3U8.m
//  DownLoader
//
//  Created by bfec on 17/3/8.
//  Copyright © 2017年 com. All rights reserved.
//

#import "DownloadManager_M3U8.h"
#import "M3U8Analyser.h"
#import "DownloadManager+Utils.h"
#import "M3U8SegmentListDownloader.h"

static DownloadManager_M3U8 *instance;

@interface DownloadManager_M3U8 ()<M3U8SegmentListDownloaderDelegate>

@property (nonatomic,strong) M3U8Analyser *analyser;
@property (nonatomic,strong) M3U8SegmentList *downloading_m3u8SegmentList;
@property (nonatomic,strong) M3U8SegmentListDownloader *segmentListDownloader;
@property (nonatomic,strong) DownloadModel *downloadModel;

@end

@implementation DownloadManager_M3U8

+ (instancetype)shareInstance
{
    static dispatch_once_t token1;
    dispatch_once(&token1, ^{
        instance = [[DownloadManager_M3U8 alloc] init];
    });
    return instance;
}

- (M3U8Analyser *)analyser
{
    if (!_analyser)
    {
        _analyser = [[M3U8Analyser alloc] init];
    }
    return _analyser;
}

- (M3U8SegmentListDownloader *)segmentListDownloader
{
    if (!_segmentListDownloader)
    {
        _segmentListDownloader = [M3U8SegmentListDownloader shareInstance];
        _segmentListDownloader.delegate = self;
        _segmentListDownloader.urlSession = self.urlSession;
        _segmentListDownloader.downloadCacher = self.downloadCacher;
    }
    return _segmentListDownloader;
}

- (void)pauseDownloadModel:(DownloadModel *)downloadModel withResumeData:(NSData *)resumeData
{
    [self.segmentListDownloader pauseDownload:downloadModel withResumeData:resumeData];
}

- (void)m3u8Downloading:(DownloadModel *)downloadModel withInfo:(NSDictionary *)m3u8Info
{
    NSError *error = nil;
    self.downloading_m3u8SegmentList = [self.analyser analyseVideoUrl:downloadModel.url error:&error];
    if (error)
    {
        downloadModel.error = error;
        if ([self.delegate respondsToSelector:@selector(m3u8Downloader:analyseFailed:)])
        {
            [self.delegate m3u8Downloader:self analyseFailed:downloadModel];
        }
    }
    else
    {
        self.downloadModel = downloadModel;
        [self.segmentListDownloader startDownload:self.downloadModel andSegmentList:self.downloading_m3u8SegmentList withInfo:m3u8Info];
    }
}




#pragma mark - segmentlistdownloaderdelegate
- (void)m3u8SegmentListDownloader:(M3U8SegmentListDownloader *)segmentListDownloader beginDownload:(DownloadModel *)downloadModel segment:(M3U8SegmentInfo *)segment task:(NSURLSessionDownloadTask *)task
{
    if ([self.delegate respondsToSelector:@selector(m3u8Downloader:beginDownload:segment:task:)])
    {
        [self.delegate m3u8Downloader:self beginDownload:self.downloadModel segment:segment task:task];
    }
}


- (void)m3u8SegmentListDownloader:(M3U8SegmentListDownloader *)segmentListDownloader updateDownload:(DownloadModel *)downloadModel progress:(CGFloat)progress
{
    if ([self.delegate respondsToSelector:@selector(m3u8Downloader:updateDownload:progress:)])
    {
        [self.delegate m3u8Downloader:self updateDownload:self.downloadModel progress:progress];
    }
}


- (void)m3u8SegmentListDownloader:(M3U8SegmentListDownloader *)segmentListDownloader pauseDownload:(DownloadModel *)downloadModel resumeData:(NSData *)resumeData tsIndex:(NSInteger)tsIndex alreadyDownloadSize:(long long)alreadyDownloadSize
{
    if ([self.delegate respondsToSelector:@selector(m3u8Downloader:pauseDownload:resumeData:tsIndex:alreadyDownloadSize:)])
    {
        [self.delegate m3u8Downloader:self pauseDownload:downloadModel resumeData:resumeData tsIndex:tsIndex alreadyDownloadSize:alreadyDownloadSize];
    }
}

- (void)m3u8SegmentListDownloader:(M3U8SegmentListDownloader *)segmentListDownloader failedDownload:(DownloadModel *)downloadModel
{
    if ([self.delegate respondsToSelector:@selector(m3u8Downloader:failedDownload:)])
    {
        [self.delegate m3u8Downloader:self failedDownload:downloadModel];
    }
}

- (void)m3u8SegmentListDownloader:(M3U8SegmentListDownloader *)segmentListDownloader finishDownload:(DownloadModel *)downloadModel
{
    if ([self.delegate respondsToSelector:@selector(m3u8Downloader:finishDownload:)])
    {
        [self.delegate m3u8Downloader:self finishDownload:downloadModel];
    }
}













@end
