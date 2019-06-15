//
//  YSSelecteCityView.m
//  jingGang
//
//  Created by dengxf on 16/11/23.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSSelecteCityView.h"

@interface YSSelecteCityView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSMutableArray *dataArray;
@property (copy , nonatomic) id_block_t  selectedCallback;
@property (assign, nonatomic) BOOL showHeaderView;

@end

@implementation YSSelecteCityView

- (instancetype)initWithFrame:(CGRect)frame citys:(NSArray *)citys selected:(id_block_t)selectedCallback showHeaderView:(BOOL)show
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.showHeaderView = show;
        self.dataArray = [NSMutableArray arrayWithArray:citys];
        self.selectedCallback = selectedCallback;
        NSDictionary *tempDict = @{@"areaName":@"已开通热门城市"};
        NSArray *tempArray = @[tempDict];
        [self.dataArray xf_safeInsertObject:tempArray atIndex:0];
        [self setup];
    }
    return self;
}

- (void)setup {
    UIView *headerView = [UIView new];
    headerView.x = 0;
    headerView.width = self.width;
    headerView.y = 0.;
    headerView.height = 120. + 48;
    headerView.backgroundColor = JGColor(247, 247, 247, 1);
    
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_selectecity_icon"]];
    iconImage.x = (self.width - 30.) / 2;
    iconImage.y = 26.;
    iconImage.width = 30.;
    iconImage.height = 32.;
    [headerView addSubview:iconImage];
    
    UILabel *textLab1 = [UILabel new];
    textLab1.x = 0;
    textLab1.y = MaxY(iconImage) + 5.;
    textLab1.width = ScreenWidth;
    textLab1.height = 22.;
    textLab1.textAlignment = NSTextAlignmentCenter;
    textLab1.text = @"很抱歉，您所在的城市暂未开通周边服务";
    textLab1.font = JGFont(14.);
    textLab1.textColor = [UIColor lightGrayColor];
    [headerView addSubview:textLab1];
    
    UILabel *textLab2 = [UILabel new];
    textLab2.x = 0;
    textLab2.y = MaxY(textLab1);
    textLab2.width = ScreenWidth;
    textLab2.height = 22.;
    textLab2.textAlignment = NSTextAlignmentCenter;
    textLab2.text = @"请先查看其它已开通城市的服务!";
    textLab2.font = JGFont(14.);
    textLab2.textColor = [UIColor lightGrayColor];
    [headerView addSubview:textLab2];
    
    UIView *searchView = [UIView new];
    searchView.x = 0;
    searchView.y = MaxY(textLab2) + 12.;
    searchView.width = ScreenWidth;
    searchView.height = 48;
    [headerView addSubview:searchView];
    [searchView addSubview:[self searchCityView]];
    
    UIView *sepView = [UIView new];
    sepView.x = 0;
    sepView.y = headerView.height - 0.8;
    sepView.width = self.width;
    sepView.height = 0.4;
    sepView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.4];
    [headerView addSubview:sepView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionIndexColor =[YSThemeManager buttonBgColor];
    tableView.sectionIndexBackgroundColor = JGClearColor;
    tableView.tableFooterView = [UIView new];
    if (self.showHeaderView) {
        tableView.tableHeaderView = headerView;
    }else {
        tableView.tableHeaderView = [self searchCityView];
    }
    [self addSubview:tableView];
}

- (UIView *)searchCityView {
    UIView *searchView = [UIView new];
    searchView.backgroundColor = JGColor(247, 247, 247, 1);
    searchView.x = 0;
    searchView.y = 0;
    searchView.width = ScreenWidth;
    searchView.height = 48.;
    
    UIView *searchBgView = [UIView new];
    searchBgView.backgroundColor = JGWhiteColor;
    searchBgView.x = 14. ;
    searchBgView.width = (searchView.width - searchBgView.x * 2);
    searchBgView.height = 34.;
    searchBgView.y = (searchView.height - searchBgView.height) / 2;
    [searchView addSubview:searchBgView];
    searchBgView.layer.cornerRadius = searchBgView.height / 2;
    searchBgView.clipsToBounds = YES;
    
    UIImage *iconImage = [UIImage imageNamed:@"ys_near_searchglass"];
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:iconImage];
    iconImageView.width = 16.;
    iconImageView.height = 16.;
    iconImageView.x = 12.;
    iconImageView.y = (searchBgView.height - iconImageView.height) / 2;
    [searchBgView addSubview:iconImageView];
    
    UILabel *searchTextLab = [UILabel new];
    searchTextLab.x = MaxX(iconImageView) + 10.;
    searchTextLab.y = 4.;
    searchTextLab.height = (searchBgView.height - searchTextLab.y * 2);
    searchTextLab.width = searchBgView.width - searchTextLab.x * 2;
    searchTextLab.text = @"请输入城市名或拼音查询";
    searchTextLab.textAlignment = NSTextAlignmentLeft;
    searchTextLab.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
    searchTextLab.font = JGFont(15);
    [searchBgView addSubview:searchTextLab];
    
    UIButton *searchCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchCityButton.frame = searchBgView.bounds;
    [searchCityButton addTarget:self action:@selector(searchCithAction) forControlEvents:UIControlEventTouchUpInside];
    [searchBgView addSubview:searchCityButton];
    return searchView;
}

- (void)searchCithAction {
    JGLog(@"---searchCithAction");
    if ([self.delegate respondsToSelector:@selector(didClickSearckWithSelecteCityView:)]) {
        [self.delegate didClickSearckWithSelecteCityView:self];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)[self.dataArray xf_safeObjectAtIndex:section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self indexs];
}

- (NSArray *)indexs {
    return [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellId = @"identifierId";
    UITableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *indexCity = [self.dataArray xf_safeObjectAtIndex:indexPath.section];
    NSLog(@"section：%d,row:%d,%@",indexPath.section,indexPath.row,indexCity);
    NSDictionary *cityDict = [indexCity xf_safeObjectAtIndex:indexPath.row];
    cell.textLabel.text = [cityDict objectForKey:@"areaName"];
    if (indexPath.row == 0 && indexPath.section == 0) {
        cell.textLabel.textColor = JGBlackColor;
        cell.textLabel.font = JGFont(17.);
    }else {
        cell.textLabel.textColor = [UIColor grayColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0 && indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return;
    }else {
        NSArray *indexCities = [self.dataArray xf_safeObjectAtIndex:indexPath.section];
        NSDictionary *dict = [indexCities xf_safeObjectAtIndex:indexPath.row];
        BLOCK_EXEC(self.selectedCallback,dict);
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *indexCities = [self.dataArray xf_safeObjectAtIndex:section];
    if (indexCities.count) {
        NSDictionary *indexDict = [indexCities xf_safeObjectAtIndex:0];
        return [indexDict objectForKey:@"firstChar"];
    }
    return @"";
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UILabel *label = [UILabel new];
//    label.x = 10;
//    label.y = 0;
//    label.width = ScreenWidth - label.x * 2;
//    label.height = 20;
//    label.backgroundColor = JGRandomColor;
//    label.text = [NSString stringWithFormat:@"section:%ld",section];
//    return label;
//
//}

@end

