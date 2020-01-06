;window.Matrix = (function(){
    function syncFunc(name, parameters){
        return JSON.parse(prompt('call-' + name, JSON.stringify(parameters)));
    }
    function noReturnFunc(name, parameters){
        return window.webkit.messageHandlers[name].postMessage(parameters);
    }
    return {getInfo:function(){
                        return syncFunc('getInfo');
                    },
            sendMsg:function(data){
                        return noReturnFunc('sendMsg', data);
                    },
            takePhoto:function(data){
                        return noReturnFunc('takePhoto', data);
                    },
            close:function(){
                        return noReturnFunc('close', {'animation':true});
                    },
            user:function(){
                        return syncFunc('user');
                    },
            getUser:function(){
                        return syncFunc('getUser');
                    },
            msgId:function(){
                        return syncFunc('msgId');
                    },
            send:function(data){
                        return noReturnFunc('send',data);
                    },
            log:function(data){
                        return noReturnFunc('log',data);
                    },
            getNetwork:function(){
                        return syncFunc('getNetwork');
                    },
            getPlatform:function(){
                        return syncFunc('getPlatform');
                    },
            getDevice:function(devTid,subDevTid){
                        var data = {devTid:devTid,subDevTid:subDevTid};
                        return syncFunc('getDevice',data);
                    },
            getProtocol:function(devTid){
                        var data = {devTid:devTid};
                        return syncFunc('getProtocol',data);
                    },
            getMsgId:function(){
                        return syncFunc('getMsgId');
                    },
            getControl:function(){
                        return syncFunc('getControl');
                    },
            vibrate:function(data){
                        return noReturnFunc('vibrate',data);
                    },
            setStateBarColor:function(data){
                        return noReturnFunc('setStateBarColor',data);
                    },
            open:function(schameurl){
                        return noReturnFunc('open',{'url':schameurl});
                    },
            getDomain:function(){
                        return syncFunc('getDomain');
                    },
            openPage:function(action ,device){
                        var dict = {action:action,device:device};
                        return noReturnFunc('openPage',dict);
                    },
            screenShot:function(){
                        return noReturnFunc('screenShot');
                    }
            };
})()
