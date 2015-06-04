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

Item{
    id: root
    focus: true
    width:1280
    height:1024
    property int curSlide: 1;
    property int maxSlide: 3;//Have to manually update for now
    property int fontSize: 32;
    Keys.onRightPressed: if(curSlideLoader.item.stepForward()){
            if(curSlide<maxSlide){
                curSlide++;
                fadePrevAnim.running = true;
            }
        }
    Keys.onLeftPressed: if(curSlideLoader.item.stepBack()){
            if(curSlide>1){
                curSlide--;
                fadeNextAnim.running = true;
            }
        }
        Keys.onPressed:{ if(event.key == Qt.Key_Plus){fontSize += 1;}else if(event.key == Qt.Key_Minus){fontSize -= 1;}}
    Loader{
        id: curSlideLoader
        opacity: 1
        z:1
        source: "slides/Slide" + curSlide + ".qml"
        anchors.fill: parent
    }
    Loader{
        id: prevSlideLoader
        z:2
        opacity: 0
        NumberAnimation on opacity{id:fadePrevAnim; from:1; to:0; duration: 500}
        source: "slides/Slide" + (curSlide-1) + ".qml"
        anchors.fill: parent
    }
    Loader{
        id: nextSlideLoader
        z:2
        opacity: 0
        NumberAnimation on opacity{id:fadeNextAnim; from:1; to:0; duration: 500}
        source: "slides/Slide" + (curSlide+1) + ".qml"
        anchors.fill: parent
    }
}
