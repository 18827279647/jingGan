//
//  YSHealthyMessageCell.m
//  jingGang
//
//  Created by dengxf on 16/7/25.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthyMessageCell.h"
#import "GlobeObject.h"
#import "YSThumbnailManager.h"
#import "YSImageConfig.h"

@interface YSHealthyMessageCell ()

@property (strong,nonatomic) UIImageView *iconImgView;

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UILabel *contentLab;

@property (strong,nonatomic) NSDictionary *dict;

@end

@implementation YSHealthyMessageCell

+ (instancetype)setupCellWithTableView:(UITableView *)tableView data:(NSDictionary *)dict {
    static NSString *cellId = @"YSHealthyMessageCell";
    YSHealthyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[YSHealthyMessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.dict = dict;
    return cell;
}

- (void)setDict:(NSDictionary *)dict {
    //    NSString *url = [NSString stringWithFormat:@"%@_%ix%i",[dict objectForKey:@"thumbnail"],(int)self.iconImgView.width*2,(int)self.iconImgView.height*2];
    
    NSString *url = [NSString stringWithFormat:@"%@",[dict objectForKey:@"thumbnail"]];
    
    NSString *picUrlString = [YSThumbnailManager healthyManagerHealthyInformationThumbnailPicUrlString:url];
    
//    [self.iconImgView setImageWithURL:[NSURL URLWithString:picUrlString] placeholder:[UIImage imageNamed:@"ys_placeholder_circle"] options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//        
//    }];
    
    [YSImageConfig yy_view:self.iconImgView setImageWithURL:[NSURL URLWithString:picUrlString] placeholder:[UIImage imageNamed:@"ys_placeholder_circle"] options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
    
    self.titleLab.text = [dict objectForKey:@"title"];
    self.contentLab.text = [self filterHTML:[dict objectForKey:@"content"]];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    CGFloat width = 0.;
    CGFloat height = 80;
    width = 112;
    CGFloat originX = 12.0f;
    CGFloat originY = (kHealthyMessageCellHeight - height) / 2;
    
    UIImageView *iconImgView = [[UIImageView alloc] init];
    iconImgView.width = width;
    iconImgView.height = height;
    iconImgView.x = originX;
    iconImgView.y = originY;
    [self.contentView addSubview:iconImgView];
    self.iconImgView = iconImgView;
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.x = MaxX(iconImgView) + 8;
    titleLab.y = originY +  8;
    titleLab.width = ScreenWidth - titleLab.x - 12.;
    titleLab.height = 22;
    titleLab.font = JGFont(14);
    titleLab.textColor = YSHexColorString(@"#4a4a4a");
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    
    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.x = titleLab.x;
    contentLab.y = MaxY(titleLab);
    contentLab.width = ScreenWidth - contentLab.x - 12.0f;
    contentLab.height = kHealthyMessageCellHeight - contentLab.y - (kHealthyMessageCellHeight - height) / 2  + 12;
    contentLab.numberOfLines = 2;
    contentLab.font = YSPingFangRegular(12.0);
    contentLab.textColor = YSHexColorString(@"#9b9b9b");
    [self.contentView addSubview:contentLab];
    self.contentLab = contentLab;
    
    UIView *bottomView = [UIView new];
    bottomView.x = 0;
    bottomView.y = kHealthyMessageCellHeight - 0.5;
    bottomView.width = ScreenWidth;
    bottomView.height = 0.5;
    bottomView.backgroundColor = YSHexColorString(@"#f0f0f0");
    [self.contentView addSubview:bottomView];
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



@end
