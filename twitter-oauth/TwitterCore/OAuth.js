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

Qt.include("sha1.js");
var clientKey = "";//Insert your own keys. Apparently we shouldn't be publishing them
var clientSecret = "";

function getValidator(resource, password)
{
    return b64_sha1(resource + password) + "=";
}

function getDigest(validator, timestamp, nonce)
{
    return b64_sha1(nonce + timestamp + validator) + "=";
}

function getTimestamp()
{
    return parseInt((new Date).valueOf() / 1000);
}

function getNonce()
{
    var chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";
    var result = "";
    for (var i = 0; i < 9; ++i) {
        var rnum = Math.floor(Math.random() * chars.length);
        result += chars.substring(rnum, rnum+1);
    }
    return result;
}

function createOAuthHeader(type, url, authParameters, credentials, parameters, body)
{
    var consumer_key =clientKey;
    var consumer_secret =clientSecret;

    var timestamp =  getTimestamp();
    var nonce = getNonce();

    var parameterlist = new Array();
    parameterlist.push( ["oauth_consumer_key", consumer_key] );
    parameterlist.push( ["oauth_nonce", nonce] );
    parameterlist.push( ["oauth_timestamp", timestamp] );
    parameterlist.push( ["oauth_signature_method", "HMAC-SHA1"] );
    parameterlist.push( ["oauth_version", "1.0"] );
    if (credentials)
        parameterlist.push( ["oauth_token", credentials.token] );

    /*
    if (credentials) 
        print("CREDENTIALS " + credentials.token + "," + credentials.secret);
    else
        print("NO CREDENTIALS");
    */

    if (authParameters)
        parameterlist = parameterlist.concat(authParameters);

    if (parameters)
        parameterlist = parameterlist.concat(parameters);

    parameterlist.sort(function(a,b) {
                           if (a[0] < b[0]) return  -1;
                           if (a[0] > b[0]) return 1;
                           if (a[1] < b[1]) return -1;
                           if (a[1] > b[1]) return 1;
                           return 0;
                           });

    var normalized = "";
    if (body) 
        normalized = body + "&";
    for (var ii = 0; ii < parameterlist.length; ++ii) {
        if (ii != 0) normalized += "&";
        normalized += parameterlist[ii][0] + "=" + encodeURIComponent(parameterlist[ii][1]);
    }

    var basestring = type + "&" + encodeURIComponent(url) + "&" + encodeURIComponent(normalized);

    var keystring = encodeURIComponent(consumer_secret) + "&";
    if (credentials)
        keystring += encodeURIComponent(credentials.secret);

    var signature = b64_hmac_sha1(keystring, basestring);

    var authHeader = "OAuth "; 
    authHeader += "oauth_consumer_key=\"" + encodeURIComponent(consumer_key) + "\"";
    authHeader += ", oauth_nonce=\"" + encodeURIComponent(nonce) + "\"";
    authHeader += ", oauth_timestamp=\"" + encodeURIComponent(timestamp) + "\"";
    authHeader += ", oauth_signature=\"" + encodeURIComponent(signature) + "\"";
    authHeader += ", oauth_signature_method=\"HMAC-SHA1\"";
    authHeader += ", oauth_version=\"1.0\"";
    if(authParameters)
        for (var ii = 0; ii < authParameters.length; ii++)
            authHeader += ", " + authParameters[ii][0] + "=\"" + encodeURIComponent(authParameters[ii][1]) + "\"";

    if (credentials) 
        authHeader += ", oauth_token=\"" + encodeURIComponent(credentials.token) + "\"";


    var requrl = url;
    if (parameters) {
        for (var ii = 0; ii < parameters.length; ++ii) {
            if (ii == 0) requrl += "?";
            else requrl += "&";

            requrl += parameters[ii][0] + "=" + encodeURI(parameters[ii][1]);
        }
    }

    var xhr = new XMLHttpRequest;
    xhr.open(type, requrl);
    xhr.setRequestHeader("Authorization", authHeader);

    return xhr;
}
