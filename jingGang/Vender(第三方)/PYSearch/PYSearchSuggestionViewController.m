//
//  PYSearchSuggestionViewController.m
//  PYSearchViewControllerExample
//
//  Created by 谢培艺 on 2016/10/22.
//  Copyright © 2016年 CoderKo1o. All rights reserved.
//

#import "PYSearchSuggestionViewController.h"
#import "PYSearchConst.h"

@interface PYSearchSuggestionViewController ()

@property (strong,nonatomic) UIView *nodataView;

@end

@implementation PYSearchSuggestionViewController


- (UIView *)nodataView {
    if (!_nodataView) {
        _nodataView = [[UIView alloc] init];
        _nodataView.backgroundColor = JGWhiteColor;
        _nodataView.frame = self.view.bounds;
        UILabel *nodataLab = [UILabel new];
        nodataLab.x = 0;
        nodataLab.y = 100.;
        nodataLab.width = ScreenWidth;
        nodataLab.height = 28;
        nodataLab.text = @"抱歉，未能找到您要搜索的相关位置";
        nodataLab.textAlignment = NSTextAlignmentCenter;
        nodataLab.textColor = [UIColor grayColor];
        nodataLab.font = JGFont(17.);
        [_nodataView addSubview:nodataLab];
        [self.view addSubview:_nodataView];
    }
    return _nodataView;
}


+ (instancetype)searchSuggestionViewControllerWithDidSelectCellBlock:(PYSearchSuggestionDidSelectCellBlock)didSelectCellBlock
{
    PYSearchSuggestionViewController *searchSuggestionVC = [[PYSearchSuggestionViewController alloc] init];
    searchSuggestionVC.didSelectCellBlock = didSelectCellBlock;
    return searchSuggestionVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setSearchSuggestions:(NSArray<NSString *> *)searchSuggestions
{
    if (searchSuggestions.count) {
        self.nodataView.hidden = YES;
    }else {
        self.nodataView.hidden = NO;
    }
    _searchSuggestions = [searchSuggestions copy];
    // 刷新数据
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.searchSuggestions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([self unfindSearchResult]) {
//        return 160.;
//    }
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"PYSearchSuggestionCellID";
    // 创建cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.backgroundColor = [UIColor clearColor];
        // 添加分割线
        UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PYSearch.bundle/cell-content-line"]];
        line.py_height = 0.5;
        line.alpha = 0.7;
        line.py_x = PYMargin;
        line.py_y = 43;
        line.py_width = PYScreenW;
        [cell.contentView addSubview:line];
//        if ([self unfindSearchResult]) {
//            UILabel *unfindResultLab = [UILabel new];
//            unfindResultLab.x = 0;
//            unfindResultLab.y = 0;
//            unfindResultLab.width = ScreenWidth;
//            unfindResultLab.height = 160.;
//            unfindResultLab.textAlignment = NSTextAlignmentCenter;
//            unfindResultLab.textColor = [UIColor grayColor];
//            unfindResultLab.font = JGFont(17);
//            unfindResultLab.tag = 1000;
//            [cell.contentView addSubview:unfindResultLab];
//        }else {
//            UILabel *unfindResultLab = (UILabel *)[cell.contentView viewWithTag:1000];
//            [unfindResultLab removeFromSuperview];
//        }
    }
    
    // 设置数据
    cell.imageView.image = PYSearchSuggestionImage;
    NSDictionary *dict = [self.searchSuggestions xf_safeObjectAtIndex:indexPath.row];
//    
//    if ([self unfindSearchResult]) {
//        UILabel *unfindResultLab = (UILabel *)[cell.contentView viewWithTag:1000];
//        unfindResultLab.text = [dict objectForKey:@"areaName"];
//    }else {
        cell.textLabel.text = [dict objectForKey:@"areaName"];
//    }
    return cell;
}

- (BOOL)unfindSearchResult {
    if (self.searchSuggestions.count == 1) {
        NSDictionary *unfindDict = [self.searchSuggestions xf_safeObjectAtIndex:0];
        NSString *unfindLocateString = [unfindDict objectForKey:@"areaName"];
        if ([unfindLocateString isEqualToString:@"抱歉，未能找到您要搜索的相关位置"]) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectCellBlock) self.didSelectCellBlock([tableView cellForRowAtIndexPath:indexPath],[self.searchSuggestions xf_safeObjectAtIndex:indexPath.row]);
}

-(void)dealloc {
    
}

@end
