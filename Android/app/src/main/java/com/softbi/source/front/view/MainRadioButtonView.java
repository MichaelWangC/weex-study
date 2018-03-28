package com.softbi.source.front.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.softbi.R;
import com.softbi.source.front.entity.TabEntrance;
import com.softbi.utils.StringUtils;

/**
 * Created by michael on 2017/12/19.
 * tab bar 按钮
 */

public class MainRadioButtonView extends RelativeLayout {

    private TabEntrance tabEntrance;
    private TextView tv_title;//标题
    private ImageView iv_imageView;//图标
    private TextView tv_badgeView;

    private int image_unselected;
    private int image_selected;
    private int color_unselected;
    private int colro_selected;
    private Boolean checked;

    public MainRadioButtonView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        View.inflate(context, R.layout.tabbar_radio_button_view, this);
        tv_title = (TextView) findViewById(R.id.title);
        iv_imageView = (ImageView) findViewById(R.id.image);
        tv_badgeView = (TextView) findViewById(R.id.tv_cicle);
    }
    /**
     * 带有两个参数的构造方法，布局文件使用的时候调用
     *
     * @param context
     * @param attrs
     */
    public MainRadioButtonView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public MainRadioButtonView(Context context) {
        this(context, null);
    }

    /**
     * setter
     */
    public void setUnselected() {
        this.iv_imageView.setImageResource(this.image_unselected);
        this.tv_title.setTextColor(getResources().getColor(this.color_unselected));
    }

    public void setSelected() {
        this.iv_imageView.setImageResource(this.image_selected);
        this.tv_title.setTextColor(getResources().getColor(this.colro_selected));
    }

    public void setBadge(String badgeValue) {
        if (badgeValue.equals("0")) {
            tv_badgeView.setVisibility(View.GONE);
        } else {
            int badgeInt = 0;
            try {
                badgeInt = Integer.parseInt(badgeValue);
                tv_badgeView.setVisibility(View.VISIBLE);
            } catch (NumberFormatException e) {

            } finally {
                if (badgeInt > 99) {
                    tv_badgeView.setText("99+");
                } else {
                    tv_badgeView.setText(badgeValue);
                }
            }
        }
    }

    public Boolean isChecked() {
        return checked;
    }

    public void setChecked(Boolean flag) {
        this.checked = flag;
        if (checked) {
            this.setSelected();
        } else {
            this.setUnselected();
        }
    }

    public void setTabEntrance(TabEntrance tabEntrance) {
        this.tabEntrance = tabEntrance;

        StringUtils.setText(this.tv_title, tabEntrance.title);
        this.image_selected = tabEntrance.image_selected;
        this.image_unselected = tabEntrance.image_unselected;
        this.colro_selected = tabEntrance.color_selected;
        this.color_unselected = tabEntrance.color_unselected;
        this.checked = tabEntrance.checked;
        if (checked) {
            this.setSelected();
        } else {
            this.setUnselected();
        }
    }
}
