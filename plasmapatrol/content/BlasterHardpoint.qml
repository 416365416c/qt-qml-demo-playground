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

Item {
    id: container
    property variant target: {"y": -90, "x":12}
    property Item targetObj: container
    property Item hardpoint: container
    property ParticleSystem system
    property int blasts: 16
    property int bonusBlasts: 12
    property bool show: true

    width: 24
    height: 24
    Emitter {
        id: visualization
        group: "blaster"
        system: container.system
        enabled: show
        anchors.fill: parent
        shape: EllipseShape {}
        speed: TargetDirection { targetX: width/2; targetY: width/2; magnitude: -1; proportionalMagnitude: true}
        lifeSpan: 1000
        emitRate: 64 

        size: 24
        sizeVariation: 24
        endSize: 0
    }

    property int blastsLeft: 0
    function fireAt(targetArg, container) {
        target = container.mapFromItem(targetArg, targetArg.width/2, targetArg.height/2);
        targetObj = targetArg;
        hardpoint = container;
        blastsLeft = blasts;
        rofTimer.repeat = true;
        rofTimer.start();
    }
    Timer {
        id: rofTimer
        interval: 30;//Has to be greater than 1 frame or they stack up
        running: false
        repeat: false
        onTriggered: {
            if (targetObj.hp <= 0)
                return;
            //TODO: calculate hit and damage at target, which must be a Ship
            var hit;
            if (blastsLeft >= bonusBlasts)
                hit = Math.random() > targetObj.dodge;
            else
                hit = false; //purely aesthetic shots, because the damage isn't that fine grained
            if (hit == true) {
                switch (targetObj.shipType) {
                case 1: hardpoint.damageDealt += 4; break;
                case 2: hardpoint.damageDealt += 5; break;
                case 3: hardpoint.damageDealt += 1; break;
                default: hardpoint.damageDealt += 100;
                }
            }
            blastVector.targetX = target.x;
            blastVector.targetY = target.y;
            if (!hit) {//TODO: Actual targetVariation
                blastVector.targetX += (128 * Math.random() - 64);
                blastVector.targetY += (128 * Math.random() - 64);
            }
            emitter.burst(1);
            blastsLeft--;
            if (!blastsLeft)
                rofTimer.repeat = false;
        }
    }
    Emitter {
        id: emitter
        group: "blaster"
        enabled: false
        system: container.system
        anchors.centerIn: parent

        lifeSpan: 1000
        emitRate: 16
        maximumEmitted: blasts
        size: 24
        endSize:16
        sizeVariation: 8
        speed: TargetDirection {
            id: blastVector
            targetX: target.x; targetY: target.y; magnitude: 1.1; proportionalMagnitude: true
        }
    }
}
