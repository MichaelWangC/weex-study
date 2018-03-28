//
//  XAxisValueFormatter.h
//  ios
//
//  Created by SunnyMiao on 2018/2/27.
//  Copyright © 2018年 weexstudy. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Charts;
@interface XAxisValueFormatter : NSObject<IChartAxisValueFormatter>

- (id)initWithDateArr:(NSArray *)arr;

@end

