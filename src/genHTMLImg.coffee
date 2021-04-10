{ s } = require 'koishi'

sleep = (time) -> new Promise (rev) -> setTimeout rev, time

module.exports = (browser) -> (msg, xpath) ->
  try
    page = await browser.newPage()
    await page.setContent msg
    if xpath
      await page.setViewport
        width: 1920
        height: 1080
      element = await page.waitForXPath xpath,
        visible: true
      img = await element.screenshot
        encoding: 'base64'
    else
      img = await page.screenshot
        fullPage: true
        encoding: 'base64'
  catch e
    return e
  finally
    page.close()
  return s 'image', { file: "base64://#{img}" }
