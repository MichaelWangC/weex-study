package com.softbi.core;

import android.content.pm.ActivityInfo;
import android.content.res.ColorStateList;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;

import com.softbi.R;

/**
 * Created by michael on 2017/12/18.
 */

public class BaseNavigtionActivity extends BaseActivity {
    public static class NavButtonItem{
        final String title;
        final int badge;
        public NavButtonItem(String title){
            this(title, 0);
        }
        public NavButtonItem(String title, int badge){
            this.title = title;
            this.badge = badge;
        }

        public String getTitle() {
            return title;
        }

        public int getBadge() {
            return badge;
        }
    }

    @Override
    public void setContentView(int layoutResID) {
        LinearLayout rootView = new LinearLayout(this);
        super.setContentView(rootView);

        rootView.setOrientation(LinearLayout.VERTICAL);
        LayoutInflater inflater = LayoutInflater.from(this);

        View navView = inflater.inflate(R.layout.base_toolbar, null);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,ViewGroup.LayoutParams.WRAP_CONTENT);
        rootView.addView(navView, lp);

        View contentView = inflater.inflate(layoutResID,null);
        lp = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,ViewGroup.LayoutParams.MATCH_PARENT);
        rootView.addView(contentView, lp);

        initTitleView();
    }

    @Override
    public void setContentView(View view) {
        LinearLayout rootView = new LinearLayout(this);
        super.setContentView(rootView);

        rootView.setOrientation(LinearLayout.VERTICAL);
        LayoutInflater inflater = LayoutInflater.from(this);

        View navView = inflater.inflate(R.layout.base_toolbar, null);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,ViewGroup.LayoutParams.WRAP_CONTENT);
        rootView.addView(navView, lp);

        lp = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,ViewGroup.LayoutParams.MATCH_PARENT);
        rootView.addView(view, lp);

        initTitleView();
    }

    private void initTitleView(){
        Toolbar toolbar = pageToolBar();
        if (toolbar!=null) {
            toolbar.setTitle("");
            setSupportActionBar(toolbar);
            getSupportActionBar().setHomeButtonEnabled(true); // 设置返回键可用
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);

            toolbar.setNavigationOnClickListener(new View.OnClickListener() {

                @Override
                public void onClick(View v) {
                    onBackPressed();
                }
            });
        }
    }

    private NavButtonItem[] mNavButtons = null;
    private Toolbar.OnMenuItemClickListener mNavButtonClickListener;
    public void setNavButtons(NavButtonItem[] titles,Toolbar.OnMenuItemClickListener listener){
        this.mNavButtons = titles;
        this.mNavButtonClickListener = listener;
        pageToolBar().setOnMenuItemClickListener(new Toolbar.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(MenuItem item) {
                return false;
            }
        });
//		pageToolBar().setOnMenuItemClickListener(this.mNavButtonClickListener);
        this.invalidateOptionsMenu();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        if (mNavButtons!=null) {
            int[] colors = new int[]{Color.parseColor("#AAFFFFFF"), Color.WHITE};
            int[][] states = new int[2][];
            states[0] = new int[]{android.R.attr.state_pressed};
            states[1] = new int[]{};
            ColorStateList colorList = new ColorStateList(states, colors);

            for (NavButtonItem item:mNavButtons){
                final MenuItem menuItem = menu.add(item.getTitle());
                menuItem.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS);
                Button button = new Button(this);
                ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                button.setLayoutParams(params);
                button.setText(item.getBadge()>0? Html.fromHtml(item.getTitle()+"<font color=#ff5555>("+item.getBadge()+")</font>"):item.getTitle());
                button.setBackgroundColor(Color.alpha(0));
                button.setTextColor(colorList);
                menuItem.setActionView(button);
                button.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        mNavButtonClickListener.onMenuItemClick(menuItem);
                    }
                });
//				menuItem.setOnMenuItemClickListener(this.mNavButtonClickListener);//没起作用
            }
        }
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public void setTitle(CharSequence title) {
        Toolbar toolbar = pageToolBar();
        if (toolbar!=null) {
            toolbar.setTitle(title);
        }
    }

    public void setNavigationHidden(boolean hidden){
        Toolbar toolbar = pageToolBar();
        if (toolbar!=null) {
            toolbar.setVisibility(hidden?View.GONE:View.VISIBLE);
        }
    }

    public Toolbar pageToolBar(){
        return (Toolbar) findViewById(R.id.base_toolbar);
    }
}
