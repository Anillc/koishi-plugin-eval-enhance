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
  res = await babel code, { plugins }
  return res.code
