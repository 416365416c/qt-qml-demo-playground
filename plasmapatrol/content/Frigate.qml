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
    property int maxHP: 100
    property int hp: maxHP
    property real initialDodge: 0.2
    property real dodge: initialDodge
    onHpChanged: if(hp <= 0) target = container;
    property ParticleSystem system//TODO: Ship abstraction
    property Item target: container
    property string shipParticle: "default"//Per team colors?
    property int gunType: 0
    width: 128
    height: 128
    Emitter {
        system: container.system
        group: "frigateShield"
        anchors.centerIn: parent
        size: 92
        emitRate: 1
        lifeSpan: 4800
        enabled: hp > 0
    }
    Emitter {
        system: container.system
        group: container.shipParticle
        anchors.centerIn: parent
        width: 64 
        height: 16
        shape: EllipseShape {}

        size: 16
        sizeVariation: 8
        endSize: 8
        emitRate: hp > 0 ?  hp * 1 + 20 : 0 
        lifeSpan: 1200
        maximumEmitted: (maxHP * 1 + 20)*2
    }
    Timer {
        id: fireControl
        property int next: Math.floor(Math.random() * 2) + 1
        interval: 800
        running: root.readySetGo
        repeat: true
        onTriggered: {
            if (next == 1) {
                gun1.fireAt(container.target);
                next = Math.floor(Math.random() * 2) + 1;
            } else if (next == 2) {
                gun2.fireAt(container.target);
                next = Math.floor(Math.random() * 2) + 1;
            }
        }
    }

    Hardpoint {
        x: 128 - 32 - 12
        y: 64 - 12
        id: gun1
        system: container.system
        show: hp > 0
        hardpointType: gunType
    }
    Hardpoint {
        x: 0 + 32 - 12
        y: 64 - 12
        id: gun2
        system: container.system
        show: hp > 0
        hardpointType: gunType
    }
}
