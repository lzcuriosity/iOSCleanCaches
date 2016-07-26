//
//  ViewController.m
//  CleanCachesDemo
//
//  Created by lz on 16/7/26.
//  Copyright © 2016年 lz. All rights reserved.
//

#import "ViewController.h"
#import "LZCleanCaches.h"
#import "MBProgressHUD.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy) NSString *cacheSize;
@property (nonatomic,strong) UIAlertView *alertView;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    
    
    
    //为caches写入假数据
    for (int i = 0; i < 500; i++)
    {
        NSString *filePath= [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"newFile%d.txt",i]];
        NSString *fileContent = @"我们的开始 是很长的电影 放映了三年 我票都还留着 冰上的芭蕾 脑海中还在旋转 望着你 慢慢忘记你 朦胧的时间 我们溜了多远 冰刀画的圈 圈起了谁改变 如果再重来 会不会稍嫌狼狈 爱是不是 不开口才珍贵 再给我两分钟 让我把记忆结成冰 别融化了眼泪 你妆都花了 要我怎么记得 记得你叫我忘了吧 记得你叫我忘了吧 你说你会哭 不是因为在乎 朦胧的时间 我们溜了多远 冰刀画的圈 圈起了谁改变 如果再重来 会不会稍嫌狼狈 爱是不是 不开口才珍贵";
        NSData *fileData = [fileContent dataUsingEncoding:NSUTF8StringEncoding];
        [fileManager createFileAtPath:filePath contents:fileData attributes:nil];
    }

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.cacheSize = @"计算中";
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* reuseIdentifier = @"tableviewcellidentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.row) {
        case 0: {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"缓存清理";
            cell.detailTextLabel.text = _cacheSize;
            
            [[LZCleanCaches sharedInstance] getCacheSize:^(NSString *size) {
                self.cacheSize = size;
                cell.detailTextLabel.text = _cacheSize;
                if (_alertView)
                {
                    self.alertView.message = [NSString stringWithFormat:@"缓存大小：%@",_cacheSize];
                }
            }];
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row)
    {
        case 0:
        {
            //缓存清理
            if ([_cacheSize isEqualToString:@"0M"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"没有可清理的缓存！";
                [hud hideAnimated:YES afterDelay:1.0];
            }else
            {
                if (!_alertView)
                {
                    self.alertView = [[UIAlertView alloc] initWithTitle:@"缓存清理" message:[NSString stringWithFormat:@"缓存大小：%@",_cacheSize] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                }
                [self.alertView show];
            }
        }
            break;

        default:
            break;
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1: {
            [[LZCleanCaches sharedInstance] cleanCache:^{
                [self.tableView reloadData];
            }];
        }
            break;
            
        default:
            break;
    }
}


@end
