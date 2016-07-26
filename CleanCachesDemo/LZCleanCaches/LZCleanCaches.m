//
//  LZCleanCaches.m
//  CleanCachesDemo
//
//  Created by lz on 16/7/26.
//  Copyright © 2016年 lz. All rights reserved.
//

#import "LZCleanCaches.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface LZCleanCaches()

@property (copy, nonatomic) NSString *cacheFilePath;
@property (strong, nonatomic)  NSFileManager *fileManager;

@end

@implementation LZCleanCaches

+ (LZCleanCaches *) sharedInstance
{
    static LZCleanCaches *cleanCacheManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        cleanCacheManager = [[self alloc] init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        cleanCacheManager.cacheFilePath =[paths objectAtIndex:0];
        cleanCacheManager.fileManager = [NSFileManager defaultManager];
    });
    
    return cleanCacheManager;
}

#pragma mark - 计算缓存大小
- (void)getCacheSize:(void (^)(NSString *size))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        float folderSize = 0;
        if ([_fileManager fileExistsAtPath:_cacheFilePath]) {
            NSArray *subPaths = [_fileManager subpathsAtPath:_cacheFilePath];
            
            for (NSString *fileName in subPaths) {
                NSString *absolutePath = [_cacheFilePath stringByAppendingPathComponent:fileName];
                folderSize += [[_fileManager attributesOfItemAtPath:absolutePath error:nil]fileSize];
            }
            
            folderSize = folderSize / (1024*1024);
        }
        
        NSString *sumSize;
        if (folderSize < 0.1)
        {
            sumSize = @"0M";
        }else
        {
            sumSize = [NSString stringWithFormat:@"%.2fM",folderSize];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(sumSize);
        });
        
    });
}

#pragma mark - 删除缓存
- (void)cleanCache:(void(^)(void))completion
{
    UIViewController *topController = [[UIApplication sharedApplication].delegate.window rootViewController];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:topController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"缓存清理中..";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if ([_fileManager fileExistsAtPath:_cacheFilePath]) {
            NSArray *subPaths = [_fileManager subpathsAtPath:_cacheFilePath];
            
            for (NSString *fileName in subPaths) {
                
                NSString *absolutePath = [_cacheFilePath stringByAppendingPathComponent:fileName];
                BOOL isDirectory = NO;
                [_fileManager fileExistsAtPath:absolutePath isDirectory:&isDirectory];
                
                if (!isDirectory) {
                    NSError *error;
                    [_fileManager removeItemAtPath:absolutePath error:&error];
                    NSLog(@"Error removing file at path: %@", error.localizedDescription);
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"清理完成";
                [hud hideAnimated:YES afterDelay:1.0];
                completion();
            });
        }
    });
}


@end



