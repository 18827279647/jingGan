//
//  ZongHeZhengTableView.m
//  jingGang
//
//  Created by 张康健 on 15/6/4.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "ZongHeZhengTableView.h"
#import "ZongHeZhengCell.h"
#import "UIButton+Block.h"
#import "CheckGroup.h"
#import "UIView+BlockGesture.h"
#import "GlobeObject.h"

@implementation ZongHeZhengTableView

static NSString *zongHeZhengCellID = @"zongHeZhengCellID";

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"ZongHeZhengCell" bundle:nil]  forCellReuseIdentifier:zongHeZhengCellID];
        self.backgroundColor = JGColor(239, 239, 239, 1);
        self.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    }
    
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.data.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZongHeZhengCell *cell = [self dequeueReusableCellWithIdentifier:zongHeZhengCellID forIndexPath:indexPath];
    CheckGroup *checkGroup = self.data[indexPath.row];
    cell.checkGroup = checkGroup;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    @weakify(self);
    @weakify(checkGroup)
    //查看详情 转换了 2017-09-15
    [cell.beginTestBtn addActionHandler:^(NSInteger tag) {
        @strongify(self);
        @strongify(checkGroup);
        if (self.selfTestDetailBlock) {
            self.selfTestDetailBlock(checkGroup.apiId.longValue,checkGroup.groupTitle,checkGroup.content,checkGroup.thumbnail);
        }
    }];
    
    cell.self_test_Img.userInteractionEnabled = YES;
    [cell.self_test_Img addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        @strongify(checkGroup);
        UNLOGIN_HANDLE
        if (self.beginTestBlock) {
            //self.beginTestBlock([checkGroup.apiId longValue]);
            self.beginTestBlock(checkGroup.apiId.longValue,checkGroup.groupTitle,checkGroup.content,checkGroup.thumbnail);
        }
    }];

    // 开始测试
    [cell.lookDetailBtn addActionHandler:^(NSInteger tag) {
        @strongify(self);
        @strongify(checkGroup);
        UNLOGIN_HANDLE
        if (self.beginTestBlock) {
            self.beginTestBlock(checkGroup.apiId.longValue,checkGroup.groupTitle,checkGroup.content,checkGroup.thumbnail);
        }
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UNLOGIN_HANDLE
    CheckGroup *checkGroup = self.data[indexPath.row];
    if (self.beginTestBlock) {
        //self.beginTestBlock([checkGroup.apiId longValue]);
        self.beginTestBlock(checkGroup.apiId.longValue,checkGroup.groupTitle,checkGroup.content,checkGroup.thumbnail);
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    return [self.dataCellHeightArr[indexPath.row] floatValue];
    
    return 348 - 32;
    
    
    
}




@end
