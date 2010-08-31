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
import QtWebKit 1.0
import "OAuth.js" as OAuthLogic

Item{
    id: root
    width: 1024
    height: 768
    property string username: ''
    property string password: ''
    property string token: ""
    property string secret:""
    function beginAuthentication(){
        step = 1;
        stepOne();
    }
    signal authenticationCompleted;
    //property var credentials: new Object
    property int step: 0
    function nextStep(){
        if(step == 1)
            stepOne();
        else if(step == 2)
            stepTwo();
        else if(step == 3)
            stepThree();
        return;
    }
    function stepOne(){
        var xhr = OAuthLogic.createOAuthHeader("POST", "https://api.twitter.com/oauth/request_token", [["oauth_callback","oob"]]);
        xhr.onreadystatechange = function() { 
            if (xhr.readyState == XMLHttpRequest.DONE) {
                //console.log(xhr.status+'\n'+xhr.getAllResponseHeaders()+'\n'+xhr.responseText+xhr.responseXML);
                var response = xhr.responseText.split('&');
                if(response.length != 3)
                    return;
                token = response[0].split('=')[1];
                secret = response[1].split('=')[1];
                if(response[2].split('=')[1] != 'true')
                    console.log("Error: " + response[2]);
                step = 2;
                webItem.url = "https://api.twitter.com/oauth/authorize?oauth_token="+token;
            }
        }
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.setRequestHeader("Accept-Language", "en");
        xhr.send();
    }
    function stepTwo(){
        step = 3;
        var page = webItem.html;
        //console.log("Step2\n" + page);
        webItem.evaluateJavaScript("document.getElementById(\"username_or_email\").value = \"" + username + "\";");
        webItem.evaluateJavaScript("document.getElementById(\"session\[password\]\").value = \"" + password + "\";");
        webItem.evaluateJavaScript("document.getElementsByTagName(\"input\")[5].click();")
    }
    function stepThree(){
        var pin =  webItem.evaluateJavaScript("document.getElementById(\"oauth_pin\").innerHTML;").replace(/[ \n]*/g, "");
        var xhr = OAuthLogic.createOAuthHeader("POST", "https://api.twitter.com/oauth/access_token", [["oauth_verifier",pin]], {"token":token,"secret":secret});
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE) {
                //console.log('STEP 3\n'+xhr.status+'\n'+xhr.getAllResponseHeaders()+'\n'+xhr.responseText+xhr.responseXML);
                var response = xhr.responseText.split('&');
                if(response.length != 4)
                    return;
                token = response[0].split('=')[1];
                secret = response[1].split('=')[1];
                //username = respones[3].split('=')[1];
                step = 0;
                authorized = true;
                authenticationCompleted();
            }
        }
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.setRequestHeader("Accept-Language", "en");
        xhr.send();
    }
    property bool authorized: false
    WebView{
        id: webItem
        url: "about:blank"
        opacity: 0
        onLoadFinished: nextStep();
        anchors.fill: parent;
    }
}
