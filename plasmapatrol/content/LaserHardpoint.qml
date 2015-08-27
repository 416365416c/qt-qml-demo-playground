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
    property ParticleSystem system
    property bool show: true

    width: 24
    height: 24
    Emitter {
        id: visualization
        group: "laser"
        system: container.system
        anchors.fill: parent
        enabled: container.show
        shape: EllipseShape {}
        velocity: TargetDirection { targetX: width/2; targetY: width/2; magnitude: -1; proportionalMagnitude: true }
        lifeSpan: 1000
        emitRate: 64

        size: 24
        sizeVariation: 8
        endSize: 8
    }

    function fireAt(targetArg, hardpoint) {
        if (targetArg.hp <= 0)
            return;
        //TODO: calculate hit and damage at target, which must be a Ship
        var offset = 0;
        if (Math.random() < 0.99) {
            switch (targetArg.shipType) {
            case 1: hardpoint.damageDealt += 16; break;
            case 2: hardpoint.damageDealt += 4; break;
            case 3: hardpoint.damageDealt += 8; break;
            default: hardpoint.damageDealt += 500; //Really effective against unregistered vessels
            }
        } else {//Misses with Lasers are really rare
            offset = Math.random() * 100;
        }
        target = container.mapFromItem(targetArg, offset + targetArg.width/2, offset + targetArg.height/2);
        emitter.pulse(100);
 //       console.log("Fire box: " +  Math.min(container.width/2, target.x) + "," + Math.min(container.height/2, target.y) + " " + (Math.max(container.width/2, target.x) - Math.min(container.width/2, target.x)) + "," + (Math.max(container.height/2, target.y) - Math.min(container.height/2, target.y)));
    }
    Emitter {
        id: emitter
        group: "laser"
        enabled: false
        system: container.system
        x: Math.min(container.width/2, target.x);
        width: Math.max(container.width/2, target.x) - x;
        y: Math.min(container.height/2, target.y);
        height: Math.max(container.height/2, target.y) - y;
        shape: LineShape {
            mirrored: (emitter.y < 0 || emitter.x < 0) && !(emitter.y < 0 && emitter.x < 0 )//I just want XOR
        }

        lifeSpan: 1000
        emitRate: 8000
        maximumEmitted: 800
        size: 16
        endSize: 0

        velocity: PointDirection {xVariation: 4; yVariation: 4}
    }
}
