//
//  MainADView.h
//  中间大2边小轮播
//
//  Created by 郭朝顺 on 2019/5/20星期一.
//  Copyright © 2019年 智网易联. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^callBackBlock)(id data);
@interface MainADView : UIView

@property (nonatomic,assign) CGFloat timerInterval ;
@property (nonatomic,strong) NSArray * dataSourse ;
@property (nonatomic,copy) callBackBlock callBack ;

@end

NS_ASSUME_NONNULL_END
