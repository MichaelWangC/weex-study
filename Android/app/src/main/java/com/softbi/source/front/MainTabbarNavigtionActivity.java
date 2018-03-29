package com.softbi.source.front;

import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.widget.DrawerLayout;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.softbi.R;
import com.softbi.config.ConfigInfo;
import com.softbi.core.BaseActivity;
import com.softbi.core.weex.WeexBaseFragment;
import com.softbi.source.front.entity.TabEntrance;
import com.softbi.source.front.view.MainRadioButtonView;
import com.softbi.source.widget.NoScrollViewPager;

import java.util.ArrayList;
import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by michael on 2017/12/18.
 * tabbar app主页
 */

public class MainTabbarNavigtionActivity extends BaseActivity{
    @Bind(R.id.viewpager_content)
    NoScrollViewPager viewPager;
    @Bind(R.id.drawer_layout)
    DrawerLayout drawer;
    @Bind(R.id.tab_bottom)
    LinearLayout tabBottom;

    private static MainRadioButtonView mineTabbarItem;
    protected ArrayList<Fragment> pagelist;
    private PageAdapter pageAdapter;
    private List<MainRadioButtonView> radios = new ArrayList<>();
    private int curIndex = 0;

    class PageAdapter extends FragmentPagerAdapter {
        public PageAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public Fragment getItem(int position) {
            return pagelist.get(position);
        }

        @Override
        public int getCount() {
            return pagelist.size();
        }
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        setContentView(R.layout.main_tabbar);
        ButterKnife.bind(this);

        this.initContentLayout();
    }

    public static void setMineTabbarbadge(String badgeValue) {
        mineTabbarItem.setBadge(badgeValue);
    }

    /**
     * 页面渲染
     */
    private void initContentLayout() {
        this.initButtonTab();
        this.initFragmentView();
//        viewPager.setCurrentItem(1, false);
    }

    /**
     * tab 按钮生成
     */
    private void initButtonTab() {
        List<TabEntrance> tabEntrances = new ArrayList<>();
        // 首页
        TabEntrance tabEntrance = new TabEntrance();
        tabEntrance.title = "首页";
        tabEntrance.image_selected = R.drawable.icon_tabbar_home_selected;
        tabEntrance.image_unselected = R.drawable.icon_tabbar_home_unselected;
        tabEntrance.color_selected = R.color.tab_btn_selected;
        tabEntrance.color_unselected = R.color.tab_btn_unselected;
        tabEntrance.checked = true;
        tabEntrances.add(tabEntrance);

        tabEntrance = new TabEntrance();
        tabEntrance.title = "看看";
        tabEntrance.image_selected = R.drawable.icon_tabbar_look_selected;
        tabEntrance.image_unselected = R.drawable.icon_tabbar_look_unselected;
        tabEntrance.color_selected = R.color.tab_btn_selected;
        tabEntrance.color_unselected = R.color.tab_btn_unselected;
        tabEntrances.add(tabEntrance);

        tabEntrance = new TabEntrance();
        tabEntrance.title = "客户";
        tabEntrance.image_selected = R.drawable.icon_tabbar_notifica_selected;
        tabEntrance.image_unselected = R.drawable.icon_tabbar_notifica_unselected;
        tabEntrance.color_selected = R.color.tab_btn_selected;
        tabEntrance.color_unselected = R.color.tab_btn_unselected;
        tabEntrances.add(tabEntrance);

        // 我的
        tabEntrance = new TabEntrance();
        tabEntrance.title = "我的";
        tabEntrance.image_selected = R.drawable.icon_tabbar_mine_selected;
        tabEntrance.image_unselected = R.drawable.icon_tabbar_mine_unselected;
        tabEntrance.color_selected = R.color.tab_btn_selected;
        tabEntrance.color_unselected = R.color.tab_btn_unselected;
        tabEntrances.add(tabEntrance);

        int i = 0;
        for (TabEntrance tabE : tabEntrances) {
            MainRadioButtonView mainRadioButtonView = new MainRadioButtonView(this.getApplicationContext());
            mainRadioButtonView.setTabEntrance(tabE);
            radios.add(mainRadioButtonView);
            tabBottom.addView(mainRadioButtonView);

            LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) mainRadioButtonView.getLayoutParams();
            params.weight = 1;
            params.width = 0;
            mainRadioButtonView.setLayoutParams(params);

            final int flag = i;
            mainRadioButtonView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    viewPager.setCurrentItem(flag, false);
                }
            });

            if (tabE.title.equals("我的")) {
                mineTabbarItem = mainRadioButtonView;
            }

            i++;
        }
    }

    /**
     * 展示页面添加
     */
    private void initFragmentView () {
        pagelist = new ArrayList<>();

        WeexBaseFragment baseFragment = new WeexBaseFragment();
        String baseUrl = ConfigInfo.getInstance().getWeexRootUrl() + "modules/home/home.js";
        baseFragment.setUrl(baseUrl);
        baseFragment.setTitle("");
        baseFragment.setShowBackBtn(false);
        baseFragment.setHiddenNavBar(false);
        baseFragment.setNavBarIsClear(true);
        pagelist.add(baseFragment);

        baseFragment = new WeexBaseFragment();
        String financialUrl = ConfigInfo.getInstance().getWeexRootUrl() + "modules/financial/financial.js";
        baseFragment.setUrl(financialUrl);
        baseFragment.setTitle("看看");
        baseFragment.setShowBackBtn(false);
        baseFragment.setHiddenNavBar(false);
        pagelist.add(baseFragment);

        baseFragment = new WeexBaseFragment();
        String custUrl = ConfigInfo.getInstance().getWeexRootUrl() + "modules/customer/customer.js";
        baseFragment.setUrl(custUrl);
        baseFragment.setTitle("客户");
        baseFragment.setShowBackBtn(false);
        baseFragment.setHiddenNavBar(true);
        pagelist.add(baseFragment);

        WeexBaseFragment mineFragment = new WeexBaseFragment();
        String mineUrl = ConfigInfo.getInstance().getWeexRootUrl() + "modules/mine/mine.js";
        mineFragment.setUrl(mineUrl);
        mineFragment.setShowBackBtn(false);
        mineFragment.setNavBarIsClear(true);
        pagelist.add(mineFragment);

//        MineFragment mineFragment = new MineFragment();
//        pagelist.add(mineFragment);

        pageAdapter = new PageAdapter(getSupportFragmentManager());
        viewPager.setAdapter(pageAdapter);
        viewPager.setOffscreenPageLimit(pagelist.size());
        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                if (curIndex == position) return;
                curIndex = position;
                changeBtn(curIndex);
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });

    }

    private void changeBtn(int index) {
        for (int i = 0; i < radios.size(); i++) {
            if (i == index) {
                radios.get(i).setChecked(true);
            } else {
                radios.get(i).setChecked(false);
            }
        }
    }

    /**
     * getter setter
     */
    public ArrayList<Fragment> getPagelist() {
        return pagelist;
    }
}
