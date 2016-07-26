//
//  LZCleanCaches.h
//  CleanCachesDemo
//
//  Created by lz on 16/7/26.
//  Copyright © 2016年 lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZCleanCaches : NSObject

//单例模式的调用LZCleanCaches
+ (LZCleanCaches *) sharedInstance;

- (void)getCacheSize:(void (^)(NSString *size))completion;
- (void)cleanCache:(void(^)(void))completion;
@end
