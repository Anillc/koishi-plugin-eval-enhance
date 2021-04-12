{ parentPort } = require 'worker_threads'
{ internal } = require 'koishi-plugin-eval/lib/worker'
{ wrap } = require 'koishi-plugin-eval/lib/transfer'

React = require 'react'
ReactDOMServer = require 'react-dom/server'
styled = require 'styled-jsx/style'
{ flushToHTML } = require 'styled-jsx/server'

styledJsxRequire = (name) ->
  switch name
    when 'styled-jsx/style' then styled
    else throw 'Unexpected requiring'

main = wrap parentPort

render = (dom, scale = 8) ->
  return if !React.isValidElement dom
  body = ReactDOMServer.renderToStaticMarkup dom
  style = flushToHTML()
  html = """<!doctype html>
            <html>
            <head>
            <style>
            #root {
              float: left;
              transform: scale(#{scale}) translate(50%, 50%);
            }
            </style>
            #{style}
            </head>
            <body><div id="root">#{body}</div></body>
            </html>"""
  return await main.genImg html, '//*[@id="root"]'

internal.setGlobal 'React', React, false
internal.setGlobal 'require', styledJsxRequire, false
internal.setGlobal 'render', render, false
