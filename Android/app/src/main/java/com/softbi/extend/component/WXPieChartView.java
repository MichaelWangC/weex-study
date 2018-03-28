package com.softbi.extend.component;

import android.content.Context;
import android.graphics.Color;
import android.support.annotation.NonNull;
import android.view.View;

import com.github.mikephil.charting.charts.PieChart;
import com.github.mikephil.charting.components.Description;
import com.github.mikephil.charting.data.PieData;
import com.github.mikephil.charting.data.PieDataSet;
import com.github.mikephil.charting.data.PieEntry;
import com.github.mikephil.charting.utils.ColorTemplate;
import com.taobao.weex.WXSDKInstance;
import com.taobao.weex.dom.WXDomObject;
import com.taobao.weex.ui.component.WXComponent;
import com.taobao.weex.ui.component.WXComponentProp;
import com.taobao.weex.ui.component.WXVContainer;

import java.util.ArrayList;

/**
 * Created by michael on 2018/1/15.
 */

public class WXPieChartView extends WXComponent {

    public WXPieChartView(WXSDKInstance instance, WXDomObject dom, WXVContainer parent) {
        super(instance, dom, parent);
    }

    private PieChart pieChart;

    @Override
    protected View initComponentHostView(@NonNull Context context) {
        pieChart = new PieChart(context);
//        pieChart.setBackgroundColor(Color.BLUE);
//        pieChart.setHoleRadius(0.6f);
//        pieChart.setDrawHoleEnabled(true);
        pieChart.getLegend().setEnabled(false); // 不展示legend

        Description description = new Description();
        description.setText("");
        pieChart.setDescription(description);
        return pieChart;
    }

    @WXComponentProp(name = "pieData")
    public void setPieData(String pieData) {

        if (!pieData.equals("")) {
            String[] pieDatas = pieData.split(",");
            ArrayList<PieEntry> pieEntryList = new ArrayList<PieEntry>();
            ArrayList<Integer> colors = new ArrayList<Integer>();

            colors.add(Color.rgb(32, 134, 253));
            colors.add(Color.rgb(220, 181, 1));
            colors.add(Color.rgb(255, 156, 27));
            colors.add(Color.rgb(0, 187, 106));
            for (int color : ColorTemplate.PASTEL_COLORS) {
                colors.add(Integer.valueOf(color));
            }
            colors.add(Color.rgb(51, 181, 229));

            for (String data: pieDatas) {
                String[] values = data.split("\\|");
                String value = values[1];
                Integer valueInt = (int) Float.parseFloat(value);
                PieEntry pieEntry = new PieEntry(valueInt, "");
                pieEntryList.add(pieEntry);
            }

            PieDataSet pieDataSet = new PieDataSet(pieEntryList, "Election Results");
            pieDataSet.setColors(colors);
            pieDataSet.setSliceSpace(0);
            pieDataSet.setValueLineWidth(0);
            pieDataSet.setDrawValues(false);

            PieData pieData1 = new PieData(pieDataSet);
            pieChart.setData(pieData1);
            pieChart.highlightValues(null);
            pieChart.invalidate();
        }
    }
}
