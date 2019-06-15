//
//  YSFriendCircleDetailController.m
//  jingGang
//
//  Created by dengxf on 16/7/30.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSFriendCircleDetailController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "GlobeObject.h"
#import "YSShareManager.h"
#import "YSFriendCircleFrame.h"
#import "YSFriendCircleCell.h"
#import "YSFriendCircleRequestManager.h"
#import "YSFriendCircleModel.h"
#import "YSCommentFrame.h"
#import "YSCircleDetailCell.h"
#import "YYTextKeyboardManager.h"
#import "YSCircleCommentView.h"
#import "YSDetailCirclePriseView.h"

typedef NS_ENUM(NSUInteger, YSSelectedCellWithType) {
    YSSelectedCellWithNoneType = 0,
    YSSelectedCellWithCommentType,
    YSSelectedCellWithReplyType
};

@interface YSFriendCircleDetailController ()<UITableViewDelegate,UITableViewDataSource,YYTextKeyboardObserver,UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIWebView *web;
@property (copy , nonatomic) NSString *uid;
@property (copy , nonatomic) NSString *postId;
@property (strong,nonatomic) YSFriendCircleFrame *circleFrame;
@property (strong,nonatomic) NSArray *circles;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (strong,nonatomic) NSMutableArray *comments;
@property (assign, nonatomic) CGFloat history_Y_offset;
@property (assign, nonatomic) CGFloat selectedCellHeight;
@property (strong,nonatomic) YSCircleCommentView *msgSendView;
@property (assign, nonatomic) YSSelectedCellWithType selectedCellType;
@property (strong,nonatomic) YSCircleCommentView *msgSendView1;


/**
 *  点击cell当前的Frame模型*/
@property (strong,nonatomic) YSCommentFrame *selecetedCellFrame;

@property (strong,nonatomic) YSCommentFrame *requestFrame;

@property (strong,nonatomic) NSArray *praiseLists;

@property (assign, nonatomic) CGFloat differHeight;

@property (assign, nonatomic) CGRect toFrame;

@property (strong,nonatomic) YSDetailCirclePriseView *priseView;

@property (strong,nonatomic) NSMutableArray *photos;

@end

@implementation YSFriendCircleDetailController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}


- (NSMutableArray *)comments {
    if (!_comments) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight - 44) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (instancetype)initWithUid:(NSString *)uid postId:(NSString *)postid
{
    self = [super init];
    if (self) {
        self.uid = uid;
        self.postId = postid;
    }
    return self;
}

- (instancetype)initWithCircleModel:(YSFriendCircleFrame *)circleModel {
    self = [super init];
    if (self) {
        self.circles = @[circleModel];
        [[YYTextKeyboardManager defaultManager] addObserver:self];
    }
    return self;
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
    JGLog(@"---YSFriendCircleDetailController dealloc");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"进入的是这个页面吗");
    [super basicBuild];
    [YSThemeManager setNavigationTitle:@"详情" andViewController:self];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.dataArray xf_safeAddObject:self.circles];
    [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
    
    [self requestCommentsWithAnimated:YES];
    
    @weakify(self);
    if(iPhoneX_X){
         _msgSendView1 = [[YSCircleCommentView alloc] initWithFrame:CGRectMake(0, ScreenHeight - NavBarHeight-84, ScreenWidth, 44)];
    }else{
             _msgSendView1 = [[YSCircleCommentView alloc] initWithFrame:CGRectMake(0, ScreenHeight - NavBarHeight-44, ScreenWidth, 44)];
    }
   
    [self.view addSubview:_msgSendView1];
    self.msgSendView = _msgSendView1;
    self.msgSendView.sendMsgCallback = ^(){
        @strongify(self);
        [self sendMsgButtonUpdateInterface];
    };
    self.msgSendView.updateCommentHeight = ^(CGFloat height){
        @strongify(self);
        [UIView animateWithDuration:0.21 animations:^{
            self.msgSendView.height = height;
            self.msgSendView.textView.height = height - 12;
            self.msgSendView.bottom = CGRectGetMinY(self.toFrame);
        }];
    };
    self.selectedCellType = YSSelectedCellWithNoneType;
    return;
}

/**
 *  请求评论数据 */
- (void)requestCommentsWithAnimated:(BOOL)animated {
    YSFriendCircleFrame *frame = [self.circles xf_safeObjectAtIndex:0];
    @weakify(self);
    [YSFriendCircleRequestManager circleDetailWithPostId:frame.friendCircleModel.postId succeessCallback:^(NSArray *evaluateList,NSArray *praiseLists){
        @strongify(self);
        [self.comments removeAllObjects];
        [self.comments xf_safeAddObjectsFromArray:evaluateList];
        if (self.dataArray.count > 1) {
            [self.dataArray removeLastObject];
            [self.dataArray xf_safeAddObject:self.comments];
        }else {
            [self.dataArray xf_safeAddObject:self.comments];
        }
        
        self.praiseLists = praiseLists;
        
        [self.tableView reloadSection:1 withRowAnimation:(animated?UITableViewRowAnimationFade:UITableViewRowAnimationNone)];
        
    } failCallback:^{
        
    } errorCallback:^{
        
    }];
}

/**
 *  点击发送 更新界面 */
- (void)sendMsgButtonUpdateInterface {
    [self.msgSendView.textView resignFirstResponder];
    YSFriendCircleFrame *circleFrame = [self.circles xf_safeObjectAtIndex:0];
    @weakify(self);
    switch (self.selectedCellType) {
        case YSSelectedCellWithNoneType:
        {
            JGLog(@"评论帖子");
            [YSFriendCircleRequestManager circleEvalueteWithCircleId:[circleFrame.friendCircleModel.postId integerValue] content:self.msgSendView.textView.text successCallback:^{
                @strongify(self);
                [self requestCommentsWithAnimated:NO];
                
            } failCallback:^(NSString *subMsg){
                
                [UIAlertView xf_showWithTitle:@"评论失败!" message:subMsg delay:2.0 onDismiss:NULL];
            } errorCallback:^{
                [UIAlertView xf_showWithTitle:@"网络错误,请重新再试!" message:nil delay:2.0 onDismiss:NULL];
            }];
            
        }
            break;
        case YSSelectedCellWithCommentType:
        {
            
            JGLog(@"----评论某一条评论");
            [YSFriendCircleRequestManager circleReplyWithPostId:[circleFrame.friendCircleModel.postId integerValue]
                                                        content:self.msgSendView.textView.text
                                                      touUserId:[self.requestFrame.comment.fromUserid integerValue]
                                                            pid:[self.requestFrame.comment.commentId integerValue] successCallback:^{
                
                [self requestCommentsWithAnimated:NO];
                
            } failCallback:^(NSString *subMsg){
                [UIAlertView xf_showWithTitle:@"评论失败!" message:subMsg delay:2.0 onDismiss:NULL];
            } errorCallback:^{
                [UIAlertView xf_showWithTitle:@"网络错误,请重新再试!" message:nil delay:2.0 onDismiss:NULL];
            }];
            
        }
            break;
        case YSSelectedCellWithReplyType:
        {
            JGLog(@"----评论某一条回复:%@",self.selecetedCellFrame);
            [YSFriendCircleRequestManager circleReplyWithPostId:[circleFrame.friendCircleModel.postId integerValue]
                                                        content:self.msgSendView.textView.text
                                                      touUserId:[self.requestFrame.comment.fromUserid integerValue]
                                                            pid:[self.requestFrame.comment.commentId integerValue] successCallback:^{
                
                [self requestCommentsWithAnimated:NO];
                
            } failCallback:^(NSString *subMsg){
                [UIAlertView xf_showWithTitle:@"评论失败!" message:subMsg delay:2.0 onDismiss:NULL];
            } errorCallback:^{
                [UIAlertView xf_showWithTitle:@"网络错误,请重新再试!" message:nil delay:2.0 onDismiss:NULL];
            }];

        }
            break;
        default:
            break;
    }
    self.msgSendView.textView.placeholderText = @"评论:";
    self.selectedCellType = YSSelectedCellWithNoneType;
    self.msgSendView.textView.text = @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.01)];
        return view;
    }
    if (self.priseView) {
        if (self.praiseLists) {
            self.priseView.priseImages = self.praiseLists;
        }
        return self.priseView;
    }
    YSDetailCirclePriseView *priseView = [[YSDetailCirclePriseView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60.0)];
    priseView.priseImages = self.praiseLists;
    self.priseView = priseView;
    return self.priseView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }else if (section == 1) {
        return 60.0;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGFloat height = 0;
    if (section == 0) {
        height = 12;
    }else{
        height = 1;
    }
    UIView *footer = [UIView new];
    footer.backgroundColor = JGBaseColor;
    footer.frame = CGRectMake(0, 0, ScreenWidth, height);
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return  12;
    }else{
        return  1;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.dataArray xf_safeObjectAtIndex:section];
    return sections.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            NSArray *sections = [self.dataArray xf_safeObjectAtIndex:indexPath.section];
            YSFriendCircleFrame *frame = [sections xf_safeObjectAtIndex:indexPath.row];
//            if (frame.friendCircleModel.evaluateList.count) {
//                return frame.cellHeight - 44 - frame.commentsBgF.size.height - 20;
//            }else {
                return frame.cellHeight - 44 - frame.commentsBgF.size.height;
//            }
        }
            break;
        case 1:
        {
            NSArray *sections = [self.dataArray xf_safeObjectAtIndex:indexPath.section];
            YSCommentFrame *frame = [sections xf_safeObjectAtIndex:indexPath.row];
            return frame.cellHeight;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YSFriendCircleCell *cell = [YSFriendCircleCell setupCellWithTableView:tableView indexPath:indexPath];
        NSArray *sections = [self.dataArray xf_safeObjectAtIndex:indexPath.section];
        YSFriendCircleFrame *frame = [sections xf_safeObjectAtIndex:indexPath.row];
        frame.hiddenToolBar = YES;
        frame.hiddenCommentsBgView = YES;
        cell.circleFrame = frame;
        cell.clickImageCallback = ^(NSInteger index){
            
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }else if (indexPath.section == 1) {
        YSCircleDetailCell *cell = [YSCircleDetailCell configCircelDetailCellWithTableView:tableView indexPath:indexPath];
        NSArray *sections = [self.dataArray xf_safeObjectAtIndex:indexPath.section];
        YSCommentFrame *frame = [sections xf_safeObjectAtIndex:indexPath.row];
        cell.commentFrame = frame;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        @weakify(self);
        cell.didSelectedReplyCellCallback = ^(YSCommentFrame *replyFrame){
            @strongify(self);
            self.requestFrame = frame;
            [self beginCommentWithTableView:self.tableView indexPath:indexPath withSelcetedCellType:YSSelectedCellWithReplyType frame:replyFrame];
        };
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSArray *sections = [self.dataArray xf_safeObjectAtIndex:indexPath.section];
        YSCommentFrame *frame = [sections xf_safeObjectAtIndex:indexPath.row];

        self.requestFrame = frame;
        [self beginCommentWithTableView:tableView indexPath:indexPath withSelcetedCellType:YSSelectedCellWithCommentType frame:frame];
    }
}

- (void)beginCommentWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath withSelcetedCellType:(YSSelectedCellWithType)selectedCellType frame:(YSCommentFrame *)selectedFrame
{
    YSFriendCircleCell *cell = (YSFriendCircleCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect rect = [cell convertRect:cell.bounds toView:window];
    CGFloat history_Y_offset = rect.origin.y;
    self.history_Y_offset = history_Y_offset;
    
    /**
     *  点击回复时，当前的cell，此cell将移动到键盘上面 */
    NSArray *sections = [self.dataArray xf_safeObjectAtIndex:indexPath.section];
    YSCommentFrame *frame = [sections xf_safeObjectAtIndex:indexPath.row];
    
    /**
     *  区别点击的是评论的cell，还是回复的cell */
    self.selecetedCellFrame = selectedFrame;
    
    self.selectedCellHeight = frame.cellHeight;
    self.selectedCellType = selectedCellType;
    [self.msgSendView.textView becomeFirstResponder];
}

#pragma mark @protocol YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
    self.toFrame = toFrame;

    if (transition.animationDuration == 0) {
        self.msgSendView.bottom = CGRectGetMinY(self.toFrame);
    } else {
        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.toFrame.origin.y == ScreenHeight - NavBarHeight) {
                JGLog(@"消失");
                [self keyboardDismiss];
            }else {
                if (self.selectedCellType == YSSelectedCellWithNoneType) {
                    
                }else {
                    [self keyboardShowWithFrame:self.toFrame];
                }
            }
            self.msgSendView.bottom = CGRectGetMinY(self.toFrame);
        } completion:NULL];
    }
}

- (void)keyboardDismiss {

}

- (void)keyboardShowWithFrame:(CGRect)toFrame {
    JGLog(@"出现");
    /**
     *  弹出键盘更信息 */
    switch (self.selectedCellType) {
        case YSSelectedCellWithNoneType:
        
            break;
        case YSSelectedCellWithCommentType:
        {
            self.msgSendView.textView.placeholderText = [NSString stringWithFormat:@"回复%@:",self.selecetedCellFrame.comment.fromUserName];
        }
            break;
        case YSSelectedCellWithReplyType:
        {
            self.msgSendView.textView.placeholderText = [NSString stringWithFormat:@"回复%@:",self.selecetedCellFrame.comment.fromUserName];
        }
            break;
        default:
            break;
    }
    
    CGFloat delta = 0.0;
    CGFloat keyboardHeight = ScreenHeight - CGRectGetMinY(toFrame);
    delta = self.history_Y_offset - ([UIApplication sharedApplication].keyWindow.bounds.size.height - keyboardHeight - self.selectedCellHeight + 20);
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    [self.tableView setContentOffset:offset animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    self.msgSendView.textView.placeholderText = @"评论:";
    self.selectedCellType = YSSelectedCellWithNoneType;
    self.msgSendView.textView.text = @"";
}


@end
