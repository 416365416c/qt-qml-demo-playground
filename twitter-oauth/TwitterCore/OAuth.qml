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
