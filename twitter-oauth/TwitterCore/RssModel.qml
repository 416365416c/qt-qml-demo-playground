/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import Qt 4.7
import "OAuth.js" as OAuthLogic

Item { id: wrapper
    property variant model: xmlModel
    property string tags : ""
    //property string authName : ""
    //property string authPass : ""
       property string credentials: ""
       property string mode : "everyone"
    property int status: xmlModel.status
    function reload() {
        var url = '';
        if(mode == 'self')
            url = 'http://api.twitter.com/1/statuses/home_timeline.xml'
        else if(mode == 'user')
            url = 'http://api.twitter.com/1/statuses/user_timeline.xml?screen_name='+tags
        else
            url = 'http://api.twitter.com/1/statuses/public_timeline.xml'
        var xhr;
        if(oauth.authorized){
            xhr = OAuthLogic.createOAuthHeader("GET", url, undefined, {"token":oauth.token, "secret":oauth.secret});
        }else{
            xhr = new XMLHttpRequest;
            xhr.open("GET", url);
        }
        xhr.onreadystatechange = function() { 
            if (xhr.readyState == XMLHttpRequest.DONE) {
                xmlModel.xml = xhr.responseText;
            }
        }
        xhr.send();
    }
XmlListModel {
    id: xmlModel

    query: "/statuses/status"

    XmlRole { name: "statusText"; query: "text/string()" }
    XmlRole { name: "timestamp"; query: "created_at/string()" }
    XmlRole { name: "source"; query: "source/string()" }
    XmlRole { name: "userName"; query: "user/name/string()" }
    XmlRole { name: "userScreenName"; query: "user/screen_name/string()" }
    XmlRole { name: "userImage"; query: "user/profile_image_url/string()" }
    XmlRole { name: "userLocation"; query: "user/location/string()" }
    XmlRole { name: "userDescription"; query: "user/description/string()" }
    XmlRole { name: "userFollowers"; query: "user/followers_count/string()" }
    XmlRole { name: "userStatuses"; query: "user/statuses_count/string()" }
    //TODO: Could also get the user's color scheme, timezone and a few other things
}
Binding {
    property: "mode"
    target: wrapper
    value: {if(wrapper.tags==''){"everyone";}else if(wrapper.tags=='my timeline'){"self";}else{"user";}}
}
}
