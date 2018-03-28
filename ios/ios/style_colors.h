//
//  style_colors.h
//  ios
//
//  Created by Michael on 2017/12/13.
//  Copyright © 2017年 weexstudy. All rights reserved.
//

#ifndef style_colors_h
#define style_colors_h

#define UIColorFromHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]

#define FONT_SIZE_outsize 22//超大
#define FONT_SIZE_superlarge 20//特大
#define FONT_SIZE_large 18//大
#define FONT_SIZE_normal 16//正常
#define FONT_SIZE_small 14//小
#define FONT_SIZE_supersmall 12//特小
#define FONT_SIZE_little 12//超小

// color
#define COLOR_THEME [UIColor colorWithRed:0x52/255.0 green:0x91/255.0 blue:0xff/255.0 alpha:1]
#define COLOR_COMMON_BACKGROUND [UIColor colorWithRed:0xf6/255.0 green:0xf6/255.0 blue:0xf6/255.0 alpha:1]

#define COLOR_TEXT_DEFAULT [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1]

#endif /* style_colors_h */
