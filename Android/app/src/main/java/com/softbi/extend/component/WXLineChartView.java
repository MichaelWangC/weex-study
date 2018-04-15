package com.softbi.extend.component;

import android.content.Context;
import android.graphics.Color;
import android.support.annotation.NonNull;
import android.view.View;

import com.github.mikephil.charting.charts.LineChart;
import com.github.mikephil.charting.components.AxisBase;
import com.github.mikephil.charting.components.Description;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.components.YAxis;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.LineData;
import com.github.mikephil.charting.data.LineDataSet;
import com.github.mikephil.charting.formatter.IAxisValueFormatter;
import com.github.mikephil.charting.interfaces.datasets.ILineDataSet;
import com.taobao.weex.WXSDKInstance;
import com.taobao.weex.dom.WXDomObject;
import com.taobao.weex.ui.component.WXComponent;
import com.taobao.weex.ui.component.WXComponentProp;
import com.taobao.weex.ui.component.WXVContainer;

import java.util.ArrayList;

/**
 * Created by michael on 2018/4/15.
 */

public class WXLineChartView extends WXComponent {
    public WXLineChartView(WXSDKInstance instance, WXDomObject dom, WXVContainer parent) {
        super(instance, dom, parent);
    }

    private LineChart lineChart;

    @Override
    protected View initComponentHostView(@NonNull Context context) {
        lineChart = new LineChart(context);
        this.setChartPattern();
        return lineChart;
    }

    public void setChartPattern() {
        lineChart.getXAxis().setDrawGridLines(false); // 不绘制网格
        lineChart.getXAxis().setPosition(XAxis.XAxisPosition.BOTTOM);
        lineChart.getXAxis().setAxisLineWidth(0);
        lineChart.getXAxis().setLabelCount(3);
        lineChart.getXAxis().setTextColor(Color.rgb(153, 153, 153));

        lineChart.setDrawGridBackground(false);
        lineChart.setDragEnabled(false);
        lineChart.setScaleEnabled(false);
        lineChart.setPinchZoom(false);

        YAxis yAxis = lineChart.getAxisLeft();
//        yAxis.isDrawBottomYLabelEntryEnabled()
        yAxis.setDrawGridLines(false);
        yAxis.setDrawZeroLine(true);
        yAxis.setAxisLineWidth(0);
        yAxis.setDrawLimitLinesBehindData(true);


        lineChart.getAxisRight().setEnabled(false);

        Description description = new Description();
        description.setText("");
        lineChart.setDescription(description);
    }

    @WXComponentProp(name = "lineData")
    public void setLineData(String lineData) {
        if (!lineData.equals("")) {

            String[] lineDatas = lineData.split("\\|");
            String[] xArr = new String[]{};
            String[] yArr1 = new String[]{};
            String[] yArr2 = new String[]{};
            int index = 0;
            for (String itemS : lineDatas) {
                if (index == 0) {
                    xArr = itemS.split(",");
                } else if (index == 1) {
                    yArr1 = itemS.split(",");
                } else if (index == 2) {
                    yArr2 = itemS.split(",");
                }
                index++;
            }

            // x轴
            if (xArr.length > 0) {
                lineChart.getXAxis().setAxisMaximum(xArr.length - 1);
                final String[] xArrTemp = xArr;
                lineChart.getXAxis().setValueFormatter(new IAxisValueFormatter() {
                    @Override
                    public String getFormattedValue(float value, AxisBase axis) {
                        return xArrTemp[(int)value];
                    }
                });
            }

            //y轴
            ArrayList<Entry> values = new ArrayList<>();
            ArrayList<Entry> values1 = new ArrayList<>();

            for (int i = 0; i < yArr1.length; i++) {
                float y = Float.parseFloat(yArr1[i]);
                values.add(new Entry(i, y));
            }

            for (int i = 0; i < yArr2.length; i++) {
                float y = Float.parseFloat(yArr2[i]);
                values1.add(new Entry(i, y));
            }

            LineDataSet set1;
            LineDataSet set2;

            ArrayList<ILineDataSet> dataSets = new ArrayList<>();

            if (values.size() > 0) {
                set1 = new LineDataSet(values, null);
                set1.setDrawIcons(false);
                set1.setColor(Color.rgb(241, 100, 31));
                set1.setLineWidth(1.0f);
                set1.setDrawCircles(false);
                set1.setDrawValues(false);
                set1.setDrawFilled(true);
                set1.setDrawIcons(true);

                set1.setFillColor(Color.parseColor("#f37b41"));
//                set1.setFillDrawable();

                dataSets.add(set1);
            }

            if (values1.size() > 0) {
                set2 = new LineDataSet(values1, null);
                set2.setDrawIcons(false);
                set2.setColor(Color.rgb(241, 100, 31));
                set2.setLineWidth(1.0f);
                set2.setDrawCircles(false);
                set2.setDrawValues(false);
                set2.setDrawFilled(true);
                set2.setDrawIcons(true);

                set2.setFillColor(Color.parseColor("#FF9C1B"));

                dataSets.add(set2);
            }

            lineChart.setData(new LineData(dataSets));

            lineChart.getData().notifyDataChanged();
            lineChart.notifyDataSetChanged();
            lineChart.invalidate();

        }
    }
}
