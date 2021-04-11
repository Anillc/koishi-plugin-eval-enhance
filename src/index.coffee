{ Session, Argv, s } = require 'koishi'
{ strip } = require 'ansicolor'
{ MainAPI } = require 'koishi-plugin-eval'
path = require 'path'
parse = require './parser'
compile = require './compile'
genImg = require './genHTMLImg'

registerAPIs = (ctx, config) ->
  ctx.before 'eval/start', ->
    MainAPI::genImg = (text, time) -> (genImg ctx.app.browser) text, time
    ctx.app.worker.config.setupFiles['eval-enhance-jsx'] = path.resolve __dirname, 'jsxInj.js' if config.jsx

jsxMiddleware = (prefix) -> (session, next) ->
  if !session.content.startsWith '<'
    return next()
  res = await session.execute "render-eval render (#{session.content})"
  if (s.from res)?.type == 'image'
    session.send res
    return
  return next()

evalCommand = (config) -> ({session}, code) ->
  code = s.unescape code
  res = await compile code, config
  return await session.execute "evaluate #{res}", true

interpolate = (command) -> (input) ->
  source = s.unescape input
  res = parse '{', '}', source
  return { source, command, args: [res.code], rest: s.escape res.rest }

module.exports.name = 'koishi-plugin-eval-enhance'
module.exports = (ctx, config) ->
  config = {
    prefix: '^'
    authority: 2
    lang: 'coffeescript'
    jsx: true
    babelPlugins: []
    ...config
  }

  deps = []
  deps.push 'koishi-plugin-eval'
  deps.push 'koishi-plugin-puppeteer' if config.jsx

  ctx.with deps, -> registerAPIs ctx, config

  ctx.middleware jsxMiddleware config.prefix if config.jsx
  cmd = ctx.command 'eeval <code:text>', 'Enhanced eval', { authority: config.authority }
    .shortcut config.prefix, { fuzzy: true, greedy: true }
    .action evalCommand config
  Argv.interpolate '#{', '}', interpolate cmd
