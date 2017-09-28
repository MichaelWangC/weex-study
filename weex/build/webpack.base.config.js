var path = require('path')
var webpack = require('webpack')
var merge = require('webpack-merge')
var CleanWebpackPlugin = require('clean-webpack-plugin')
var vueLoaderConfig = require('./vue-loader.config.js')
var config = require('../config')

var baseConfig = {
  module: {
    rules: [{
      test: /\.vue$/
    }, {
      test: /\.js$/,
      loader: 'babel-loader',
      exclude: /node_modules/
    }]
  },
  plugins: [
    
  ]
}

var webConfig = merge(baseConfig, {
  entry: {
    app: config.build.entryPath.web,
  },
  output: {
    path: config.build.publicWebRoot,
    // path: resolve('public/dist/web/'),
    publicPath: config.build.publicWebPath,
    // publicPath: '/dist/web/'
    filename: '[name].js'
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
  entry: {
    app: config.build.entryPath.native,
  },
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
