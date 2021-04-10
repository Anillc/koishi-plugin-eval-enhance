coffeescript = require 'coffeescript'
{ transformAsync } = require '@babel/core'

jsxPlugins = [
  ['@babel/plugin-transform-react-jsx']
  ['styled-jsx/babel']
  ['@babel/plugin-transform-modules-commonjs']
]

coffee = (code) ->
  return coffeescript.compile "do -> (#{code})", { bare: true }

babel = (code, options)->
  return await transformAsync code, options

module.exports = (code, config) ->
  plugins = [ ...config.babelPlugins, ...jsxPlugins ] if config.jsx
  code = coffee code if config.coffee
  res = await babel code, { plugins }
  return res.code
