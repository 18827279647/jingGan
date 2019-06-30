//
//  RXMoreWebViewController.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/28.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "JGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RXMoreWebViewController : JGBaseViewController

@property (copy) NSString *urlstring;
@property (copy) NSString *htmlstring;
@property (copy) NSString *titlestring;
@property(copy)NSString*code;

@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)NSMutableArray*titleArray;
@property(nonatomic,assign)bool type;
@end

NS_ASSUME_NONNULL_END
