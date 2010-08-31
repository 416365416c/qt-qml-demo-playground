/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the QtDeclarative module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions
** contained in the Technology Preview License Agreement accompanying
** this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights.  These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
**
**
**
**
**
**
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
