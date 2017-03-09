//
//  M3U8SegmentDownloader.m
//  DownLoader
//
//  Created by bfec on 17/3/9.
//  Copyright © 2017年 com. All rights reserved.
//

#import "M3U8SegmentDownloader.h"

@implementation M3U8SegmentDownloader

- (void)startDownload:(M3U8SegmentInfo *)segment
{
    NSURL *url = [NSURL URLWithString:segment.url];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    __weak M3U8SegmentInfo *weakSegment = segment;
    
    NSURLSessionDownloadTask *task = [self.urlSession downloadTaskWithRequest:request
                                    progress:^(NSProgress * _Nonnull downloadProgress) {
        
                                        
                                        if ([self.delegate respondsToSelector:@selector(m3u8SegmentDownloader:downloadingUpdateProgress:)])
                                        {
                                            [self.delegate m3u8SegmentDownloader:self downloadingUpdateProgress:downloadProgress];
                                        }
                                        
                                        
                                    }
                                 destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                     return [NSURL fileURLWithPath:weakSegment.localUrl];
                                 }
                           completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                               
                               [self _dealFinishOrFailedSegment:segment error:error];
                               
                           }];
    [task resume];
    if ([self.delegate respondsToSelector:@selector(m3u8SegmentDownloader:downloadingBegin:task:)])
    {
        [self.delegate m3u8SegmentDownloader:self downloadingBegin:segment task:task];
    }
}


- (void)_dealFinishOrFailedSegment:(M3U8SegmentInfo *)segment error:(NSError *)error
{
    if (error)
    {
        
        //手动暂停的
        if ([error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData])
        {
            NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
            if ([self.delegate respondsToSelector:@selector(m3u8SegmentDownloader:downloadingPause:resumeData:)])
            {
                [self.delegate m3u8SegmentDownloader:self downloadingPause:segment resumeData:resumeData];  
            }
        }
        //下载出现错误
        else
        {
            if ([self.delegate respondsToSelector:@selector(m3u8SegmentDownloader:downloadFailed:)])
            {
                [self.delegate m3u8SegmentDownloader:self downloadFailed:error];
            }
        }

        
    }
    else//finish
    {
        if ([self.delegate respondsToSelector:@selector(m3u8SegmentDownloader:downloadingFinished:)])
        {
            [self.delegate m3u8SegmentDownloader:self downloadingFinished:segment];
        }
    }
}






























@end