var path = require('path')
var resolve = require('../build/utils').resolve

module.exports = {
  build: {
    env: require('./prod.env'),
    entryPath: {
      web: resolve('src/web.entry.js')
    },
    index: resolve('public/index.html'),
    publicDistRoot: resolve('public/dist/weex'),
    publicPath: '/dist/weex/',
    publicWebRoot: resolve('public/dist/web'),
    publicWebPath: '/dist/web/',
    publicRoot: resolve('public'),
    productionSourceMap: true,
  },
  dev: {
    env: require('./dev.env'),
    clientPath: resolve('build/dev-client.js'),
    port: 8081,
    autoOpenBrowser: true,
    assetsSubDirectory: 'static',
    publicPath: '/dist/',
    proxyTable: {}
  }
}
