//
//  XAxisValueFormatter.m
//  ssssss
//
//  Created by SunnyMiao on 2018/2/27.
//  Copyright © 2018年 SunnyMiao. All rights reserved.
//

#import "XAxisValueFormatter.h"

@interface XAxisValueFormatter () {
    NSArray *_dateArr;
    NSDateFormatter *_preFormatter;
    NSDateFormatter *_needFormatter;
}
@end

@implementation XAxisValueFormatter

- (id)initWithDateArr:(NSArray *)arr {
    if (self = [super init]) {
        _dateArr = [NSArray arrayWithArray:arr];
        
        _preFormatter = [[NSDateFormatter alloc] init];
        _preFormatter.dateFormat = @"yyyy-MM-dd";
        
        
        _needFormatter = [[NSDateFormatter alloc] init];
        _needFormatter.dateFormat = @"MM.dd";
    }
    return self;
}

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    if (_dateArr.count > 0) {
        NSString *dateStr = _dateArr[(int)value];
        
        return dateStr;
    }
    return @"";
}

@end


