var pathTo = require('path')
var webpack = require('webpack')
var merge = require('webpack-merge')
var CleanWebpackPlugin = require('clean-webpack-plugin')
var vueLoaderConfig = require('./vue-loader.config.js')
var config = require('../config')

/// 入口文件配置
const entry = {};
const weexEntry = {};
const vueWebTemp = 'entrys';
const fs = require('fs-extra')
// const hasPluginInstalled = fs.existsSync('./web/plugin.js')
var resolve = require('../build/utils').resolve
// var isWin = /^win/.test(process.platform);

// 获取入口文件 配置
function walk(dir) {
  dir = dir || '.';
  const directory = pathTo.join(resolve('src'), dir); // /src,/src/components
  fs.readdirSync(directory).forEach(function(file) {

    const fullpath = pathTo.join(directory, file); // /src/App.vue,/src/components,/src/components/Hello.vue
    const stat = fs.statSync(fullpath);
    const extname = pathTo.extname(fullpath);
    if (stat.isFile() && extname === '.vue') {
      /// 生成入口文件
      const name = pathTo.join(dir, pathTo.basename(file, extname)); // App Hello
      // 生成对饮vue的 js入口文件 放入temp文件夹中
      // const entryFile = pathTo.join(vueWebTemp, dir, pathTo.basename(file, extname) + '.js'); // temp/App.js temp/components/Hello.js
      // fs.outputFileSync(pathTo.join(entryFile), getEntryFileContent(entryFile, fullpath));
      // entry[name] = pathTo.join(resolve(vueWebTemp), dir, pathTo.basename(file, extname) + '.js') + '?entry=true';

      weexEntry[name] = fullpath + '?entry=true';

    } else if (stat.isDirectory() && file !== 'components' && file !== 'images') {
      const subdir = pathTo.join(dir, file);
      walk(subdir);
    }

  }, this);
}
walk();

// console.log('weexEntry:' + JSON.stringify(weexEntry))
// 基本配置
var baseConfig = {
  module: {
    rules: [{
      test: /\.vue$/
    }, {
      test: /\.js$/,
      loader: 'babel-loader',
      exclude: /node_modules/
    }, {
      test: /\.(png|jpe?g|gif|svg)(\?.*)?$/,
      loader: 'url-loader',
      query: {
        name: '[name].[ext]?[hash]'
      }
    }]
  },
  plugins: [
    
  ],
  resolve: {
    alias: {
      '@': resolve('src'),
    },
    modules: [
      resolve('src'),
      resolve('node_modules')
    ]
  }
}

var webConfig = merge(baseConfig, {
  entry: {
    index: config.build.entryPath.web
  },
  output: {
    path: config.build.publicWebRoot,
    // path: resolve('public/dist/web/'),
    publicPath: config.build.publicWebPath,
    // publicPath: '/dist/web/'
    filename: '[name].js'
  },
  resolve: {
    extensions: ['.js', '.vue', '.json'],
    alias: {
      'vue$': 'vue/dist/vue.esm.js',
      '@': resolve('src'),
    }
  },
  module: {
    rules: [{
      test: /\.vue$/,
      loader: 'vue-loader',
      options: vueLoaderConfig
    }],
  }
})

var nativeConfig = merge(baseConfig, {
  entry: weexEntry,
  output: {
    path: config.build.publicDistRoot,
    // path: resolve('public/dist/weex/'),
    publicPath: config.build.publicPath,
    // publicPath: '/dist/weex/'
    filename: '[name].js'
  },
  module: {
    rules: [{
      test: /\.vue$/,
      loader: 'weex-loader'
    }],
  },
  plugins: [
    new webpack.BannerPlugin({
      banner: '// { "framework": "Vue" } \n',
      raw: true,
      exclude: 'Vue'
    })
  ]
})

module.exports = [webConfig, nativeConfig]
