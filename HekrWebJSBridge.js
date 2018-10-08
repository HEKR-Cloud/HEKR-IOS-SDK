;window.Matrix = (function () {
                  function noReturnFunc(name, parameters) {
                  return window.__HEKR__BRIDGE.__voidCall(JSON.stringify({name, parameters}));
                  };
                  function syncFunc(name, parameters) {
                  return JSON.parse(window.__HEKR__BRIDGE.__syncCall(JSON.stringify({name, parameters})));
                  };
                  setTimeout(function() {
                             window.addEventListener('error', function(event) {
                                                     console.log('onerror:',event);
                                                     var url = location.href || '';
                                                     var ua = navigator.userAgent || '';
                                                     var message = (event.error && event.error.message) || '';
                                                     var error = {error:message,lineno:event.lineno,filename:event.filename,message:event.message};
                                                     noReturnFunc('errorLog',{error:error,url:url,ua:ua});
                                                     }
                                                     );
                             }, 0);
                  return {
                  getInfo: function () {
                  return syncFunc('getInfo');
                  },
                  sendMsg: function (data) {
                  return noReturnFunc('send', {command:data});
                  },
                  takePhoto: function (data) {
                  return noReturnFunc('takePhoto', data);
                  },
                  close: function () {
                  return noReturnFunc('close', { 'animation': true });
                  },
                  user: function () {
                  return syncFunc('user');
                  },
                  getUser: function () {
                  return syncFunc('user');
                  },
                  msgId: function () {
                  return syncFunc('getMsgId');
                  },
                  send: function (data, raw) {
                  return noReturnFunc('send', {command:data, raw:!!raw});
                  },
                  log: function (data) {
                  return noReturnFunc('log', data);
                  },
                  getNetwork: function () {
                  return syncFunc('getNetwork');
                  },
                  getPlatform: function () {
                  return syncFunc('getPlatform');
                  },
                  getDevice: function (devTid, subDevTid) {
                  var data = { devTid: devTid, subDevTid: subDevTid };
                  return syncFunc('getDevice', data);
                  },
                  getProtocol: function (devTid) {
                  var data = { devTid: devTid };
                  return syncFunc('getProtocol', data);
                  },
                  getMsgId: function () {
                  return syncFunc('getMsgId');
                  },
                  getControl: function () {
                  return syncFunc('getControl');
                  },
                  vibrate: function (data) {
                  return noReturnFunc('vibrate', data);
                  },
                  setStateBarColor: function (data) {
                  return noReturnFunc('setStateBarColor', data);
                  },
                  open: function (schameurl) {
                  return noReturnFunc('open', { 'url': schameurl });
                  },
                  getDomain: function () {
                  return syncFunc('getDomain');
                  },
                  openPage: function (action, device) {
                  var dict = { action: action, device: device };
                  return noReturnFunc('openPage', dict);
                  },
                  screenShot: function () {
                  return noReturnFunc('screenShot');
                  },
                  reloadGroup: function () {
                  return noReturnFunc('reloadGroup');
                  },
                  openURL: function (url) {
                  return noReturnFunc('open', { 'url': url });
                  },
                  };
                  })()
;(function () {
  var init = function () {
  if (window.Hekr || !window.Matrix) { return }
  var Matrix = window.Matrix;
  var Hekr = new Object();
  var EventsQueue = new Object();
  EventsQueue.onEvent = function (event) {
  if (event.type === 'recv' || event.type === 'notifyDevEvent') {
  function toJSON(str) {
  try {
  var obj = JSON.parse(str);
  return obj;
  } catch (e) {
  return str;
  }
  }
  var msg = toJSON(event.detail);
  var arr = EventsQueue.handles;
  if (arr) {
  for (var i = EventsQueue.handles.length - 1; i >= 0; i--) {
  var item = EventsQueue.handles[i];
  if (EventsQueue.match(item.filter, msg)) {
  item.callback(msg);
  if (Number(item.timeout) > 0) {
  arr.splice(i, 1);
  }
  }
  }
  EventsQueue.handles = arr;
  }
  }
  };
  EventsQueue.onTimer = function (argument) {      /* body... */
  var arr = EventsQueue.handles;
  if (arr) {
  for (var i = EventsQueue.handles.length - 1; i >= 0; i--) {
  var item = EventsQueue.handles[i];
  if (Number(item.timeout) > 0 && Number(item.timeout) - Date.now() <= 0) {
  arr.splice(i, 1);
  item.callback({}, { error: "timeout" });
  }
  }
  EventsQueue.handles = arr;
  }
  setTimeout(EventsQueue.onTimer, 1000);
  };
  EventsQueue.match = function (filter, msg) {
  function match(filter, msg) {
  if (!filter || !msg) return false;
  for (var key in filter) {
  if (filter.hasOwnProperty(key)) {
  var v1 = filter[key];
  if (null === v1) {
  if (!msg.hasOwnProperty(key)) return false;
  } else if (typeof v1 === 'object') {
  if (!match(v1, msg[key])) return false;
  } else {
  if (v1 !== msg[key]) return false;
  }
  }
  }
  return true;
  }
  return match(filter, msg);
  };
  EventsQueue.addMSGFilter = function (filter, timeout, callback) {
  EventsQueue.handles = EventsQueue.handles || [];
  EventsQueue.handles.push({ filter: filter, timeout: timeout > 0 ? (Date.now() + timeout * 1000) : null, callback: callback });
  };
  
  Hekr.plantform = Matrix.getPlatform();
  /*
   // messageHandels:{},
   // configHandle:_defaultConfigSearchHandle,
   // userHandel:_defaultUserHandel,
   // netChangeHandel:_defaultNetHandle,
   // notifyHandel:_defaultNotifyHandel,
   */
  Hekr.send = function (command, devTid, callback, raw) {
  if (!raw) {
  var msgId = Matrix.msgId();
  command.msgId = Number(msgId);
  }
  Matrix.send(command, raw);
  
  if (command.action === 'appSend') {
  EventsQueue.addMSGFilter({ msgId: msgId, action: 'appSendResp' }, 10, function (obj, err) {
                           callback && callback(obj, err);
                           });
  }
  };
  Hekr.recv = function (filter, callback) {
  /*
   // Matrix.recv({'filter':filter});
   // Matrix.log(filter);
   */
  EventsQueue.addMSGFilter(filter, -1, function (obj, err) {
                           callback && callback(obj, err);
                           });
  };
  Hekr.msgId = function (callback) {
  var msgId = Matrix.msgId();
  callback && callback(msgId);
  };
  /*
   // configSearch:_configSearch,
   // cancelConfigSearch:_cancelConfigSearch,
   */
  Hekr.currentUser = function (callback) {
  setTimeout(function (user) { callback && callback(user) }, 0, Matrix.user());
  };
  /*
   // login:_login,
   // logout:_logout,
   */
  Hekr.setUserHandle = function (callback) {
  EventsQueue.addEventHandle('user', function (user) {
                             callback && callback(user);
                             });
  };
  Hekr.close = function (animation) {
  Matrix.close({ 'animation': true });
  };
  Hekr.closeAll = Hekr.close;
  /*
   // currentSSID:_currentSSID,
   */
  Hekr.open = function (schameurl) {
  Matrix.open(schameurl);
  };
  /*
   // QRScan:_QRScan,
   // backTo:_backTo,
   */
  Hekr.saveConfig = function (conf) {
  Matrix.putData(conf);
  };
  Hekr.getConfig = function (callback) {
  setTimeout(function (conf) { callback && callback(conf) }, 0, Matrix.getData());
  };
  /*
   // setNotifyHandel:_setNotifyHandel,
   // notify:_notify,
   // takePhoto:_takePhoto,
   */
  Hekr.setNetHandle = function (callback) {
  EventsQueue.addEventHandle('net', function (net) {
                             callback && callback(net);
                             });
  };
  Hekr.playSound = function (name) {
  };
  /*
   // mscControl:_mscControl,
   // share:_share,
   // touchIDAuth:_touchIDAuth,
   */
  var slog = console.log;
  var elog = console.error;
  Hekr.logOn = function () {
  var log = function (a, b, c, d, e, f, g, h, i, j, k, l, m, n) {
  var arr = [a, b, c, d, e, f, g, h, i, j, k, l, m, n].filter(function (item) { return !!item });
  Matrix.log(arr);
  };
  console.log = log;
  console.error = log;
  };
  Hekr.logOff = function () {
  console.log = slog;
  console.error = elog;
  };
  (function () {
   window.Hekr = Hekr;
   window.close = Hekr.close;
   ['notifyDevEvent', 'recv'].map(function (i) {
                                  document.addEventListener(i, EventsQueue.onEvent);
                                  });
   EventsQueue.onTimer();
   var readyEvent = document.createEvent('Events');
   readyEvent.initEvent('HekrSDKReady');
   document.dispatchEvent(readyEvent);
   console.log('hekr');
   })();
  };
  (function(func){
   if (document.readyState === 'complete'){
   func();
   }else{
   document.addEventListener('DOMContentLoaded', func);
   }
   })(init);
  })();
