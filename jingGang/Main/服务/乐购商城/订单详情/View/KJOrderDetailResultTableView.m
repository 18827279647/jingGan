//
//  KJOrderDetailResultTableView.m
//  jingGang
//
//  Created by 张康健 on 15/8/12.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "KJOrderDetailResultTableView.h"
#import "KJOrderdetailResultCell.h"
#import "GlobeObject.h"
@implementation KJOrderDetailResultTableView


static NSString *KJOrderdetailResultCellID = @"KJOrderdetailResultCellID";

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        [self registerNib:[UINib nibWithNibName:@"KJOrderdetailResultCell" bundle:nil] forCellReuseIdentifier:KJOrderdetailResultCellID];
    }
    
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"--%lu",(unsigned long)self.resultData.count);
    return self.resultData.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ZhengZhuangAllCell *cell = [self dequeueReusableCellWithIdentifier:zhengZhuangAllCellID forIndexPath:indexPath];
//
    KJOrderdetailResultCell *cell = [tableView dequeueReusableCellWithIdentifier:KJOrderdetailResultCellID forIndexPath:indexPath];
    
    NSDictionary *dic = self.resultData[indexPath.row];
    NSString *key = [dic allKeys][0];
    
    NSLog(@"数据是:%@", dic);
    
    cell.firstItemLabel.text = key;
    NSString *priceStr = [NSString stringWithFormat:@"%@",dic[key]];
//    cell.secondItemLabel.text = [dic[key] stringValue];
    cell.secondItemLabel.text = priceStr;
    if ([key isEqualToString:@"实付金额"]) {
        cell.secondItemLabel.textColor = JGColor(96, 187, 177, 1);
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 43;
    
}




@end
