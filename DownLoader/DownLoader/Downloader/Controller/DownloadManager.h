//
//  DownloadManager.h
//  DownLoader
//
//  Created by bfec on 17/2/14.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadModel.h"
#import "AFURLSessionManager.h"
#import "DownloadCacher.h"
#import "DownloadManager_M3U8.h"

#define DownloadingUpdateNotification @"DownloadingUpdateNotification"
#define DownloadBeginNotification @"DownloadBeginNotification"
#define DownloadFinishNotification @"DownloadFinishNotification"
#define DownloadFailedNotification @"DownloadFailedNotification"
#define UIDeviceBatteryLowPowerNotification @"UIDeviceBatteryLowPowerNotification"
#define DownloadM3U8AnalyseFailedNotification @"DownloadM3U8AnalyseFailedNotification"

@interface DownloadManager : NSObject

@property (nonatomic,strong) AFURLSessionManager *urlSession;
@property (nonatomic,strong) DownloadCacher *downloadCacher;

+ (id)shareInstance;
- (void)dealDownloadModel:(DownloadModel *)downloadModel;
- (void)addDownloadModel:(DownloadModel *)downloadModel;
- (void)pauseDownloadModel:(DownloadModel *)downloadModel;
- (void)deleteDownloadModelArr:(NSArray *)downloadArr;
- (void)startAllDownload;
- (void)pauseAllDownload;
- (void)initializeDownloadModelFromDBCahcher:(DownloadModel *)downloadModel;

- (void)_tryToOpenNewDownloadTask;
- (void)dealDownloadFinishedOrFailedWithError:(NSError *)error andDownloadModel:(DownloadModel *)downloadModel;

@end
