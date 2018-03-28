//
//  WXPieChartViewController.m
//  ios
//
//  Created by SunnyMiao on 2018/1/15.
//  Copyright © 2018年 weexstudy. All rights reserved.
//

#import "WXPieChartView.h"
@import Charts;

@interface WXPieChartView()<ChartViewDelegate>

@property (nonatomic, strong)  PieChartView *chartView;

@end


@implementation WXPieChartView

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance {
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance];
    if (self) {
        
        [self buildView:attributes];
    }
    return self;
}
- (void)buildView:(NSDictionary *)attributes {
    
//    _chartView = [[PieChartView alloc] init];
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//
//    }];
    _chartView.delegate = self;
    _chartView.usePercentValuesEnabled = NO;
    _chartView.drawHoleEnabled = YES;//饼状图是否是空心
    _chartView.holeRadiusPercent = 0.6;//空心半径占比
    _chartView.drawCenterTextEnabled = YES;//是否显示中间文字
    
    ChartDescription *des = [[ChartDescription alloc] init];
    [des setText:@""];
    [_chartView setChartDescription:des];
    //普通文本
    _chartView.centerText = @"";
    
    _chartView.legend.enabled = NO;
//    _chartView.descriptionText = @"";
    ChartLegend *l = _chartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
    l.orientation = ChartLegendOrientationVertical;
    l.drawInside = NO;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
    
    // entry label styling
    _chartView.entryLabelColor = UIColor.whiteColor;
    _chartView.entryLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    
    [_chartView animateWithXAxisDuration:1.2 easingOption:ChartEasingOptionEaseOutBack];
}

- (void)setChartPattern {
    _chartView.usePercentValuesEnabled = NO;
    _chartView.drawHoleEnabled = YES;//饼状图是否是空心
    _chartView.holeRadiusPercent = 0.6;//空心半径占比
    _chartView.drawCenterTextEnabled = YES;//是否显示中间文字
    
    ChartDescription *des = [[ChartDescription alloc] init];
    [des setText:@""];
    [_chartView setChartDescription:des];
    //普通文本
    _chartView.centerText = @"";
    
    _chartView.legend.enabled = NO;
    //    _chartView.descriptionText = @"";
    ChartLegend *l = _chartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
    l.orientation = ChartLegendOrientationVertical;
    l.drawInside = NO;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
    
    // entry label styling
    _chartView.entryLabelColor = UIColor.whiteColor;
    _chartView.entryLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    
    [_chartView animateWithXAxisDuration:1.2 easingOption:ChartEasingOptionEaseOutBack];
}

- (void)setDataCount:(NSUInteger)count range:(double)range attributes:(NSDictionary *)attributes
{
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        NSArray *arr = [attributes[@"pieData"] componentsSeparatedByString:@","];
        NSArray *arrItem = [arr[i] componentsSeparatedByString:@"|"];
        [entries addObject:[[PieChartDataEntry alloc] initWithValue:[arrItem[1] doubleValue] label:@""]];
    }
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:entries label:@"Election Results"];
    dataSet.sliceSpace = 0;
    
    // add a lot of colors
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
//    237,205,110
//    99,167,248
    [colors addObject:[UIColor colorWithRed:32/255.f green:134/255.f blue:253/255.f alpha:1.f]];
    [colors addObject:[UIColor colorWithRed:237/255.f green:205/255.f blue:110/255.f alpha:1.f]];
    [colors addObject:[UIColor colorWithRed:255/255.f green:156/255.f blue:27/255.f alpha:1.f]];
    [colors addObject:[UIColor colorWithRed:0/255.f green:187/255.f blue:106/255.f alpha:1.f]];
    [colors addObject:[UIColor colorWithRed:99/255.f green:167/255.f blue:248/255.f alpha:1.f]];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
    dataSet.colors = colors;
    dataSet.valueLineWidth = 0;
    dataSet.drawValuesEnabled = NO;
    dataSet.valueLinePart1OffsetPercentage = 0.8;
    dataSet.valueLinePart1Length = 0.2;
    dataSet.valueLinePart2Length = 0.4;
    //dataSet.xValuePosition = PieChartValuePositionOutsideSlice;
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.blackColor];
    
    _chartView.data = data;
    [_chartView highlightValues:nil];
}

#pragma mark - Actions

- (void)updateAttributes:(NSDictionary *)attributes
{
    NSArray *arr = [attributes[@"pieData"] componentsSeparatedByString:@","];
    [self setDataCount:arr.count range:100.0 attributes:attributes];
    [self setChartPattern];
}



#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

-(UIView *)loadView {
    _chartView = [[PieChartView alloc] init];
    return _chartView;
}

@end

