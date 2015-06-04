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
    //ReflectiveProperties
    //TransferredProperties
    property variant target: {"y": -90, "x":12}
    property ParticleSystem system
    property bool show: true
    property int hardpointType: 0 //default is pea shooter - always bad.

    property Item targetObj: null
    property int damageDealt: 0
    onDamageDealtChanged: dealDamageTimer.start();
    Timer {
        id: dealDamageTimer
        interval: 16
        running: false
        repeat: false
        onTriggered: {targetObj.hp -= damageDealt; damageDealt = 0;}
    }
    width: 24
    height: 24
    function fireAt(targetArg) {//Each implement own
        if (targetArg != null) {
            hardpointLoader.item.fireAt(targetArg, container);
            targetObj = targetArg;
        }
    }
    Loader {
        id: hardpointLoader
        sourceComponent:  {
            switch (hardpointType) {
            case 1: laserComponent; break;
            case 2: blasterComponent; break;
            case 3: cannonComponent; break;
            default: emptyComponent;
            }
        }
    }
    Component {
        id: laserComponent
        LaserHardpoint {
            target: container.target
            system: container.system
            show: container.show
        }
    }
    Component {
        id: blasterComponent
        BlasterHardpoint {
            target: container.target
            system: container.system
            show: container.show
        }
    }
    Component {
        id: cannonComponent
        CannonHardpoint {
            target: container.target
            system: container.system
            show: container.show
        }
    }
    Component {
        id: emptyComponent
        Item {
            function fireAt(obj) {
                console.log("Firing null weapon. It hurts.");
            }
        }
    }
}
