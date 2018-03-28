//
//  WXLineChartView.m
//  ios
//
//  Created by SunnyMiao on 2018/2/27.
//  Copyright © 2018年 weexstudy. All rights reserved.
//

#import "WXLineChartView.h"
@import Charts;
#import "XAxisValueFormatter.h"
@interface WXLineChartView()<ChartViewDelegate>

@property (nonatomic, strong) LineChartView *chartView;
@property (nonatomic, strong) UILabel *markerLabel;

@end

@implementation WXLineChartView

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance {
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance];
    if (self) {
        if (!_chartView) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                _chartView = [[LineChartView alloc] init];
            }];
        }
        [self buildView:attributes];
    }
    return self;
}


- (void)buildView:(NSDictionary *)attributes {
    
    _chartView.delegate = self;
    
}

- (void)setChartPattern {
    
    _chartView.xAxis.drawGridLinesEnabled = NO;//不绘制网格线
    _chartView.xAxis.labelPosition = XAxisLabelPositionBottom; //X轴的显示位置，默认是显示在上面的
    _chartView.xAxis.axisLineWidth = 0;
    _chartView.xAxis.labelCount = 3;
    _chartView.xAxis.labelTextColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    _chartView.xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    _chartView.chartDescription.enabled = NO;
    
    _chartView.dragEnabled = NO;
    [_chartView setScaleEnabled:NO];
    _chartView.pinchZoomEnabled = NO;
    _chartView.drawGridBackgroundEnabled = NO;
    
    //    ChartMarkerImage
    //    ChartMarkerView *marker = [[ChartMarkerView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    //    _markerLabel = [[UILabel alloc] initWithFrame:CGRectMake(-30, -15, 60, 30)];
    //    _markerLabel.font = [UIFont systemFontOfSize:12.f];
    //    _markerLabel.textAlignment = NSTextAlignmentCenter;
    //    [marker addSubview:_markerLabel];
    //    _chartView.marker = marker;
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.drawBottomYLabelEntryEnabled = YES;
    leftAxis.drawGridLinesEnabled = NO;  //绘制网格线
    leftAxis.axisLineWidth = 0;
    
    //    leftAxis.axisMaximum = 15.0;  //y轴最大值
    //    leftAxis.axisMinimum = -5.0;  //y轴最小值
    leftAxis.drawZeroLineEnabled = YES;  //是否从零开始
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    _chartView.rightAxis.enabled = NO;
    
    _chartView.legend.form = ChartLegendFormLine;
    
    [_chartView animateWithYAxisDuration:1.0f];

}

- (void)updateAttributes:(NSDictionary *)attributes
{
    [self setDataAttributes: attributes];
}



- (void)setDataAttributes:(NSDictionary *)attributes
{
    NSArray *arr = [attributes[@"lineData"] componentsSeparatedByString:@"|"];
    
    NSArray *xArr = [arr[0] componentsSeparatedByString:@","];
    NSArray *yArr1 = [arr[1] componentsSeparatedByString:@","];
    NSArray *yArr2 = [arr[2] componentsSeparatedByString:@","];
    // x轴
//    NSArray *xValues = @[
//                         @"2018-01",
//                         @"2018-04",
//                         @"2018-07",
//                         @"2018-10"];
    
    if (xArr.count > 0) {
        _chartView.xAxis.axisMaximum = xArr.count - 1;
        _chartView.xAxis.valueFormatter = [[XAxisValueFormatter alloc] initWithDateArr:xArr];
        // 这里将代理赋值为一个类的对象, 该对象需要遵循IChartAxisValueFormatter协议, 并实现其代理方法(我们可以对需要显示的值进行各种处理, 这里对日期进行格式处理)(当然下面的各代理也都可以这样写)
    }

    // y轴
    NSMutableArray *values = [[NSMutableArray alloc] init];
    NSMutableArray *values1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < yArr1.count; i++)
    {
//        double val = arc4random_uniform(range) + 3;
        double y =  [yArr1[i] doubleValue];
        [values addObject:[[ChartDataEntry alloc] initWithX:i y:y icon: NULL]];
    }
    
    for (int i = 0; i < yArr2.count; i++)
    {
        //        double val = arc4random_uniform(range) + 3;
        double y =  [yArr2[i] doubleValue];
        [values1 addObject:[[ChartDataEntry alloc] initWithX:i y:y icon: NULL]];
    }
    
    LineChartDataSet *set1 = nil;
    LineChartDataSet *set2 = nil;
    if (_chartView.data.dataSetCount > 1)
    {
        
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        set1.values = values;
        
        set2 = (LineChartDataSet *)_chartView.data.dataSets[1];
        set2.values = values1;
        
        
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithValues:values label:NULL];

        set1.drawIconsEnabled = NO;
        
        [set1 setColor:[UIColor colorWithRed:54/255.0  green:205/255.0 blue:140/255.0 alpha:1.f]];
        
        set1.lineWidth = 1.0;

        set1.drawCirclesEnabled = NO;
        set1.drawValuesEnabled = NO;
        set1.drawFilledEnabled = YES;
        set1.drawIconsEnabled = YES;
        
        NSArray *gradientColors = @[
                                    (id)[ChartColorTemplates colorFromString:@"#36CD8C"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#FBFFFD"].CGColor
                                    ];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        
        set1.fillAlpha = 0.5f;
        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:270.f];
        
        CGGradientRelease(gradient);
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        
        
        
        LineChartDataSet *set2 = [[LineChartDataSet alloc] initWithValues:values label:NULL];
//        NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
//        for (int i = 0; i < yArr2.count; i++) {
////            double mult = count + 1;
////            double val = (double)(arc4random_uniform(mult));
//            double y =  [yArr2[i] doubleValue];
//            NSLog(@"**********%g", y);
//            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:y icon: NULL];
//            [yVals2 addObject:entry];
//        }
        
        set2.drawIconsEnabled = NO;
        set2.values = values1;
        [set2 setColor:[UIColor colorWithRed:255/255.0  green:156/255.0 blue:27/255.0 alpha:1.f]];
        set2.drawCirclesEnabled = NO;
        set2.drawValuesEnabled = NO;
        set2.drawFilledEnabled = YES;//是否填充颜色
        set2.fillColor = [UIColor redColor];//填充颜色
        set2.fillAlpha = 0.1;//填充颜色的透明度
        
        NSArray *gradientColors1 = @[
                                     (id)[ChartColorTemplates colorFromString:@"#FF9C1B"].CGColor,
                                     (id)[ChartColorTemplates colorFromString:@"#FFFBF7"].CGColor
                                     ];
        CGGradientRef gradient1 = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors1, nil);
        
        set2.fillAlpha = 0.5f;
        set2.fill = [ChartFill fillWithLinearGradient:gradient1 angle:270.f];
        set2.drawFilledEnabled = YES;
        set2.drawIconsEnabled = YES;

//        set2.drawCubicEnabled = YES;// 接点处平滑

        CGGradientRelease(gradient1);
        
        [dataSets addObject:set1];
        [dataSets addObject:set2];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        _chartView.data = data;
    }
    [self setChartPattern];
}

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    _markerLabel.text = [NSString stringWithFormat:@"%g", entry.y];
}

-(UIView *)loadView {
    return _chartView;
}

@end
