//
//  YSHotInfoTableViewCell.m
//  jingGang
//
//  Created by 左衡 on 2018/7/31.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import "YSHotInfoTableViewCell.h"
#import "Masonry.h"
#import "WebDayVC.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
#import "VApiManager+Aspects.h"
#import "userDefaultManager.h"
#import "YSShareManager.h"
#import "NSString+YYAdd.h"
#import "H5Base_url.h"
#import "YSLoginManager.h"
#import "GlobeObject.h"
#import "UserCustomer.h"
#import "MJExtension.h"
#import "FollwerContent.h"



#define kHealthyMessageCellHeight 100
#define k_ShareImage @"http://static.bhesky.cn/static/person.png"
static NSString *cellId = @"cellId";

@interface YSHotInfoTableViewCell ()
@property (nonatomic, strong)UILabelTopLeft *titleLab;
@property (nonatomic, strong)UIImageView *iconView;
@property (nonatomic, strong)UIButton *agreeButton;
@property (nonatomic, strong)UIButton *commentButton;
@property (nonatomic, strong)UIButton *shareButton;
@property (nonatomic, strong) VApiManager * VApManager;
@property (nonatomic , assign , getter=ischose) BOOL chose;
@property (nonatomic,strong) YSShareManager *shareManager;
@property (strong,nonatomic)  UIWebView *web;
@property (assign, nonatomic) int isPraise;
@property (nonatomic, assign)BOOL  isSel;

@property(nonatomic,assign)bool typeShow;

@end

@implementation YSHotInfoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([reuseIdentifier isEqualToString:@"RXHotInfoTableViewCell"]) {
            self.isRX=true;
        }
        if ([reuseIdentifier isEqualToString:@"RXHotInfoTableViewShowCell"]) {
            self.typeShow=true;
        }
        [self setUpUI];
    }
    return self;
}



//首页点赞
- (void)setUpUI{
    
    if (self.typeShow) {
        
        CGFloat w=ScreenWidth;
        CGFloat h=ScreenWidth/4+20;
        
        UIImageView*imageView=[[UIImageView alloc]init];
        imageView.backgroundColor=[UIColor whiteColor];
        imageView.frame=CGRectMake(10,0,w-20,84/2);
        [self addSubview:imageView];
        UILabel *titleLab1 = [[UILabel alloc] init];
        titleLab1.x =10;
        titleLab1.y = 0;
        titleLab1.width = 100;
        titleLab1.height = 84/2;
        titleLab1.textAlignment = NSTextAlignmentLeft;
        titleLab1.font = JGRegularFont(16);
        titleLab1.textColor = JGColor(51,51,51,1);
        titleLab1.text = @"今日健康资讯";
        [imageView addSubview:titleLab1];
    
        UIView *whiteView;
        whiteView = [[UIView alloc] initWithFrame:CGRectMake(10,84/2, w-20, h+10)];
        self.contentView.backgroundColor = JGColor(249, 249, 249, 1);
        whiteView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:whiteView];
        _titleLab = [[UILabelTopLeft alloc] initWithFrame:CGRectMake(10, 20, (w-30)/3*2-10, (h-30)/3*2)];
        _titleLab.numberOfLines = 2;
        [whiteView addSubview:_titleLab];
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLab.frame)+10, 10, (w-30)/3-10, (h-30))];
        _iconView.layer.cornerRadius=8;
        _iconView.clipsToBounds = YES;
        [whiteView addSubview:_iconView];
        
        
        UIView *buttonView=[[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_titleLab.frame), (w-30)/3*2, (h-30)/3)];
        buttonView.userInteractionEnabled = YES;

        _agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(5,20,(buttonView.width-20)/3, buttonView.height-10)];
        
        [_agreeButton setTitle:@"点赞" forState:UIControlStateNormal];
        [_agreeButton setTitleColor:JGColor(221, 221, 221, 1) forState:UIControlStateNormal];
        [_agreeButton setTitleColor:[YSThemeManager themeColor] forState:UIControlStateSelected];
        [_agreeButton setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
        [_agreeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
        
        //    [_agreeButton setImage:[UIImage imageNamed:@"点赞-选中"] forState:UIControlStateNormal];
        [buttonView addSubview:_agreeButton];
        
        _commentButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_agreeButton.frame),20, (buttonView.width-20)/3+25, buttonView.height-10)];
        
          
        [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [_commentButton setTitleColor:JGColor(221, 221, 221, 1) forState:UIControlStateNormal];
        [_commentButton setTitleColor:[YSThemeManager themeColor] forState:UIControlStateSelected];
        [_commentButton setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(fallow:) forControlEvents:UIControlEventTouchUpInside];
        //    [_commentButton setImage:[UIImage imageNamed:@"评论-选中"] forState:UIControlStateNormal];
        [buttonView addSubview:_commentButton];
        
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_commentButton.frame),20, (buttonView.width-20)/3, buttonView.height-10)];
        
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton setTitleColor:JGColor(221, 221, 221, 1) forState:UIControlStateNormal];
        [_shareButton setTitleColor:[YSThemeManager themeColor] forState:UIControlStateSelected];
        [_shareButton setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        //    [_shareButton setImage:[UIImage imageNamed:@"分享-选中"] forState:UIControlStateNormal];
        [buttonView addSubview:_shareButton];
        _agreeButton.titleLabel.font =_commentButton.titleLabel.font =_shareButton.titleLabel.font = JGRegularFont(14);
        _titleLab.font=JGRegularFont(17);
        [whiteView addSubview:buttonView];
        
    }else{
        CGFloat w=ScreenWidth;
        CGFloat h=ScreenWidth/4+20;
        UIView *whiteView;
        if (self.isRX) {
            whiteView = [[UIView alloc] initWithFrame:CGRectMake(10,0, w-20, h+10)];
        }else{
            whiteView = [[UIView alloc] initWithFrame:CGRectMake(10,10, w-20, h-10)];
        }
        self.contentView.backgroundColor = JGColor(249, 249, 249, 1);
        whiteView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:whiteView];
        _titleLab = [[UILabelTopLeft alloc] initWithFrame:CGRectMake(10, 20, (w-30)/3*2-10, (h-30)/3*2)];
        _titleLab.numberOfLines = 2;
        [whiteView addSubview:_titleLab];
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLab.frame)+10, 10, (w-30)/3-10, (h-30))];
        _iconView.layer.cornerRadius=8;
        _iconView.clipsToBounds = YES;
        [whiteView addSubview:_iconView];
        
        
        UIView *buttonView=[[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_titleLab.frame), (w-30)/3*2, (h-30)/3)];
        buttonView.userInteractionEnabled = YES;
        if (self.isRX) {
            _agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(5,20,(buttonView.width-20)/3, buttonView.height-10)];
        }else{
            _agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0,(buttonView.width-20)/3, buttonView.height-10)];
        }
        [_agreeButton setTitle:@"点赞" forState:UIControlStateNormal];
        [_agreeButton setTitleColor:JGColor(221, 221, 221, 1) forState:UIControlStateNormal];
        [_agreeButton setTitleColor:[YSThemeManager themeColor] forState:UIControlStateSelected];
        [_agreeButton setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
        [_agreeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
        
        //    [_agreeButton setImage:[UIImage imageNamed:@"点赞-选中"] forState:UIControlStateNormal];
        [buttonView addSubview:_agreeButton];
        
        if (self.isRX) {
            _commentButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_agreeButton.frame),20, (buttonView.width-20)/3+25, buttonView.height-10)];
        }else{
            _commentButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_agreeButton.frame),0, (buttonView.width-20)/3+25, buttonView.height-10)];
        }
        [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [_commentButton setTitleColor:JGColor(221, 221, 221, 1) forState:UIControlStateNormal];
        [_commentButton setTitleColor:[YSThemeManager themeColor] forState:UIControlStateSelected];
        [_commentButton setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(fallow:) forControlEvents:UIControlEventTouchUpInside];
        //    [_commentButton setImage:[UIImage imageNamed:@"评论-选中"] forState:UIControlStateNormal];
        [buttonView addSubview:_commentButton];
        
        if (self.isRX) {
            _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_commentButton.frame),20, (buttonView.width-20)/3, buttonView.height-10)];
        }else{
            _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_commentButton.frame),0, (buttonView.width-20)/3, buttonView.height-10)];
        }
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton setTitleColor:JGColor(221, 221, 221, 1) forState:UIControlStateNormal];
        [_shareButton setTitleColor:[YSThemeManager themeColor] forState:UIControlStateSelected];
        [_shareButton setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        //    [_shareButton setImage:[UIImage imageNamed:@"分享-选中"] forState:UIControlStateNormal];
        [buttonView addSubview:_shareButton];
        _agreeButton.titleLabel.font =_commentButton.titleLabel.font =_shareButton.titleLabel.font = JGRegularFont(14);
        _titleLab.font=JGRegularFont(17);
        [whiteView addSubview:buttonView];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setModels:(NSDictionary *)dict{
    NSLog(@"dict+++++++++%@",[dict objectForKey:@"title"]);
    
    if (self.isRX) {
        NSString *url = [NSString stringWithFormat:@"%@",[dict objectForKey:@"thumbnail"]];
        NSString *picUrlString = [YSThumbnailManager healthyManagerHealthyInformationThumbnailPicUrlString:url];
        [YSImageConfig yy_view:self.iconView setImageWithURL:[NSURL URLWithString:picUrlString] placeholder:[UIImage imageNamed:@"ys_placeholder_circle"] options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        }];
        self.titleLab.text = [dict objectForKey:@"title"];
       NSString *praise=[NSString stringWithFormat:@"评论(+%@)",[dict objectForKey:@"praiseCount"] ];
        [_commentButton setTitle:praise forState:UIControlStateNormal];
        
    }else{
        NSString *url = [NSString stringWithFormat:@"%@",[dict objectForKey:@"thumbnail"]];
        NSString *picUrlString = [YSThumbnailManager healthyManagerHealthyInformationThumbnailPicUrlString:url];
        [YSImageConfig yy_view:self.iconView setImageWithURL:[NSURL URLWithString:picUrlString] placeholder:[UIImage imageNamed:@"ys_placeholder_circle"] options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        }];
        self.titleLab.text = [dict objectForKey:@"title"];
        NSString *praise=[NSString stringWithFormat:@"评论(+%@)",[dict objectForKey:@"praiseCount"] ];
        [_commentButton setTitle:praise forState:UIControlStateNormal];
    }
    
    
}

- (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    html = [html stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"nbsp;" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"nbsp" withString:@""];
    
    NSString * regEx = @"<([^>]*)>";
    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

- (void)changeBtnImage:(id)sender {
    self.chose = !self.ischose;
    if (self.chose) {
        [_agreeButton setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
         [_agreeButton setTitleColor:JGColor(221, 221, 221, 1) forState:UIControlStateNormal];
    } else
    {
        [_agreeButton setImage:[UIImage imageNamed:@"点赞-选中"] forState:UIControlStateNormal];;
        [_agreeButton setTitleColor:JGColor(96, 187, 177, 1) forState:UIControlStateNormal];
    }
}


-(void)fallow:(UIButton*)button{
    if (isEmpty(GetToken)) {
        [VApiManager handleNeedTokenError];
    } else {
        FollwerContent *follow = [[FollwerContent alloc]init];
        if ([self.dic objectForKey:@"itemId"]) {
            follow.num = @([[self.dic objectForKey:@"itemId"] integerValue]);
        }else{
            follow.num = @([[self.dic objectForKey:@"id"] integerValue]);
        }
        follow.commentBlcock = ^(BOOL success){
            if (success) {
                [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strUrl]]];
            }
        };
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:follow];
        [_nav1 presentViewController:nav animated:YES completion:nil];
        RELEASE(follow);
        RELEASE(nav);
         RELEASE(nav1);
    }
    
}


-(void)share:(UIButton*)btn{
    UNLOGIN_HANDLE
    //    if (self.isShare) {
    //        return;
    //    }
    //    self.isShare = YES;
    
    //请求分享url需要用到的邀请码,请求完成后再请求分享Url
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [self _usersInfoRequest];
    
}

/**
 *  请求分享出去的Url
 */
- (void)requestShareInfoUrlWith:(NSString *)inviteCode
{
    
    NSString *share_title = [self.dic objectForKey:@"title"] ? [self.dic objectForKey:@"title"] :[self.dic objectForKey:@"adTitle"];//分享的标题
    
    NSString *imageUrl = [self.dic objectForKey:@"thumbnail"];
    if(imageUrl == nil){
        imageUrl = [self.dic objectForKey:@"headImgPath"];
    }
    if (imageUrl == nil) {
        imageUrl = [self.dic objectForKey:@"adImgPath"];
    }
    NSString *share_imgeURL = imageUrl ? imageUrl :k_ShareImage;//[cellDic objectForKey:@"thumbnail"];分享图片
    
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    
    UsersInvitationDetailsRequest *usersInvitationDetailsRequest = [[UsersInvitationDetailsRequest alloc] init:accessToken];
    if ([self.dic objectForKey:@"id"]) {
        usersInvitationDetailsRequest.api_invnId = @([[self.dic objectForKey:@"id"] integerValue]);
    }else{
        usersInvitationDetailsRequest.api_invnId = @([[self.dic objectForKey:@"itemId"] integerValue]);
    }
    usersInvitationDetailsRequest.api_invitationCode = inviteCode;
    //给url判断分享出去的设备平台的，2为iOSxxxx
    usersInvitationDetailsRequest.api_jgyes_app = @2;
    
    WEAK_SELF
    [_VApManager usersInvitationDetails:usersInvitationDetailsRequest success:^(AFHTTPRequestOperation *operation, UsersInvitationDetailsResponse *response) {
        
        
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        NSString *jgyes_appType = @"2";
        NSString *ID = [weak_self.dic objectForKey:@"itemId"] ?[weak_self.dic objectForKey:@"itemId"] :[self.dic objectForKey:@"id"];
        
        //把标题称转换成Base64编码拼在链接后面
        NSString *strTitleHtml = [share_title base64EncodedString];
        
        NSString *share_URL = [NSString stringWithFormat:@"%@%@%@&ysysgo_app=%@&invitationCode=%@&tit=%@",Base_URL,user_tiezi,ID,jgyes_appType,inviteCode,strTitleHtml];//分享URL
        JGLog(@"%@",share_URL);
        
        YSShareManager *shareManager = [[YSShareManager alloc] init];
        YSShareConfig *config = [YSShareConfig configShareWithTitle:share_title content:response.content UrlImage:share_imgeURL shareUrl:share_URL];
        [shareManager shareWithObj:config showController:self];
        self.shareManager = shareManager;
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.isShare = NO;
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        [Util ShowAlertWithOutCancelWithTitle:@"提示" message:@"请求分享内容失败"];
    }];
    
}
/**
 *  请求邀请码
 */
-(void)_usersInfoRequest {
    WEAK_SELF
    _VApManager = [[VApiManager alloc]init];
    UsersCustomerSearchRequest *request = [[UsersCustomerSearchRequest alloc] init:GetToken];
    [_VApManager usersCustomerSearch:request success:^(AFHTTPRequestOperation *operation, UsersCustomerSearchResponse *response) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        
        NSDictionary   *dictUserList = [dict objectForKey:@"customer"];
        
        [[NSUserDefaults standardUserDefaults]setObject:dictUserList forKey:kUserCustomerKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UserCustomer *customer = [UserCustomer objectWithKeyValues:response.customer];
        [weak_self requestShareInfoUrlWith:customer.invitationCode];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


-(void)panduandianzan{
    self.isPraise = [[self.dic objectForKey:@"isPraise"] intValue];
    if (self.isPraise == 1) {
        self.isSel = true;
        [_agreeButton setImage:[UIImage imageNamed:@"点赞-选中"] forState:UIControlStateNormal];;
        [_agreeButton setTitleColor:JGColor(96, 187, 177, 1) forState:UIControlStateNormal];
    }else{
        self.isSel = false;
        [_agreeButton setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
        [_agreeButton setTitleColor:JGColor(221, 221, 221, 1) forState:UIControlStateNormal];
        //            self.cellView.numLB.textColor = rgb(101, 177, 187, 1.0);
        
    }
}

-(void)like:(UIButton*)button{
    
  
    if (isEmpty(GetToken)) {
        [VApiManager handleNeedTokenError];
    } else {
        if (self.isPraise) {//已经点过
            if ([self.dic objectForKey:@"id"]) {
                [self dissmissPraise:[self.dic objectForKey:@"id"] bt:_agreeButton ];
            }else{
                [self dissmissPraise:[self.dic objectForKey:@"itemId"] bt:_agreeButton ];
            }
            
            
        } else {//还没有点过
            if ([self.dic objectForKey:@"id"]) {
                [self praiseClickChange:[self.dic objectForKey:@"id"] bt:_agreeButton ];
            }else{
                [self praiseClickChange:[self.dic objectForKey:@"itemId"] bt:_agreeButton];
            }
        }
    }
}

-(void)dissmissPraise:(NSString *)circle bt:(UIButton*)btn
{
    _VApManager = [[VApiManager alloc]init];
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    
    UsersCanclePraiseRequest *usersCanclePraiseRequest = [[UsersCanclePraiseRequest alloc] init:accessToken];
    WeakSelf;
    usersCanclePraiseRequest.api_fid = circle;
    [_VApManager usersCanclePraise:usersCanclePraiseRequest success:^(AFHTTPRequestOperation *operation, UsersCanclePraiseResponse *response) {
        StrongSelf;
        [btn setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
        [btn setTitleColor:JGColor(221, 221, 221, 1) forState:UIControlStateNormal];
        self.isSel = false;
        strongSelf.isPraise = 0;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       self.isSel = true;
    }];
}

//点赞
-(void)praiseClickChange:(NSString *)circle bt:(UIButton*)btn
{
    _VApManager = [[VApiManager alloc]init];
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    UsersPraiseRequest *usersPraiseRequest = [[UsersPraiseRequest alloc] init:accessToken];
    usersPraiseRequest.api_fid = circle;
    WeakSelf;
    [_VApManager usersPraise:usersPraiseRequest success:^(AFHTTPRequestOperation *operation, UsersPraiseResponse *response) {
        StrongSelf;
        [btn setImage:[UIImage imageNamed:@"点赞-选中"] forState:UIControlStateNormal];;
        [btn setTitleColor:JGColor(96, 187, 177, 1) forState:UIControlStateNormal];
        //            self.cellView.numLB.textColor = rgb(101, 177, 187, 1.0);
        
        
        strongSelf.isPraise = 1;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.isSel = false;
    }];
}


@end
@implementation UILabelTopLeft
- (id)initWithFrame:(CGRect)frame {
    return [super initWithFrame:frame];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    textRect.origin.y = bounds.origin.y;
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}





@end
