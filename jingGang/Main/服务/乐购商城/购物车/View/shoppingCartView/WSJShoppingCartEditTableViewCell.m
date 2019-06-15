//
//  WSJShoppingCartEditTableViewCell.m
//  jingGang
//
//  Created by thinker on 15/8/7.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "WSJShoppingCartEditTableViewCell.h"
#import "GlobeObject.h"
#import "VApiManager.h"
#import "KJShoppingAlertView.h"
#import "Masonry.h"
#import "YSImageConfig.h"

@interface WSJShoppingCartEditTableViewCell ()
{
    WSJShoppingCartInfoModel *_model;
    VApiManager *_vapiManager;
    __weak IBOutlet UIButton *_jianfaBtn;
}

//选中按钮
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
//标题图片
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
//商品规格
@property (weak, nonatomic) IBOutlet UILabel *specInfo;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelectGoodsCount;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUPArr;
@property (weak, nonatomic) IBOutlet UIView *changeGoodsCountBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *changeGoodsCountEquleLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *changeGoodsCountWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *changeGoodsCountHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteButtonWidth;

@end

@implementation WSJShoppingCartEditTableViewCell

- (void)willCellWith:(WSJShoppingCartInfoModel *)model
{
    _model = model;
    self.selectBtn.selected = model.isSelect;
    [YSImageConfig yy_view:self.titleImageView setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:DEFAULTIMG];
    self.specInfo.text = model.specInfo;
    if (!model.specInfo || model.specInfo.length == 0) {
        self.imageViewUPArr.hidden = YES;
    }else{
        self.imageViewUPArr.hidden = NO;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%@",model.count];
    if ([model.count intValue] == 1)
    {
        _jianfaBtn.selected = YES;
        self.imageViewSelectGoodsCount.image = [UIImage imageNamed:@"select_CarGoods_Count_No"];
        _jianfaBtn.userInteractionEnabled = NO;
    }
    else
    {
        self.imageViewSelectGoodsCount.image = [UIImage imageNamed:@"select_CarGoods_Count"];
        _jianfaBtn.selected = NO;
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.specInfo.adjustsFontSizeToFitWidth = YES;
    self.countLabel.adjustsFontSizeToFitWidth = YES;
    _vapiManager = [[VApiManager alloc] init];
    self.deleteButton.backgroundColor = UIColorFromRGB(0xfe5f48);
    
    if (iPhone4 || iPhone5) {
        self.changeGoodsCountHeight.constant = 27.0;
        self.changeGoodsCountWidth.constant = 120.5;
        self.changeGoodsCountEquleLeft.constant = 11.9;
        self.deleteButtonWidth.constant = 62.0;
    }else if (iPhone6p){
        self.changeGoodsCountWidth.constant = 160.0;
        self.changeGoodsCountHeight.constant = 32.0;
        self.changeGoodsCountEquleLeft.constant = 14;
    }
}
- (IBAction)deleteCell:(UIButton *)sender
{
    if (self.deleteCell)
    {
        self.deleteCell(self.indexPath);
    }
}
- (IBAction)selectAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _model.isSelect = sender.selected;
    if (self.selectShopping)
    {
        self.selectShopping([_model.ID stringValue],sender.selected);
    }
}
//商品个数计算
- (IBAction)countActionBtn:(UIButton *)sender
{
    int count = [self.countLabel.text intValue];
    if (sender.tag == 1)//减法操作
    {
        if (count > 1)
        {
            self.countLabel.text = [NSString stringWithFormat:@"%d",--count];
        }
        if (count == 1)
        {
            sender.selected = YES;
            self.imageViewSelectGoodsCount.image = [UIImage imageNamed:@"select_CarGoods_Count_No"];
            sender.userInteractionEnabled = NO;
        }
        else
        {
            sender.selected = NO;
        }
        
    }
    else if (sender.tag == 2)//加法操作
    {
        if (count < [_model.goodsInventory intValue])
        {
            self.countLabel.text = [NSString stringWithFormat:@"%d",++count];
            _jianfaBtn.selected = NO;
            self.imageViewSelectGoodsCount.image = [UIImage imageNamed:@"select_CarGoods_Count"];
            _jianfaBtn.userInteractionEnabled = YES;
        }
        else
        {
            
           [KJShoppingAlertView showAlertTitle:@"亲，没那么多库存量！" inContentView:self.window];
            return;
        }
        
    }
    _model.count = @(count);
    if (self.changeCount) {
        self.changeCount(count,_model.ID);
    }
}

- (IBAction)btnAction:(id)sender {
    [self selectAction:self.selectBtn];
}

@end
