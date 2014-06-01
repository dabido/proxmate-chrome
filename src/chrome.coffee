class Chrome
  init: ->

  storage:
    local:
      set: chrome.storage.local.set
      get: chrome.storage.local.get
      remove: chrome.storage.local.remove

  proxy:
    settings:
      set: chrome.proxy.settings.set
      clear: chrome.proxy.settings.clear

  runtime:
    onMessage:
      addListener: chrome.runtime.onMessage.addListener

  browserAction:
    setBadgeText: chrome.browserAction.setBadgeText
    setIcon: chrome.browserAction.setIcon


if chrome.app
  exports.Chrome = chrome
else
  exports.Chrome = new Chrome()
