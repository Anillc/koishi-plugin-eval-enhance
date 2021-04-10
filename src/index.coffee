{ Session, Argv, s } = require 'koishi'
{ strip } = require 'ansicolor'
{ MainAPI } = require 'koishi-plugin-eval'
path = require 'path'
compile = require './compile'
genImg = require './genHTMLImg'

registerAPIs = (ctx, config) ->
  ctx.before 'eval/start', ->
    MainAPI::genImg = (text, time) -> (genImg ctx.app.browser) text, time
    ctx.app.worker.config.setupFiles['eval-enhance-jsx'] = path.resolve __dirname, 'jsxInj.js' if config.jsx

jsxMiddleware = (prefix) -> (session, next) ->
  if !session.content.startsWith '<'
    return next()
  img = null
  send = session.send
  session.send = (content) -> img = content if (s.from content)?.type == 'image'
  await session.execute "render-eval render (#{session.content})"
  session.send = send
  return next() if !img
  session.send img

evalCommand = (config) -> ({session}, code) ->
  code = s.unescape code
  res = await compile code, config
  return session.execute "evaluate #{res}"

module.exports.name = 'koishi-plugin-eval-enhance'
module.exports = (ctx, config) ->
  config = {
    prefix: '^'
    authority: 2
    coffee: true
    jsx: true
    babelPlugins: []
    ...config
  }

  deps = []
  deps.push 'koishi-plugin-eval'
  deps.push 'koishi-plugin-puppeteer' if config.jsx

  ctx.with deps, ->
    registerAPIs ctx, config
    ctx.middleware jsxMiddleware config.prefix if config.jsx
    ctx.command 'eeval <code:text>', 'Enhanced eval', { authority: config.authority }
      .shortcut config.prefix, { fuzzy: true, greedy: true }
      .action evalCommand config
