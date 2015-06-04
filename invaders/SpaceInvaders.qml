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
import QtQuick 2.0
import QtQuick.Particles 2.0
import "invaders.js" as GameLogic

Rectangle{
    color: "black"
    id: root
    width: 360
    height: 640
    Timer{
        interval: 16
        running: true
        repeat: true
        onTriggered: GameLogic.tick();
    }

    Item{
        id: gameArea
        width: 360
        height: 520
    }

    Item{
        id: uiArea
        y: 520
        height: 120
        width: 360
        Rectangle{
            anchors.fill: parent
            anchors.margins: 2
            color: "black"
            border.color: "white"
            border.width: 4
        }
        Button{
            text: "New Game"
            anchors.centerIn: parent
            onClicked: GameLogic.startLevel(gameArea, scoreBox, explosionEmitter);
        }
        Text{
            id: scoreBox
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 6
            color: "white"
            font.pixelSize: 14
            font.bold: true
            text: "000"
        }
    }

    ParticleSystem{id: explosionSys}
    ImageParticle {
        system: explosionSys
        id: cp
        source: "content/particle.png"
        //color: "#00FF7722"
        color: "orange"
        alpha: 0
        colorVariation: 0.4
    }

    Emitter {
        system: explosionSys
        id: explosionEmitter
        emitting: false
        emitRate: 1000
        lifeSpan: 400
	emitCap: 4000
        acceleration: AngledDirection{ angle: 90; angleVariation: 360; magnitude: 240;magnitudeVariation:120 }
        size: 6
        endSize: 8
        sizeVariation: 10
    }
}
