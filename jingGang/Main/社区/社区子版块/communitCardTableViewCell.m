//
//  communitCardTableViewCell.m
//  jingGang
//
//  Created by thinker on 15/11/18.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "communitCardTableViewCell.h"
#import "PublicInfo.h"
#import "VApiManager.h"
#import "GlobeObject.h"
#import "MJExtension.h"
#import "YSImageConfig.h"

@interface communitCardTableViewCell ()
{
    VApiManager *_vapiManager;
    NSDictionary *_dict;
}

@end

@implementation communitCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _vapiManager = [[VApiManager alloc] init];
    
    CGFloat x = ScreenWidth / 4;
    for (NSInteger i = 0; i < 3; i ++) {
        UIView *sepLineView = [UIView new];
        sepLineView.x = i * x - 0.5 + x;
        sepLineView.y  = communitCellRowHeight - 38 - 6;
        sepLineView.width = 0.5;
        sepLineView.height = 38;
        sepLineView.backgroundColor = YSHexColorString(@"#f0f0f0");
        [self.contentView addSubview:sepLineView];
    }
    self.main_lab.font = YSPingFangRegular(14);
    self.main_lab.textColor = YSHexColorString(@"#4a4a4a");
}
- (IBAction)shareAction:(id)sender {
    UNLOGIN_HANDLE
    if (self.shareBlock) {
        self.shareBlock();
    }
}
- (IBAction)fallowAction:(id)sender {
    UNLOGIN_HANDLE
    if (self.fallowBlock) {
        self.fallowBlock();
    }
}
- (IBAction)numAction:(id)sender {
    UNLOGIN_HANDLE
    if (self.numWithBlock)
    {
        if (self.isNum)
        {
            [self dissmissPraise];
        }
        else
        {
            [self praiseClickChange];
        }
    }
}
- (IBAction)likeAction:(id)sender {
    UNLOGIN_HANDLE
    if (self.likeWithBlock) {
        if (self.isLike)
        {
            [self UsersfavioritesCancle];
        }
        else
        {
            [self FavoriteUser];
        }
    }
}


- (void)customCellWithDict:(NSDictionary *)dict withCircle:(BOOL)cricle withTimePast:(NSString *)comStr
{
    _dict = dict;
    CircleInvitation *data = [CircleInvitation objectWithKeyValues:dict];
    [self  setData:data withComStr:comStr];
    if (cricle) {
        self.head_img.layer.cornerRadius = CGRectGetHeight(self.head_img.frame) / 2;
        self.head_img.clipsToBounds = YES;
    }
    else
    {
        self.head_img.layer.cornerRadius = 0;
        self.head_img.clipsToBounds = NO;
    }
}
#pragma mark - 对cell数据的赋值
-(void)setData:(CircleInvitation *)data withComStr:(NSString *)comStr
{
    NSString *url = [NSString stringWithFormat:@"%@",data.thumbnail ? data.thumbnail:data.headImgPath];
    [YSImageConfig sd_view:self.head_img setimageWithURL:[NSURL URLWithString:url] placeholderImage:DEFAULTIMG];
    self.head_img.contentMode = UIViewContentModeScaleAspectFit;
    self.main_lab.text = data.title;
    BOOL strType = [comStr isEqualToString:@"发"];
    if (!data.userName) {
        self.time_lab.text = [NSString stringWithFormat:@"匿名用户发表于%@",data.publicTime];
    }
    else
    {
        self.time_lab.text = [NSString stringWithFormat:@"%@%@%@%@",data.userName, strType ? @"发表于":@"在",data.publicTime,strType ? @"":@"发布"];
    }
    [self fuwenbenLabel:self.time_lab FontNumber:[UIFont systemFontOfSize:15] withStr:comStr AndColor:communit_color_1];
    NSString *strNum = [NSString stringWithFormat:@"%@",data.praiseCount];
    [self.numBT setTitle:strNum forState:UIControlStateNormal];
    NSNumber *replyC = data.replyCount;
    if ([replyC intValue] == 0) {
        [self.fallowBT setTitle:@"0" forState:UIControlStateNormal];
    }
    else{
        NSString *strFallow = [NSString stringWithFormat:@"%@",replyC];
        [self.fallowBT setTitle:strFallow forState:UIControlStateNormal];
    }
    //判断是否点赞过和收藏
    self.isNum = [data.isPraise boolValue];
    self.isLike = [data.isFavo boolValue];
}


- (void)setIsLike:(BOOL)isLike
{
    _isLike = isLike;
    if (isLike) //收藏
    {
        [self.likeBT setImage:[UIImage imageNamed:@"ys_tiezi_collect_sltd"] forState:UIControlStateNormal];
        [self.likeBT setTitleColor:UIColorFromRGB(0xf5a623) forState:UIControlStateNormal];
    }
    else
    {
        [self.likeBT setImage:[UIImage imageNamed:@"ys_tiezi_collect_normal"] forState:UIControlStateNormal];
        [self.likeBT setTitleColor:UIColorFromRGB(0x9b9b9b) forState:UIControlStateNormal];
    }
    
}
- (void)setIsNum:(BOOL)isNum
{
    _isNum = isNum;
    if (isNum) //点赞
    {
        [self.numBT setImage:[UIImage imageNamed:@"ys_healthmanage_agree"] forState:UIControlStateNormal];
        [self.numBT setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.numBT setImage:[UIImage imageNamed:@"ys_healthmanage_no_agree"] forState:UIControlStateNormal];
        [self.numBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
}
- (void)setIsShare:(BOOL)isShare
{
    [UIView animateWithDuration:0.3 animations:^{
        // ys_healthmanage_share
        // com_share_pressed  com_share
        [self.shareBT setImage:[UIImage imageNamed:@"ys_healthmanage_share"] forState:UIControlStateNormal];
        [self.shareBT setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [self.shareBT setImage:[UIImage imageNamed:@"ys_healthmanage_share"] forState:UIControlStateNormal];
        [self.shareBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }];
}

-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font withStr:(NSString *)comStr AndColor:(UIColor *)vaColor
{
    NSString * str = [NSString stringWithFormat:@"%@",labell.text];
    NSArray * array = [str componentsSeparatedByString:comStr];
    NSString * name_str = [array firstObject];
    NSInteger a = name_str.length;
    NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc] initWithString:str attributes:nil];
    
    //设置字号
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,a)];
    
    //设置文字颜色
    [attributedString addAttribute:NSForegroundColorAttributeName value:vaColor range:NSMakeRange(0,a)];
    
    labell.attributedText = attributedString;
}

#pragma mark - ==========================网络请求数据=========点赞和收藏=======================

#pragma mark - 取消点赞
-(void)dissmissPraise
{
    WEAK_SELF
    UsersCanclePraiseRequest *usersCanclePraiseRequest = [[UsersCanclePraiseRequest alloc] init:GetToken];
    usersCanclePraiseRequest.api_fid = _dict[@"id"];
    [_vapiManager usersCanclePraise:usersCanclePraiseRequest success:^(AFHTTPRequestOperation *operation, UsersCanclePraiseResponse *response) {
//        NSLog(@"取消点赞成功＝＝＝");
        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithDictionary:_dict];
        [mutableDict setObject:@(0) forKey:@"isPraise"];
        [mutableDict setObject:@([_dict[@"praiseCount"] intValue] - 1) forKey:@"praiseCount"];
        weak_self.numWithBlock(mutableDict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"取消点赞失败");
        [Util ShowAlertWithOnlyMessage:@"取消点赞失败"];
    }];
}
#pragma mark - 点赞
-(void)praiseClickChange
{
    WEAK_SELF
    UsersPraiseRequest *usersPraiseRequest = [[UsersPraiseRequest alloc] init:GetToken];
    usersPraiseRequest.api_fid = _dict[@"id"];
    [_vapiManager usersPraise:usersPraiseRequest success:^(AFHTTPRequestOperation *operation, UsersPraiseResponse *response) {
//        NSLog(@"---点赞成功");
        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithDictionary:_dict];
        [mutableDict setObject:@(1) forKey:@"isPraise"];
        [mutableDict setObject:@([_dict[@"praiseCount"] intValue] + 1) forKey:@"praiseCount"];
        weak_self.numWithBlock(mutableDict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [Util ShowAlertWithOnlyMessage:@"点赞失败"];
    }];
}

#pragma mark - 收藏
-(void)FavoriteUser
{
    WEAK_SELF
    UsersFavoritesRequest *usersFavorites = [[UsersFavoritesRequest alloc] init:GetToken];
    usersFavorites.api_fid = _dict[@"id"];
    usersFavorites.api_type = @"1";
    [_vapiManager usersFavorites:usersFavorites success:^(AFHTTPRequestOperation *operation, UsersFavoritesResponse *response) {
        
        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithDictionary:_dict];
        [mutableDict setObject:@(1) forKey:@"isFavo"];
        weak_self.likeWithBlock(mutableDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Util ShowAlertWithOnlyMessage:@"收藏失败"];
    }];
}
#pragma mark - 取消收藏成功
-(void)UsersfavioritesCancle
{
    WEAK_SELF
    UsersFavoritesCancleRequest *usersFavoritesCancleRequest = [[UsersFavoritesCancleRequest alloc] init:GetToken];
    usersFavoritesCancleRequest.api_fid = _dict[@"id"];
    [_vapiManager usersFavoritesCancle:usersFavoritesCancleRequest success:^(AFHTTPRequestOperation *operation, UsersFavoritesCancleResponse *response) {
        NSLog(@"取消收藏成功");
        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithDictionary:_dict];
        [mutableDict setObject:@(0) forKey:@"isFavo"];
        weak_self.likeWithBlock(mutableDict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Util ShowAlertWithOnlyMessage:@"取消收藏失败"];
    }];
    
}

@end
