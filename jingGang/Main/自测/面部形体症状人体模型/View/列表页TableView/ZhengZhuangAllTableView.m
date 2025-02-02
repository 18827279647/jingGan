//
//  ZhengZhuangAllTableView.m
//  jingGang
//
//  Created by 张康健 on 15/6/4.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "ZhengZhuangAllTableView.h"
#import "ZhengZhuangAllCell.h"
#import "ZhengZhuangCureTable.h"


@implementation ZhengZhuangAllTableView

static NSString *zhengZhuangAllCellID = @"zhengZhuangAllCellID";

-(id)initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self _init];
        
    }
    
    return self;
}


-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{

    self = [super initWithFrame:frame style:style];
    if (self) {
        
        [self _init];
    }

    return self;
}

-(void)_init{

    self.delegate = self;
    self.dataSource = self;
    
    [self registerNib:[UINib nibWithNibName:@"ZhengZhuangAllCell" bundle:nil]  forCellReuseIdentifier:zhengZhuangAllCellID];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.data.count;
//    return 5;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZhengZhuangAllCell *cell = [self dequeueReusableCellWithIdentifier:zhengZhuangAllCellID forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    if (indexPath.row==0) {//指定第一行为选中状态
        
             [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
 

    cell.zhengzhuangLabel.highlightedTextColor = [UIColor colorWithRed:0/255.0 green:180/255.0 blue:140/255.0 alpha:1];//选中label颜色的变化
    

    NSDictionary *dic = self.data[indexPath.row];
    if (self.isFaceClickTable) {

        cell.zhengzhuangLabel.text = dic[@"icName"];
    }else{
        cell.zhengzhuangLabel.text = dic[@"name"];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return [self.cellHeightArr[indexPath.row] floatValue];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        NSDictionary *dic = self.data[indexPath.row];
        long ID = [dic[@"id"] longValue];
        if (self.clickZhengZhuangItemBlock) {
            self.clickZhengZhuangItemBlock(ID);
        }
}






@end
