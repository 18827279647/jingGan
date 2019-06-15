//
//  KJDarlingCommentVC.m
//  jingGang
//
//  Created by 张康健 on 15/8/17.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "KJDarlingCommentVC.h"
#import "KJDarlingTableView.h"
#import "VApiManager.h"
#import "GoodsInfoModel.h"
#import "DarlingCommentModel.h"
#import "NSDictionary+JsonString.h"
#import "GlobeObject.h"
#import "MBProgressHUD.h"
#import "Util.h"
#import "WSProgressHUD.h"
#import "KJShoppingAlertView.h"
#import "YSImageUploadManage.h"

@interface KJDarlingCommentVC (){

    VApiManager *_vapManager;
    NSMutableArray *_goodsModelArr;
}

@property (weak, nonatomic) IBOutlet KJDarlingTableView *dc_darlingTableView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation KJDarlingCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _init];
    
}


-(void)_init{
    self.commitButton.backgroundColor = [YSThemeManager buttonBgColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [YSThemeManager setNavigationTitle:@"宝贝评价" andViewController:self];
    _vapManager = [[VApiManager alloc] init];
    _goodsModelArr = [NSMutableArray arrayWithCapacity:_goodsInfos.count];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    for (NSDictionary *dic in self.goodsInfos) {
        GoodsInfoModel *model = [[GoodsInfoModel alloc] initWithJSONDic:dic];
        [_goodsModelArr addObject:model];
    }
    
    self.dc_darlingTableView.goodsArr = (NSArray *)_goodsModelArr;
    [self.dc_darlingTableView reloadData];
}



- (IBAction)makeCommentAction:(id)sender {
    
    //拿到table的数组
    NSMutableArray *commentDataArr = self.dc_darlingTableView.commentModelArr;
    
    if ([self _checkCommentContentIsEmptyOfCommentArr:commentDataArr]) {//有没评论的内容
        [UIAlertView xf_showWithTitle:@"请填写评价内容" message:nil delay:1.2 onDismiss:NULL];
        return;
    }
    
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
    //把数组中所有的图片都合成一个数组，并上传获得所有的图片URL
    NSMutableArray *tempAllImagesArray = [NSMutableArray array];
    for (NSInteger i = 0; i < commentDataArr.count; i++) {
        DarlingCommentModel *model = commentDataArr[i];
        //model中的图片数组
        if (model.commentImgArr.count > 1) {
            for (NSInteger j = 0; j < model.commentImgArr.count - 1; j++) {
                //取出所有图片
                UIImage *imageComment = model.commentImgArr[j];
                //添加进到一个临时数组中,做上传获取URL用
                [tempAllImagesArray addObject:imageComment];
            }
        }
    }

    if (tempAllImagesArray.count > 0) {
        //有图片上传
        //上传图片获取到url
        @weakify(self);
        
        __block NSMutableArray * arrayImagesUrl = [NSMutableArray array];
        [YSImageUploadManage uploadImagesShouldClips:NO targetImageSize:CGSizeZero images:[tempAllImagesArray copy] attrText:[NSAttributedString new] labels:[NSMutableArray array] composePosition:@"" uploadImageCompleted:^(NSString *msg) {
            @strongify(self);
            
            //把返回URL拆分成数组
            dispatch_async(dispatch_get_main_queue(), ^{
                // 回到主线程
                arrayImagesUrl = [NSMutableArray arrayWithArray:[msg componentsSeparatedByString:@";"]];
                [self postCommentSvaeRequestWithCommentDataArray:commentDataArr arrayImagesUrl:arrayImagesUrl];
            });
           
        } imagePathDividKeyword:@";" pathSourceType:YSUploadImageSourcePathFromEles];
        //上传图片报错
        [YSImageUploadManage sharedInstance].composeResultCallback = ^(BOOL result, NSString *msg) {
            if (result) {
                
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 回到主线程,执⾏UI刷新操作
                    [WSProgressHUD dismiss];
                    [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:NULL];
                    return ;
                });
            }
        };
    }else{
        //没图片上传
        [self postCommentSvaeRequestWithCommentDataArray:commentDataArr arrayImagesUrl:[NSMutableArray array]];
    }

    
    
}


- (void)postCommentSvaeRequestWithCommentDataArray:(NSMutableArray *)commentDataArray arrayImagesUrl:(NSMutableArray *)arrayImagesUrl{
    
    //把数组中含有图片的数组元素以及相关的图片数量查出来
    NSArray *arrayHasImagesCommentGoods = [self calcuArrayHasImagesWithArray:[commentDataArray copy]];
    
        for (NSInteger i = 0; i < arrayHasImagesCommentGoods.count; i++) {
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:arrayHasImagesCommentGoods[i]];
            
            //哪个数组元素中有图片
            NSInteger hasImageIndex = [[NSString stringWithFormat:@"%@",dict[@"hasImageIndex"]] integerValue];
            //该数组元素中含有的图片数量
            NSInteger imagseCount   = [[NSString stringWithFormat:@"%@",dict[@"imagseCount"]] integerValue];
            
            //根据上述条件，取出url数组中取出对应的url
            NSMutableArray *arrayTempImagesUrlIndex = [NSMutableArray array];
            for (NSInteger j = 0; j < imagseCount; j++) {
                [arrayTempImagesUrlIndex addObject:arrayImagesUrl[0]];
                [arrayImagesUrl removeObjectAtIndex:0];
            }
            //将数组拼成一个字符串
            NSString *strCommentGoodsUrl = [arrayTempImagesUrlIndex componentsJoinedByString:@";"];
            //根据对应的数组元素下标，取出对应的model
            DarlingCommentModel *model = commentDataArray[hasImageIndex];
            //把获得的字符串赋值给对应数组下标的model中的url字符串
            model.joinedImgUrlStr = strCommentGoodsUrl;
            //替换掉原来的数组
            [commentDataArray replaceObjectAtIndex:hasImageIndex withObject:model];
        }
    
    //根据数组组装成json串
    NSString *requestStr = [self _makeCommentRequestDicWithArr:commentDataArray];
    
    JGLog(@"comment str %@",requestStr);
    
    //评论请求
    [self _commentSaveRequestWithJsonStr:requestStr];
}


//评论请求
-(void)_commentSaveRequestWithJsonStr:(NSString *)commentJSONStr{
    
    SelfOrderEvaluateSaveRequest *reqquest = [[SelfOrderEvaluateSaveRequest alloc] init:GetToken];
    reqquest.api_evaluateInfo = commentJSONStr;
    //评论操作
    [_vapManager selfOrderEvaluateSave:reqquest success:^(AFHTTPRequestOperation *operation, SelfOrderEvaluateSaveResponse *response) {
        
        [WSProgressHUD dismiss];
        
        if (response.errorCode.integerValue > 0) {
            [UIAlertView xf_showWithTitle:@"评论失败" message:response.subMsg delay:1.0 onDismiss:NULL];
        }else{
            if (self.refreshOrderListNotice) {
                self.refreshOrderListNotice();
            }
            [UIAlertView xf_showWithTitle:@"评论成功" message:nil delay:1.0 onDismiss:NULL];
        }
        
        [self performSelector:@selector(btnClick) withObject:nil afterDelay:1.0];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WSProgressHUD dismiss];
        [UIAlertView xf_showWithTitle:@"评论失败" message:nil delay:1.0 onDismiss:NULL];
        [self performSelector:@selector(btnClick) withObject:nil afterDelay:1.0];

    }];

}
#pragma mark -- 算出商品数组中哪几个是有图片的，把数组的元素数量以及数组下标记下来
- (NSArray *)calcuArrayHasImagesWithArray:(NSArray *)array{
    
    NSMutableArray *arrayHasImageCount = [NSMutableArray array];
    for (NSInteger i = 0; i < array.count; i++) {
        DarlingCommentModel *model = array[i];
        if (model.commentImgArr.count > 1) {
            //大于1表示该商品评价信息有图片
            
             //有图片的数组元素
            NSString *strhasImageIndex = [NSString stringWithFormat:@"%ld",i];
            //该元素中拥有的图片数量
            NSString *strImagseCount = [NSString stringWithFormat:@"%ld",model.commentImgArr.count - 1];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:strhasImageIndex,@"hasImageIndex",strImagseCount,@"imagseCount", nil];
            [arrayHasImageCount addObject:dic];
        }
    }
    
    return [arrayHasImageCount copy];
}




-(BOOL)_checkCommentContentIsEmptyOfCommentArr:(NSArray *)commentDataArr{

    BOOL isContentEmpty = NO;
    for (DarlingCommentModel *model in commentDataArr) {
        if (isEmpty(model.commentTextContent)) {
            isContentEmpty = YES;
            break;
        }
    }
    return isContentEmpty;
}


-(NSString *)_makeCommentRequestDicWithArr:(NSArray *)commentDataArr{
    
    NSMutableArray *evaluateArr = [NSMutableArray arrayWithCapacity:commentDataArr.count];
    for (DarlingCommentModel *model in commentDataArr) {
        JGLog(@"goods id %@",model.goodsId);
        
        //数据的处理
        if (model.commentLevel == 2) {//中评
            model.commentLevel = 0;
        }else if (model.commentLevel == 3){//差评
            model.commentLevel = -1;
        }else if (!model.commentLevel){//没评,默认给个好评
            model.commentLevel = 1;
        }
        
        //设置评级默认值
        if (!model.descriptionStars) {
            model.descriptionStars = 1;
        }
        if (!model.deliveryServiceStars) {
            model.deliveryServiceStars = 1;
        }
        if (!model.deliveryServiceStars) {
            model.deliveryServiceStars = 1;
        }
        
         NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setObject:model.goodsId forKey:@"goodsId"];
        [dic setObject:@(model.descriptionStars) forKey:@"description"];
        [dic setObject:@(model.deliveryServiceStars) forKey:@"shipEvaluate"];
        [dic setObject:@(model.serviceAltitudeStars) forKey:@"serviceEvaluate"];
        [dic setObject:@(model.commentLevel) forKey:@"evaluateBuyerVal"];
        
        if (![model.commentTextContent isEqualToString:@""]) {
            [dic setObject:model.commentTextContent forKey:@"evaluateInfo"];
        }
        if (!model.joinedImgUrlStr) {
            model.joinedImgUrlStr = @"";
        }
        [dic setObject:model.joinedImgUrlStr forKey:@"imgPath"];
        
        
        [dic setObject:model.goodsCount forKey:@"goodsCount"];
        [dic setObject:model.goodsPrice forKey:@"goodsPrice"];
        [dic setObject:model.goodsGspVal forKey:@"goodsGspVal"];
        
        [evaluateArr addObject:(NSDictionary *)dic];
    }
    
    NSDictionary *requestDic = @{@"id":self.orderID,
                                 @"evaluate":(NSArray *)evaluateArr};
    
    return [requestDic jsonString];

}


@end
