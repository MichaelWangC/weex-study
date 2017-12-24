package com.softbi.source.front;

import android.app.Activity;
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

import com.softbi.R;
import com.softbi.config.ConfigInfo;
import com.softbi.core.BaseActivity;
import com.softbi.core.webcore.HybridFragment;
import com.softbi.source.front.entity.TabEntrance;
import com.softbi.source.front.view.MainRadioButtonView;
import com.softbi.source.modules.mine.fragment.MineFragment;
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

    /**
     * 页面渲染
     */
    private void initContentLayout() {
        this.initButtonTab();
        this.initFragmentView();
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

            i++;
        }
    }

    /**
     * 展示页面添加
     */
    private void initFragmentView () {
        pagelist = new ArrayList<>();
        HybridFragment baseFragment = new HybridFragment();
        Bundle bundle = new Bundle();
        String baseUrl = ConfigInfo.getInstance().getVueBaseUrl() + "#/mainPage";
        bundle.putString(HybridFragment.KEY_URL, baseUrl);
        baseFragment.setArguments(bundle);
        pagelist.add(baseFragment);

        MineFragment mineFragment = new MineFragment();
        Bundle mBundle = new Bundle();
        String mineUrl = ConfigInfo.getInstance().getVueBaseUrl() + "#/mineInfo";
        mBundle.putString(HybridFragment.KEY_URL, mineUrl);
        mineFragment.setArguments(mBundle);
        pagelist.add(mineFragment);

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
}
