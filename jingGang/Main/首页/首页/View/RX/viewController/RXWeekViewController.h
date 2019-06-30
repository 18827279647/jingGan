//
//  RXWeekViewController.h
//  jingGang
//
//  Created by 荣旭 on 2019/6/27.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "JGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RXWeekViewController : JGBaseViewController

@property (copy) NSString *urlstring;
@property (copy) NSString *titlestring;
@property (copy) NSString *htmlstring;
//类型week、moth
@property(copy)NSString*type;

@end

NS_ASSUME_NONNULL_END
