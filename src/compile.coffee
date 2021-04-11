coffeescript = require 'coffeescript'
{ transformSync } = require '@babel/core'

jsxPlugins = [
  ['@babel/plugin-transform-react-jsx']
  ['styled-jsx/babel']
  ['@babel/plugin-transform-modules-commonjs']
]

coffee = (code) ->
  return coffeescript.compile "do -> (#{code})", { bare: true }

babel = (code, options)->
  return transformSync code, options

module.exports = (code, config) ->
  plugins = [...config.babelPlugins]
  switch config.lang
    when 'coffeescript'
      code = coffee code
    when 'typescript'
      plugins.push '@babel/plugin-transform-typescript'
    when 'javascript'
      # do noting
    else throw 'Unsupported language'
  plugins = [...plugins, ...jsxPlugins] if config.jsx
  res = babel code, { plugins }
  return res.code
