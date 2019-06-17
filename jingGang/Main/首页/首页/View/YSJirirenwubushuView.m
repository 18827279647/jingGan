//
//  YSJirirenwubushuView.m
//  jingGang
//
//  Created by 李海 on 2018/8/15.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import "YSJirirenwubushuView.h"
#import "STLoopProgressView.h"
#import "SDViewController.h"
@interface YSJirirenwubushuView()

@property (copy , nonatomic) id_block_t cxjcCallback;

@end
@implementation YSJirirenwubushuView

- (instancetype)initWithFrame:(CGRect)frame clickCallback:(void(^)(NSInteger clickIndex))click cxjcCallback:(id_block_t)cxjcCallback 
{
    self = [super init];
    self.cxjcCallback=cxjcCallback;
    if (self) {
        self.frame = frame;
        [self setup];
    }
    return self;
}

- (void)setup {
    UITapGestureRecognizer *ui=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alickList)];

    CGFloat contentWidth=self.width;
    
    UIView *part1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, contentWidth, 200)];
        part1.userInteractionEnabled=YES;
    
        [part1 addGestureRecognizer:ui];
    part1.backgroundColor = JGWhiteColor;
     _processView=[[STLoopProgressView alloc]initWithFrame:CGRectMake(0, 0, 180, 180)];
    [_processView setup];
    UILabel *title=[UILabel new];
    _count=[UILabel new];
    _mubiao=[UILabel new];
    _reliangLabel=[UILabel new];
    _ljlc=[UILabel new];
    _mubiao.font=title.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13.f];
    _mubiao.textColor=title.textColor=[UIColor colorWithHexString:@"#999999"];
    _count.font = [UIFont fontWithName:@"PingFangSC-Medium" size:28.f];
    _count.textColor=[UIColor colorWithHexString:@"#333333"];
    title.text=@"今日步数";
    _count.text=@"10000";
    _mubiao.text=@"设定目标";
    title.x=_count.x=_mubiao.x=0;
    title.y=20;
    _count.y=60;
    _mubiao.y=130;
    title.width=_count.width=_mubiao.width=contentWidth;
    title.height=_mubiao.height=30;
    _count.height=50;
    _reliangLabel.textAlignment=_ljlc.textAlignment=title.textAlignment=_count.textAlignment=
            _mubiao.textAlignment=NSTextAlignmentCenter;
    CGFloat margin=(contentWidth-150*2-20*2)/3;
    UIImageView *huo=[[UIImageView alloc]initWithFrame:CGRectMake(margin, 165, 20, 20)];
    UIImageView *licheng=[[UIImageView alloc]initWithFrame:CGRectMake(100, 165, 20, 20)];
    _reliangLabel.font=_ljlc.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.f];
    _reliangLabel.textColor=_ljlc.textColor=[UIColor colorWithHexString:@"#636363"];
    huo.image=[UIImage imageNamed:@"reliang"];
    licheng.image=[UIImage imageNamed:@"licheng"];
    _reliangLabel.height=_ljlc.height=30;
    _reliangLabel.width=_ljlc.width=150;
    _reliangLabel.x=huo.x+huo.width;
    licheng.x=_reliangLabel.x+_reliangLabel.width+margin;
    _ljlc.x=licheng.x+licheng.width;
    _reliangLabel.y=_ljlc.y=160;
    _reliangLabel.text=@"消耗热量：--卡";
    _ljlc.text=@"累计里程：--公里";
    
    _processView.center=_count.center;
    [part1 addSubview:title];[part1 addSubview:_count];[part1 addSubview:_mubiao];
    [part1 addSubview:huo];[part1 addSubview:licheng];
    [part1 addSubview:_reliangLabel];
    [part1 addSubview:_ljlc];
    [part1 addSubview:_processView];
    [self addSubview:part1];
    //健康检测模块
    _part2=[[UIView alloc]initWithFrame:CGRectMake(0, _processView.frame.size.height+20, contentWidth, 170)];
    _part2.backgroundColor = JGWhiteColor;
//    part2.userInteractionEnabled = NO;
    CGFloat margin2=(contentWidth-95*3)/3;
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
//    NSString * api_XYmaxValue = [[defaults objectForKey:@"XYmaxValue"] stringValue];
//    NSString * api_XYminValue = [[defaults objectForKey:@"XYminValue"] stringValue];
//
//    NSString * str = [NSString stringWithFormat:@"%@/%@",api_XYmaxValue,api_XYminValue];
//
//    NSString * api_xinlv =[[defaults objectForKey:@"heartRateValue"] stringValue];
//    NSString * api_xueyang =[[defaults objectForKey:@"xueyangRateValue"] stringValue];
//
//    NSLog(@"api_XYmaxValue%@",api_XYmaxValue);
//     NSLog(@"api_XYminValue%@",api_XYminValue);
//
//    if (api_XYmaxValue == NULL) {
//       _xueya= [self genItem:@"xueya" titles:@[@"血压",@"--/--",@"mmHg"]];
//    } else {
//        _xueya= [self genItem:@"xueya" titles:@[@"血压",str,@"mmHg"]];
//    }
//
//    if (api_xinlv== NULL) {
//      _xinlv= [self genItem:@"xinlv" titles:@[@"心率",@"--",@"BMP"]];
//    }else{
//        _xinlv= [self genItem:@"xinlv" titles:@[@"心率",api_xinlv,@"BMP"]];
//    }
//
//    if (api_xueyang==NULL) {
//         _xueyang= [self genItem:@"xueyang" titles:@[@"血氧",@"--",@"%"]];
//    } else {
//         _xueyang= [self genItem:@"xueyang" titles:@[@"血氧",@"api_xueyang",@"%"]];
//    }
    
//    UIView *xinlv= [self genItem:@"xinlv" titles:@[@"心率",@"--",@"BMP"]];
//    UIView *xueyang= [self genItem:@"xueyang" titles:@[@"血氧",@"--",@"%"]];
//    _xueya.x=margin2;
//    _xinlv.x=_xueya.x+_xueya.width+margin2+10;
//    _xueyang.x=_xinlv.x+_xinlv.width+margin2;
    UIButton *cxjc=[[UIButton alloc]initWithFrame:CGRectMake((contentWidth-200)/2, 100, 200, 45)];
    [cxjc setTitle:@"重新检测" forState:UIControlStateNormal];
    cxjc.layer.cornerRadius=20;
    cxjc.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.f];
    [cxjc setBackgroundImage:[UIImage imageNamed:@"jrrw_jb_bg"] forState:UIControlStateNormal];

    [cxjc addTarget:self action:@selector(cxjcButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [_part2 addSubview:_xueya];
//    [_part2 addSubview:_xinlv];
//    [_part2 addSubview:_xueyang];
    [_part2 addSubview:cxjc];
    [self addSubview:_part2];
}


//生成第二模块的内容块儿
-(UIView *)genItem:(NSString *)imageName titles:(NSArray *)titles{
    UIView *continer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 95, 80)];
    UIImageView *imgVIew=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 25, 25)];
    imgVIew.image=[UIImage imageNamed:imageName];
    UILabel *zx=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, 25, 35)];
    UILabel *ys=[[UILabel alloc]initWithFrame:CGRectMake(30, 20, 65, 35)];
    UILabel *yx=[[UILabel alloc]initWithFrame:CGRectMake(30, 47, 65, 20)];
    zx.font=yx.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11.f];
    ys.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.f];
    ys.textColor=[UIColor colorWithHexString:@"#333333"];
    yx.textColor=[UIColor colorWithHexString:@"#666666"];
    zx.textColor=[UIColor colorWithHexString:@"#999999"];
    zx.text=titles[0];
    ys.text=titles[1];
    yx.text=titles[2];
    [continer addSubview:imgVIew];
    [continer addSubview:zx];
    [continer addSubview:ys];
    [continer addSubview:yx];
    return continer;
}
- (void)cxjcButtonClick{
    BLOCK_EXEC(self.cxjcCallback,0);
}

-(void)alickList{

    SDViewController * view =[[SDViewController alloc] init];
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] && object != nil) {
        object = [object nextResponder];
    }
    UIViewController *superController = (UIViewController*)object;
    [superController.navigationController pushViewController:view animated:YES];
}

@end
