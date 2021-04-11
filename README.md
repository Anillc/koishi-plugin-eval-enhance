# koishi-plugin-eval-enhance  

koishi-plugin-eval增强  
这个插件提供了coffeescript、typescript、jsx、styled-jsx支持

## 使用方法  

本插件依赖于`koishi-plugin-eval`, 如果需要开启jsx支持, 还需要安装`koishi-plugin-puppeteer`  
添加依赖以后像普通插件一样添加到您的koishi中  

`yarn add koishi-plugin-eval-enhance`或`npm install koishi-plugin-eval-enhance`  

指令调用: `eeval <script>`  
前缀调用: `^ <script>`  
插值调用: `#{<script>}`  

## jsx  

开启jsx过后将会往eval的worker中添加全局变量render和React，另外styled-jsx也会添加全局变量  
开启jsx之后会注册一个中间件，当权限足够的用户发送有效jsx的时候将会自动将jsx渲染成图片  

## 配置项  

```javascript
{
  prefix: '^',
  authority: 2,
  lang: 'coffeescript', //支持coffeescript、typescript、javascript, 默认为coffeescript
  jsx: true, //开启jsx支持
  babelPlugins: [] //babel
}
```  

## LICENSE  

MIT  
