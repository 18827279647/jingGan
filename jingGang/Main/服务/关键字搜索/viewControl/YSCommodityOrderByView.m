//
//  YSCommodityOrderByView.m
//  jingGang
//
//  Created by Eric Wu on 2019/6/8.
//  Copyright © 2019 dengxf_dev. All rights reserved.
//

#import "YSCommodityOrderByView.h"
#import "YSCommodityOrderByCell.h"

@interface YSCommodityOrderByView()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray<NSDictionary *> *sortSource;

@end
@implementation YSCommodityOrderByView
+ (instancetype)commodityOrderByView
{
    NSArray *nib = [CRBundle loadNibNamed:@"YSCommodityOrderByView" owner:self options:nil];
    UIView *tmpCustomView = [nib objectAtIndex:0];
    return (YSCommodityOrderByView *)tmpCustomView;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.sortSource = [NSMutableArray array];
    [self.sortSource addObject:@{@"name": @"综合排序", @"key": @"add_time", @"sort": @"desc"}];
    [self.sortSource addObject:@{@"name": @"价格由低到高", @"key": @"goods_current_price", @"sort": @"asc"}];
    [self.sortSource addObject:@{@"name": @"价格由高到低", @"key": @"goods_current_price", @"sort": @"desc"}];
    [self.tableView registerNib:[UINib nibWithNibName:@"YSCommodityOrderByCell" bundle:nil] forCellReuseIdentifier:@"YSCommodityOrderByCell"];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sortSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSCommodityOrderByCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSCommodityOrderByCell"];
    NSDictionary *dict = [self.sortSource objectAtIndex:indexPath.row];
    cell.lblTitle.text = dict[@"name"];
    BOOL selected = NO;
    if (self.selected) {
        selected = [self.selected[@"name"] isEqualToString:cell.lblTitle.text];
    }
    cell.check.hidden = !selected;
    if (selected) {
        cell.lblTitle.textColor = UIColorHex(#65BBB1);
    }
    else
    {
        cell.lblTitle.textColor = UIColorHex(#666666);
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = [self.sortSource objectAtIndex:indexPath.row];
    if (dict == self.selected) {
        return;
    }
    self.selected = dict;
    if (self.didSelected) {
        self.didSelected(dict);
    }
}

@end
