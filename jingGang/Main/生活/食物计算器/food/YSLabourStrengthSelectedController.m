//
//  YSLabourStrengthSelectedController.m
//  jingGang
//
//  Created by dengxf on 2017/9/16.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSLabourStrengthSelectedController.h"
#import "YSLabourStrengthCell.h"

@interface YSLabourStrengthSelectedController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (copy , nonatomic) msg_block_t rowSelectedCallback;

@property (copy , nonatomic) voidCallback cancelCallback;

@end

@implementation YSLabourStrengthSelectedController

- (instancetype)initWithSelecteRow:(msg_block_t)rowSelectedCallback cancel:(voidCallback)cancelCallback
{
    self = [super init];
    if (self) {
        _rowSelectedCallback = rowSelectedCallback;
        _cancelCallback = cancelCallback;
    }
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat tX = 30;
        CGFloat tH = 5 * 44 + 52.;
        CGFloat tY = (ScreenHeight - tH) / 2 - [YSAdaptiveFrameConfig height:20];
        CGFloat tW = ScreenWidth - tX * 2;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(tX, tY, tW, tH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 6.;
        _tableView.clipsToBounds = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 5:
            return 52.;
            break;
        default:
            return 44.;
            break;
    }
    return 44.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YSLabourStrengthCell setupCellWithTableView:tableView indexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            
            break;
        case 5:
        {
            BLOCK_EXEC(self.cancelCallback);
        }
            break;
        default:
        {
            YSLabourStrengthCell *cell = (YSLabourStrengthCell *)[tableView cellForRowAtIndexPath:indexPath];
            BLOCK_EXEC(self.rowSelectedCallback,[[cell datas] xf_safeObjectAtIndex:indexPath.row]);
        }
            break;
    }

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
}


@end
