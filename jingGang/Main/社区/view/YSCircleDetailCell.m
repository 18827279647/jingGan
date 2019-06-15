//
//  YSCircleDetailCell.m
//  jingGang
//
//  Created by dengxf11 on 16/9/2.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSCircleDetailCell.h"
#import "GlobeObject.h"
#import "UIImage+YYAdd.h"
#import "YSTriangleView.h"
#import "YSImageConfig.h"

@interface YSCircleDetailCell ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UIImageView *headerImgView;

@property (strong,nonatomic) UILabel *nickNameLab;

@property (strong,nonatomic) UILabel *dateLab;

@property (strong,nonatomic) UILabel *contentLab;

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *dataArray;

@property (strong,nonatomic) YSTriangleView *triangleView;

@property (strong,nonatomic) UIView *bottomLineView;

@end

@implementation YSCircleDetailCell

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


+ (instancetype)configCircelDetailCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"kDetailCellId";
    YSCircleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[YSCircleDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setCommentFrame:(YSCommentFrame *)commentFrame {
    _commentFrame = commentFrame;
    YSCommentModel *commentModel = commentFrame.comment;
    self.headerImgView.frame = commentFrame.headImgF;
    self.headerImgView.layer.cornerRadius = self.headerImgView.width / 2;
    self.headerImgView.clipsToBounds = YES;
    [YSImageConfig yy_view:self.headerImgView setImageWithURL:[NSURL URLWithString:commentModel.headImgPath] placeholder:kDefaultUserIcon options:YYWebImageOptionProgressive completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
    
    self.nickNameLab.frame = commentFrame.nickNameF;
    if (commentModel.commentType == YSCommentCellType) {
        self.nickNameLab.text = commentModel.fromUserName;
    }if (commentModel.commentType == YSReplyCellType) {
        self.nickNameLab.text = [NSString stringWithFormat:@"%@:",commentModel.fromUserName];
    }
    
    self.dateLab.frame = commentFrame.dateF;
    self.dateLab.text = commentModel.addtiemFormat;
    
    self.contentLab.frame = commentFrame.contentF;
    self.contentLab.text = commentModel.content;
    
    
    if (commentModel.replyList.count > 0) {
        self.triangleView.hidden = NO;
        self.triangleView.x = commentFrame.triangleF.origin.x;
        self.triangleView.y = commentFrame.triangleF.origin.y;
        
    }else {
        self.triangleView.hidden = YES;
    }
    self.tableView.frame = commentFrame.tableViewF;
    [self.dataArray removeAllObjects];
    [self.dataArray xf_safeAddObjectsFromArray:commentModel.replyList];
    [self.tableView reloadData];
    
    self.bottomLineView.frame = commentFrame.bottomLineF;

}

- (void)setup {
    UIImageView *headerImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:headerImgView];
    self.headerImgView = headerImgView;
    
    UILabel *nickNameLab = [[UILabel alloc] init];
    nickNameLab.font = kNickNameFont;
    nickNameLab.textAlignment = NSTextAlignmentLeft;
    nickNameLab.textColor = JGColor(167, 167, 167, 1);
    [self.contentView addSubview:nickNameLab];
    self.nickNameLab = nickNameLab;
    
    UILabel *dateLab = [UILabel new];
    dateLab.font = JGFont(12);
    dateLab.textAlignment = NSTextAlignmentLeft;
    dateLab.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:dateLab];
    self.dateLab = dateLab;
    
    UILabel *contentLab = [UILabel new];
    contentLab.font = kContentFont;
    contentLab.textAlignment = NSTextAlignmentLeft;
    contentLab.numberOfLines = 0;
    [self.contentView addSubview:contentLab];
    self.contentLab = contentLab;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.layer.cornerRadius = 3;
    tableView.tableFooterView = [UIView new];
    tableView.scrollEnabled = NO;
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    
    YSTriangleView *triangleView = [[YSTriangleView alloc] initWithFrame:CGRectMake(-20, -20, 15, 10)];
    triangleView.backgroundColor = JGClearColor;
    [self.contentView addSubview:triangleView];
    self.triangleView = triangleView;
    
    
    UIView *bottomLineView = [UIView new];
    bottomLineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.24];
    [self.contentView addSubview:bottomLineView];
    self.bottomLineView = bottomLineView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSCommentFrame *frame = [self.dataArray xf_safeObjectAtIndex:indexPath.row];
    return frame.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellId = @"replyCommentId";
    YSCircleDetailCell *cell   = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[YSCircleDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
        cell.backgroundColor = JGBaseColor;
    }
    YSCommentFrame *frame = [self.dataArray xf_safeObjectAtIndex:indexPath.row];
    cell.commentFrame = frame;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSCommentFrame *frame = [self.dataArray xf_safeObjectAtIndex:indexPath.row];
    BLOCK_EXEC(self.didSelectedReplyCellCallback,frame);
}


@end
