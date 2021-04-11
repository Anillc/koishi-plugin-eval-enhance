# koishi-plugin-eval-enhance  

koishi-plugin-eval增强  
这个插件提供了coffeescript、typescript、jsx支持

## 使用方法  

本插件依赖于`koishi-plugin-eval`, 如果需要开启jsx支持, 还需要安装`koishi-plugin-puppeteer`  
添加依赖以后想普通插件一样添加到您的koishi中

指令调用: `eeval <script>`  
前缀调用: `^ <script>`  
插值调用: `#{<script>}`  

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
