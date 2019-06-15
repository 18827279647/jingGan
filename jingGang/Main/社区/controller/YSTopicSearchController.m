//
//  YSTopicSearchController.m
//  jingGang
//
//  Created by dengxf on 16/8/4.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSTopicSearchController.h"

@interface YSTopicSearchController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>

@property (strong,nonatomic)  UIImageView * navBarHairlineImageView;

@property (strong,nonatomic) UITableView *tableView;

/**
 *  tableview数据源 */
@property (strong,nonatomic) NSMutableArray *dataArray;

/**
 *  系统推送 */
@property (strong,nonatomic) NSMutableArray *systemArray;

/**
 *  实时搜索数据源 */
@property (strong,nonatomic) NSMutableArray *searchArray;

/**
 *  最近使用 */
@property (strong,nonatomic) NSMutableArray *recentUsedArray;

@property (strong,nonatomic) UITextField *textField;

@property (copy , nonatomic) void(^selectedTopicCallback) (CircleLabel *);

@property (assign, nonatomic) BOOL searchResult;


@end

@implementation YSTopicSearchController


- (instancetype)initWithSelectedTopicCallback:(void(^)(CircleLabel *))selectedCallback
{
    self = [super init];
    if (self) {
        self.selectedTopicCallback = selectedCallback;
    }
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat tableX = 0;
        CGFloat tableY = 0;
        CGFloat tableW = ScreenWidth;
        CGFloat tableH = ScreenHeight;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(tableX, tableY, tableW, tableH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)searchArray {
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

- (NSMutableArray *)systemArray {
    if (!_systemArray) {
        _systemArray = [NSMutableArray array];
    }
    return _systemArray;
}

- (NSMutableArray *)recentUsedArray {
    if (!_recentUsedArray) {
        _recentUsedArray = [NSMutableArray array];
        [_recentUsedArray xf_safeAddObjectsFromArray:(NSArray *)[self achieve]];
    }
    return _recentUsedArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  初始化界面 */
    [self setup];
    [self buildTableView];
    
    /**
     *  请求系统话题 */
    [self buildRequest];
}

- (void)buildRequest {
    @weakify(self);
    [self showHud];
    [YSFriendCircleRequestManager labelListSuccess:^(NSArray *respones) {
        @strongify(self);
        [self.systemArray removeAllObjects];
        [self.systemArray xf_safeAddObjectsFromArray:respones];
        [self.dataArray xf_safeAddObject:self.systemArray];
        [self.dataArray xf_safeAddObject:self.recentUsedArray];
        [self.tableView reloadData];
        [self hiddenHud];
        [self showSuccessHudWithText:@"更新数据..."];
    } fail:^{
        @strongify(self);
        [self hiddenHud];
        [self showErrorHudWithText:@"加载失败..."];
    } error:^{
        @strongify(self);
        [self hiddenHud];
        [self showErrorHudWithText:@"网络错误..."];
    }];
}

-(void)dealloc {

}

- (void)buildTableView {
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(NavBarHeight, 0, 0, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navBarHairlineImageView.hidden = YES;
}

- (void)setup {
    self.view.backgroundColor = JGWhiteColor;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.searchResult = YES;
    UIView *navBarView = [[UIView alloc] init];
    navBarView.x = 10;
    navBarView.y = 8;
    navBarView.width = ScreenWidth - navBarView.x - 48;
    navBarView.height = 30;
    navBarView.layer.cornerRadius = 5;
    navBarView.clipsToBounds = YES;
    self.navigationController.navigationBar.barTintColor = JGBaseColor;
    navBarView.backgroundColor = JGColor(248, 248, 248, 1);
    [self.navigationController.navigationBar addSubview:navBarView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.y = 4;
    cancelButton.x = MaxX(navBarView);
    cancelButton.width = 48;
    cancelButton.height = 40;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = JGFont(16);
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton setTitleColor:JGBlackColor forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *leftImage = [UIImage imageNamed:@"ys_healtymanage_#"]; // 16 13
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:leftImage];
    leftImageView.x = 4;
    leftImageView.height = leftImage.imageHeight;
    leftImageView.width = leftImage.imageWidth;
    leftImageView.y = (navBarView.height - leftImageView.height) / 2;
    [navBarView addSubview:leftImageView];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.x = MaxX(leftImageView) + 2;
    textField.width = navBarView.width - textField.x - 10;
    textField.y = 2;
    textField.height = navBarView.height - 4;
    [navBarView addSubview:textField];
    textField.tintColor = COMMONTOPICCOLOR;
    textField.font = JGFont(14);
    textField.returnKeyType = UIReturnKeySearch;
    textField.delegate = self;
    self.textField = textField;
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    UIImageView * navBarHairlineImageView = [self findHairlineImageViewUnder:navigationBar];
    self.navBarHairlineImageView = navBarHairlineImageView;
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)cancel {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSMutableArray *sections = [self.dataArray xf_safeObjectAtIndex:section];
    if (!self.searchResult) {
        return @"无搜索结构结果";
    }else {
        NSArray *headerStrings = @[@"推荐话题",@"最近使用"];
        return [headerStrings xf_safeObjectAtIndex:section];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.dataArray xf_safeObjectAtIndex:section];
    return sections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellId = @"identifierId";
    UITableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    NSArray *sections = [self.dataArray xf_safeObjectAtIndex:indexPath.section];
    
    id object = [sections xf_safeObjectAtIndex:indexPath.row];
    
    if ([object isKindOfClass:[NSString class]]) {
        cell.textLabel.text = [NSString stringWithFormat:@" 添加 #%@#",object];
    }else if ([object isKindOfClass:[CircleLabel class]]) {
        CircleLabel *label = (CircleLabel *)object;
        cell.textLabel.text = label.labelName;
    }
    cell.textLabel.font = JGFont(16);
    return cell;
}

#define KDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject]
#define kRecentTopicInfoPath [KDocumentPath stringByAppendingPathComponent:@"rencentTopic.archiver"]

- (void)saveLabel:(CircleLabel *)label {
    NSMutableArray *recents = [NSMutableArray arrayWithArray:[self achieve]];
    
    for (CircleLabel *savaLabel in recents) {
        if ([label isEqualLabelA:savaLabel]) {
            /**
             *  标签相同 */
            return;
        }
    }
    
    [recents xf_safeAddObject:label];
    
    NSArray *saves = [NSArray array];
    if (recents.count > 6) {
        saves = [recents subarrayWithRange:NSMakeRange(recents.count - 6, 6)];
    }else {
        saves = [recents copy];
    }
    
    BOOL ret =  [NSKeyedArchiver archiveRootObject:saves toFile:kRecentTopicInfoPath];
    if (ret) {
        JGLog(@"保存成功");
    }else {
        JGLog(@"保存失败");
    }
}

- (NSArray *)achieve {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:kRecentTopicInfoPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    [self.textField resignFirstResponder];
    NSArray *selecteds = [self.dataArray xf_safeObjectAtIndex:indexPath.section];
    
    if (indexPath.section == 0) {
        id object = [selecteds xf_safeObjectAtIndex:indexPath.row];
        if ([object isKindOfClass:[NSString class]]) {
            @weakify(self);
            [YSFriendCircleRequestManager addNewTopicWithTopicName:[NSString stringWithFormat:@"%@",object] success:^(CircleLabel *label){
                @strongify(self);
                BLOCK_EXEC(self.selectedTopicCallback,label);
                [self dismissViewControllerAnimated:YES completion:NULL];
            } fail:^{
                
            } error:^{
                
            }];
            return;
        }else if ([object isKindOfClass:[CircleLabel class]]) {
            CircleLabel *label = (CircleLabel *)object;
            [self saveLabel:label];
        }
        BLOCK_EXEC(self.selectedTopicCallback,[selecteds xf_safeObjectAtIndex:indexPath.row]);
        [self dismissViewControllerAnimated:YES completion:NULL];
    }else {
        BLOCK_EXEC(self.selectedTopicCallback,[selecteds xf_safeObjectAtIndex:indexPath.row]);
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    [self.textField resignFirstResponder];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length == 0) {
        if (self.systemArray.count > 0) {
            [self.dataArray removeAllObjects];
            [self.dataArray xf_safeAddObject:self.systemArray];
            [self.dataArray xf_safeAddObject:self.recentUsedArray];
            [self.tableView reloadData];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField.text.length == 0) {
        return YES;
    }
    @weakify(self);
    [YSFriendCircleRequestManager actualtimeRequestSearchKeyword:textField.text success:^(NSArray *searches) {
        @strongify(self);
        
        if (searches.count) {
            self.searchResult = YES;
        }else {
            self.searchResult = NO;
        }
        
        [self.searchArray removeAllObjects];
        [self.dataArray removeAllObjects];
        [self.searchArray xf_safeAddObjectsFromArray:searches];
        [self.dataArray xf_safeAddObject:self.searchArray];
        BOOL ret = [self labels:searches containName:textField.text];
        
        if (ret) {
            
        }else {
            [self.searchArray xf_safeAddObject:textField.text];
        }
//        [self.dataArray xf_safeAddObject:self.recentUsedArray];
        [self.tableView reloadData];
    } fail:^{
        @strongify(self);
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];

    } error:^{
        @strongify(self)
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
    }];
    return YES;
}


- (BOOL)labels:(NSArray *)labels containName:(NSString *)contains {
    for (CircleLabel *label in labels) {
        if ([label.labelName isEqualToString:contains]) {
            return YES;
        }
        
        if ([label.labelName isEqualToString:[NSString stringWithFormat:@"#%@#",contains]]) {
            return YES;
        }
    }
    return NO;
}


@end
