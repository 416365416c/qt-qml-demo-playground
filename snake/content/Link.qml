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

Item { id:link
    property bool dying: false
    property bool spawned: false
    property int type: 0
    property int row: 0
    property int column: 0
    property int rotation;

    width: 40;
    height: 40

    x: margin - 3 + gridSize * column
    y: margin - 3 + gridSize * row
    Behavior on x { NumberAnimation { duration: spawned ? heartbeatInterval : 0} }
    Behavior on y { NumberAnimation { duration: spawned ? heartbeatInterval : 0 } }


    Item {
        id: img
        anchors.fill: parent
        Image {
            source: {
                if(type == 1) {
                    "pics/blueStone.png";
                } else if (type == 2) {
                    "pics/head.png";
                } else {
                    "pics/redStone.png";
                }
            }

            transform: Rotation {
                id: actualImageRotation
                origin.x: width/2; origin.y: height/2;
                angle: rotation * 90
                Behavior on angle {
                    RotationAnimation{
                        direction: RotationAnimation.Shortest
                        duration: spawned ? 200 : 0
                    }
                }
            }
        }

        Image {
            source: "pics/stoneShadow.png"
        }

        opacity: 0
    }

    ParticleSystem {
        width:1; height:1; anchors.centerIn: parent;
        ImageParticle {
            groups: ["star"]
            source: type == 1 ? "pics/blueStar.png" : "pics/redStar.png"
        }
        Emitter {
            id: particles
            anchors.fill: parent
            group: "star"
            emitRate: 50
            enabled: false
            lifeSpan: 700
            acceleration: AngleDirection { angleVariation: 360; magnitude: 200 }
        }
    }

    states: [
        State{ name: "AliveState"; when: spawned == true && dying == false
            PropertyChanges { target: img; opacity: 1 }
        },
        State{ name: "DeathState"; when: dying == true
            StateChangeScript { script: particles.burst(50); }
            PropertyChanges { target: img; opacity: 0 }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { target: img; property: "opacity"; duration: 200 }
        }
    ]

}
