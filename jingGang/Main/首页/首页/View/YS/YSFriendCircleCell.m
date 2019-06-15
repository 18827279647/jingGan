//
//  YSFriendCircleCell.m
//  jingGang
//
//  Created by dengxf on 16/7/23.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSFriendCircleCell.h"
#import "YSFriendPhotosView.h"
#import "YSFriendCircleModel.h"
#import "YYKit.h"
#import "YSHealthyCircleLocateView.h"
#import "GlobeObject.h"
#import "HZPhotoBrowser.h"
#import "YSThumbnailManager.h"

@interface YSFriendCircleCell ()<HZPhotoBrowserDelegate>

@property (strong,nonatomic) NSIndexPath *indexPath;
@property (strong,nonatomic) UIImageView *iconImgView;
@property (strong,nonatomic) UILabel *nickLab;
@property (strong,nonatomic) UIImageView *genderImgView;
@property (strong,nonatomic) UILabel *levelLab;

@property (strong,nonatomic) UIButton *deleteButton;

@property (strong,nonatomic) UILabel *tagLab;
@property (strong,nonatomic) UILabel *dateLab;
@property (strong,nonatomic) YYLabel *contentLab;
@property (strong,nonatomic) YSFriendPhotosView *photosView;
@property (strong,nonatomic) YSHealthyCircleLocateView *localView;
@property (strong,nonatomic) YSFriendCircleToolsView *toolsView;
/**
 *  底部评论背景视图 */
@property (strong,nonatomic) UIView *commentsBgView;
@property (strong,nonatomic) UIView *commentLineView;
@property (strong,nonatomic) UILabel *commentFLab;
@property (strong,nonatomic) UILabel *commentSLab;
@property (strong,nonatomic) UILabel *commentTLab;
@property (strong,nonatomic) UIButton *moreComments;

@end

@implementation YSFriendCircleCell

+ (instancetype)setupCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    static NSString *CellId = @"YSFriendCircleCell";
    YSFriendCircleCell *cell   = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[YSFriendCircleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = JGWhiteColor;
    }
    cell.indexPath = indexPath;
    return cell;
}

- (void)setCircleFrame:(YSFriendCircleFrame *)circleFrame {
    _circleFrame = circleFrame;
    YSFriendCircleModel *fcModel = circleFrame.friendCircleModel;
    /***  头像 */
    @weakify(self);
    self.iconImgView.frame = circleFrame.iconF;
    
    [self.iconImgView setImageWithURL:[NSURL URLWithString:[YSThumbnailManager healthyCircleThumbnailUserHeaderPhotoUrlString:fcModel.headImgPath]] placeholder:kDefaultUserIcon options:YYWebImageOptionProgressive completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
    [self.iconImgView setUserInteractionEnabled:YES];
    [self.iconImgView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        BLOCK_EXEC(self.clickUserIconCallback);
    }];
    self.iconImgView.layer.cornerRadius = self.iconImgView.size.width / 2;
    self.iconImgView.clipsToBounds = YES;
    
    /***  昵称 */
    self.nickLab.frame = circleFrame.nickNameF;
    self.nickLab.text = fcModel.nickname;
    
    /***  性别 */
    self.genderImgView.frame = circleFrame.genderF;
    self.genderImgView.contentMode = UIViewContentModeScaleAspectFit;
    if ([fcModel.sex isEqualToString:@"1"]) {
        self.genderImgView.image = [UIImage imageNamed:@"My_BoyIcon"];
    }else if ([fcModel.sex isEqualToString:@"2"]) {
        self.genderImgView.image = [UIImage imageNamed:@"My_GirlsIcon"];
    }else{
        self.genderImgView.image = [UIImage imageNamed:@"My_BoyIcon"];
    }
    
    self.genderImgView.size = (CGSize){self.genderImgView.image.imageWidth,self.genderImgView.image.imageHeight};
    
    /***  等级 */
    self.levelLab.frame = circleFrame.levelF;
    if (fcModel.level) {
        self.levelLab.text = [NSString stringWithFormat:@"Lv%@",fcModel.level];
    }else {
        self.levelLab.text = [NSString stringWithFormat:@"Lv%@",@"0"];
    }
    
    /***  用户标签 */
    self.tagLab.frame = circleFrame.tagF;
    
    if (self.shouldShowDeleteButton) {
        self.deleteButton.backgroundColor = JGClearColor;
        self.deleteButton.frame = circleFrame.deleteButtonF;
        self.deleteButton.hidden = NO;
    }else {
        self.deleteButton.hidden = YES;
    }
    
    /***  发布日期 */
    self.dateLab.frame = circleFrame.dateF;
    self.dateLab.text = fcModel.addTime;
    
    /***  发布内容 */
    self.contentLab.frame = circleFrame.contentF;
    self.contentLab.backgroundColor = JGClearColor;
    self.contentLab.textLayout = circleFrame.textLayout;
    self.contentLab.font = JGFont(14);
    
    self.contentLab.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        @strongify(self);
        YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:range.location];
        NSDictionary *info = highlight.userInfo;
        NSString *topic = info[@"topic"];
        if ([topic containsString:@"#"]) {
            NSArray *topics = [topic componentsSeparatedByString:@"#"];
            topic = [topics componentsJoinedByString:@""];
        }
        BLOCK_EXEC(self.clickTopicCallback,topic);
    };

    if (circleFrame.friendCircleModel.images.count) {
        /***  有配图 */
        self.photosView.frame = circleFrame.photosF;
        self.photosView.photos = fcModel.images;
        self.photosView.hidden = NO;
        self.photosView.clickImgPage = ^(NSInteger index) {
            @strongify(self);
//            BLOCK_EXEC(self.clickImageCallback,index);
//            JGLog(@"index:%zd",index);
            HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
            browser.sourceImagesContainerView = self.photosView; // 原图的父控件
            browser.imageCount = fcModel.images.count; // 图片总数
            browser.currentImageIndex = (int)index;
            browser.delegate = self;
            [browser show];
        };
    }else {
        /***  没有配图 */
        self.photosView.hidden = YES;
    }
    
    /***  发布位置 */
    if (fcModel.location.length && ![fcModel.location isEqualToString:@"(null)"]) {
        if (self.localView) {
            [self.localView removeFromSuperview];
            self.localView = nil;
            self.localView = [[YSHealthyCircleLocateView alloc] init];
            self.localView.hidden = NO;
            [self.contentView addSubview:self.localView];
            self.localView.frame = circleFrame.locationF;
            [GCDQueue executeInMainQueue:^{
                self.localView.locates = fcModel.location;
            }];
        }
    }else {
        self.localView.hidden = YES;
    }
    
    if (circleFrame.hiddenCommentsBgView) {
        self.commentsBgView.hidden = YES;
    }else {
        if (!fcModel.evaluateList.count) {
            self.commentsBgView.hidden = YES;
        }else{
            [self configCommentsViewWithFrame:circleFrame circleModel:fcModel];
        }
    }
    
    /**  底部工具 */
    [self.toolsView setCommentNumber:[fcModel.evaluateNum integerValue] agreeNumber:[fcModel.praiseNum integerValue]];
    if (fcModel.islogined) {
        /***  已登录 */
        if ([fcModel.ispraise integerValue] > 0) {
            [self.toolsView isagreed:YES];
        }else {
            [self.toolsView isagreed:NO];
        }
    }else {
        /***  未登录 */
        [self.toolsView isagreed:NO];
    }
    self.toolsView.frame = circleFrame.toolsF;

    self.toolsView.toolsButtonClickCallback = ^(NSInteger index) {
        @strongify(self);
        BLOCK_EXEC(self.friendCircleClickCallback,index);
    };

    if (circleFrame.hiddenToolBar) {
        self.toolsView.hidden = YES;
    }else{
        
        [GCDQueue executeInMainQueue:^{
            @strongify(self);
            self.toolsView.hidden = NO;
        }];
    }
}

- (void)configCommentsViewWithFrame:(YSFriendCircleFrame *)circleFrame circleModel:(YSFriendCircleModel *)fcModel{
    self.commentsBgView.hidden = NO;
    self.commentsBgView.frame = circleFrame.commentsBgF;
    self.commentLineView.frame = CGRectMake(10, 12.6, ScreenWidth - 10, 0.8);
    @weakify(self);
    [fcModel commentsHeight:^(NSArray *heights) {
        @strongify(self);
        self.commentFLab.hidden = NO;
        CGFloat marginx = 12;
        CGFloat marginTop = MaxY(self.commentLineView) + 6;
        CGFloat width = ScreenWidth - 12 * 2;
        self.commentFLab.frame = CGRectMake(marginx, marginTop, width, [heights.firstObject floatValue]);
        self.commentFLab.attributedText = [self commentTextWithFromUserName:[[fcModel.evaluateList firstObject] objectForKey:@"fromUserName"] content:[[fcModel.evaluateList firstObject] objectForKey:@"content"]];
        self.moreComments.hidden = YES;
        switch (heights.count) {
            case 1:
            {
                self.commentSLab.hidden = YES;
                self.commentTLab.hidden = YES;
            }
                break;
            case 2:
            {
                self.commentSLab.hidden = NO;
                self.commentTLab.hidden = YES;
                self.commentSLab.frame = CGRectMake(marginx, MaxY(self.commentFLab),width,[heights.lastObject floatValue]);
                self.commentSLab.attributedText = [self commentTextWithFromUserName:[[fcModel.evaluateList lastObject] objectForKey:@"fromUserName"] content:[[fcModel.evaluateList lastObject] objectForKey:@"content"]];
            }
                break;
            case 3:
            {
                self.commentSLab.hidden = NO;
                self.commentTLab.hidden = NO;
                self.moreComments.hidden = NO;
                self.commentSLab.frame = CGRectMake(marginx, MaxY(self.commentFLab),width,[[heights xf_safeObjectAtIndex:1] floatValue]);
                self.commentSLab.attributedText = [self commentTextWithFromUserName:[[fcModel.evaluateList xf_safeObjectAtIndex:1] objectForKey:@"fromUserName"] content:[[fcModel.evaluateList xf_safeObjectAtIndex:1] objectForKey:@"content"]];
                
                self.commentTLab.frame = CGRectMake(marginx, MaxY(self.commentSLab),width,[heights.lastObject floatValue]);
                self.commentTLab.attributedText = [self commentTextWithFromUserName:[[fcModel.evaluateList lastObject] objectForKey:@"fromUserName"] content:[[fcModel.evaluateList lastObject] objectForKey:@"content"]];
                self.moreComments.x = 12;
                self.moreComments.y = MaxY(self.commentTLab) + 3;
                self.moreComments.height = 24;
            }
                break;
            default:
                break;
        }
    }];
}

- (NSMutableAttributedString *)commentTextWithFromUserName:(NSString *)fromUserName content:(NSString *)content {
    if (fromUserName.length && ![fromUserName isKindOfClass:[NSNull class]]) {
        NSMutableAttributedString *attriText = [fromUserName addAttributeWithString:[NSString stringWithFormat:@"%@ :  %@",fromUserName,content] attriRange:NSMakeRange(0, fromUserName.length + 2) attriColor:[YSThemeManager themeColor] attriFont:JGFont(14)];
        return attriText;
    }else {
        return [@"" addAttributeWithString:[NSString stringWithFormat:@"       :  %@",content] attriRange:NSMakeRange(0, 8) attriColor:[YSThemeManager themeColor] attriFont:JGFont(14)];
    }
}




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 点击cell的时候不要变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.backgroundColor = JGColor(247, 247, 247, 1);
    /***   用户头像 */
    UIImageView *iconImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconImgView];
    self.iconImgView = iconImgView;
    
    /***  昵称 */
    UILabel *nickLab = [[UILabel alloc] init];
    nickLab.font = YSHealthyCircleNickFont;
    nickLab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
    [self.contentView addSubview:nickLab];
    self.nickLab = nickLab;
    
    /***  性别图像 */
    UIImageView *genderImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:genderImgView];
    self.genderImgView = genderImgView;
    
    /***  用户等级 */
    UILabel *levelLab = [[UILabel alloc] init];
    levelLab.font = JGFont(12);
    levelLab.textColor = [UIColor grayColor];
    self.levelLab = levelLab;
    
    JGTouchEdgeInsetsButton *deleteButton = [JGTouchEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setTitle:@"删 除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [deleteButton setBackgroundColor:JGClearColor];
    deleteButton.titleLabel.font = JGFont(13);
    deleteButton.touchEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5);
    [deleteButton addTarget:self action:@selector(deleteCircle) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.hidden = YES;
    [self.contentView addSubview:deleteButton];
    self.deleteButton = deleteButton;
    
    /***  用户标签Tag */
    UILabel *tagLab = [[UILabel alloc] init];
    [self.contentView addSubview:tagLab];
    self.tagLab = tagLab;
    
    /***  发布时间 */
    UILabel *dateLab = [[UILabel alloc] init];
    dateLab.font = JGFont(12);
    dateLab.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
    [self.contentView addSubview:dateLab];
    self.dateLab = dateLab;
    
    /***  发表内容 */
    YYLabel *contentLab = [[YYLabel alloc] init];
    contentLab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
    [self.contentView addSubview:contentLab];
    self.contentLab = contentLab;
    
    /***  配图 */
    YSFriendPhotosView *photosView = [[YSFriendPhotosView alloc] init];
    [self.contentView addSubview:photosView];
    self.photosView = photosView;
    
    /***  位置信息 */
    YSHealthyCircleLocateView *localView = [[YSHealthyCircleLocateView alloc] init];
    [self.contentView addSubview:localView];
    self.localView = localView;
    
    /***  评论视图 */
    UIView *commentsBgView = [UIView new];
    commentsBgView.backgroundColor = JGClearColor;
    [self.contentView addSubview:commentsBgView];
    self.commentsBgView = commentsBgView;
    
    UILabel *commentFLab = [UILabel new];
    commentFLab.font = JGFont(14);
    commentFLab.numberOfLines = 0;
    commentFLab.backgroundColor = JGClearColor;
    [self.commentsBgView addSubview:commentFLab];
    self.commentFLab = commentFLab;
    
    UILabel *commentSLab = [UILabel new];
    commentSLab.numberOfLines = 0;
    commentSLab.font = JGFont(14);
    commentSLab.backgroundColor = JGClearColor;
    [self.commentsBgView addSubview:commentSLab];
    self.commentSLab = commentSLab;
    
    UILabel *commentTLab = [UILabel new];
    commentTLab.numberOfLines = 0;
    commentTLab.font = JGFont(14);
    commentTLab.backgroundColor = JGClearColor;
    [self.commentsBgView addSubview:commentTLab];
    self.commentTLab = commentTLab;
    
    UIView *commentLineView = [UIView new];
    commentLineView.backgroundColor = JGColor(247, 247, 247, 1);
    [self.commentsBgView addSubview:commentLineView];
    self.commentLineView = commentLineView;
    
    UIButton *moreComments = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreComments setTitle:@"查看更多评论" forState:UIControlStateNormal];
    moreComments.titleLabel.font = JGRegularFont(13);
    
    moreComments.width = [moreComments.currentTitle sizeWithFont:JGFont(13) maxH:24].width;
    [moreComments setTitleColor:[UIColor colorWithHexString:@"#9b9b9b"] forState:UIControlStateNormal];
    [self.commentsBgView addSubview:moreComments];
    self.moreComments = moreComments;
    @weakify(self);
    [self.moreComments addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        BLOCK_EXEC(self.friendCircleClickCallback,1);
    }];

    /***  底部 */
    YSFriendCircleToolsView *toolsView = [[YSFriendCircleToolsView alloc] init];
    [self.contentView addSubview:toolsView];
    self.toolsView = toolsView;
}

- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    UIImageView *imageView = (UIImageView *)[self.photosView.subviews xf_safeObjectAtIndex:index];
    return imageView.image;
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    NSString *urlString =  [self.circleFrame.friendCircleModel.images xf_safeObjectAtIndex:index];
    return [NSURL URLWithString:urlString];
}

- (void)deleteCircle {
    BLOCK_EXEC(self.deleteCircleCallback);
}

@end
