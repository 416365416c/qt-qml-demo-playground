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

SequentialLoader {
    id: hLdr
    signal exitDesired
    Component.onCompleted: advance();
    ParticleSystem { id: helpSystem }
    PlasmaPatrolParticles { sys: helpSystem }
    pages: [
        Component {Item {
            id: story
            Text {
                color: "white"
                text: "Story"
                font.pixelSize: 48
            }
            /*
            Flickable {
                y: 60
                width: 360
                height: 500
                contentHeight: txt1.height
                contentWidth: 360//TODO: Less magic numbers?
                */
                Text {
                    id: txt1
                    color: "white"
                    y: 60
                    font.pixelSize: 18
                    text: "
In a remote nebula, a race of energy beings formed and lived prosperous lives for millenia. Until the schism - when they became constantly at each other's energy-throats. War soon followed, crippling both sides, until a truce was formed. But while governments knew the desparate need for peace, the soldiers in the ion-field were still filled with rampant bloodlust. On the border, patrols are constantly engaging in minor skirmishes whenever they cross paths. 

You must select one such patrol unit for the border, heading into an inevitable skirmish, in Plasma Patrol: the game of energy being spaceship combat!
                    "
                    width: 360
                    wrapMode: Text.WordWrap
                }
           // }
            Button {
                x: 20
                y: 560
                height: 40
                width: 120
                text: "Next"
                onClicked: hLdr.advance();
            }
            Button {
                x: 220
                y: 560
                height: 40
                width: 120
                text: "Menu"
                onClicked: hLdr.exitDesired();
            }
        }},
        Component {Item {
            id: ships
            Text {
                color: "white"
                text: "Vessels"
                font.pixelSize: 48
            }
            Column {
                spacing: 16
                y: 60
                Row {
                    height: 128
                    Sloop {
                        system: helpSystem
                    }
                    Text {
                        text: "The nimble sloop"
                        color: "white"
                        font.pixelSize: 18
                    }
                }
                Row {
                    height: 128
                    Frigate {
                        system: helpSystem
                    }
                    Text {
                        text: "The versitile shield frigate"
                        color: "white"
                        font.pixelSize: 18
                    }
                }
                Row {
                    height: 128
                    Cruiser {
                        system: helpSystem
                    }
                    Text {
                        text: "The armored cruiser"
                        color: "white"
                        font.pixelSize: 18
                    }
                }
            }
            Button {
                x: 20
                y: 560
                height: 40
                width: 120
                text: "Next"
                onClicked: hLdr.advance();
            }
            Button {
                x: 220
                y: 560
                height: 40
                width: 120
                text: "Menu"
                onClicked: hLdr.exitDesired();
            }
        }},
        Component {Item {
            id: guns
            Text {
                color: "white"
                text: "Hardpoints"
                font.pixelSize: 48
            }
            Column {
                spacing: 16
                y: 60
                Row {
                    height: 128
                    LaserHardpoint {
                        system: helpSystem
                    }
                    Text {
                        text: "The laser hardpoint almost always hits the target, even the nimble sloop, but loses much of its potency against the frigate's shields"
                        width: 332
                        wrapMode: Text.WordWrap
                        color: "white"
                        font.pixelSize: 18
                    }
                }
                Row {
                    height: 128
                    BlasterHardpoint {
                        system: helpSystem
                    }
                    Text {
                        text: "The blaster passes right through the frigate's shields but loses much of its impact against the armor of the cruiser"
                        width: 332
                        wrapMode: Text.WordWrap
                        color: "white"
                        font.pixelSize: 18
                    }
                }
                Row {
                    height: 128
                    CannonHardpoint {
                        system: helpSystem
                    }
                    Text {
                        text: "The cannon has poor accuracy, often missing the nimble sloop, but can punch right through the armor of the cruiser"
                        width: 332
                        wrapMode: Text.WordWrap
                        color: "white"
                        font.pixelSize: 18
                    }
                }
            }
            Button {
                x: 20
                y: 560
                height: 40
                width: 120
                text: "Next"
                onClicked: hLdr.advance();
            }
            Button {
                x: 220
                y: 560
                height: 40
                width: 120
                text: "Menu"
                onClicked: hLdr.exitDesired();
            }
        }},
        Component {Item {
            id: strategy
            Text {
                color: "white"
                text: "Strategy"
                font.pixelSize: 48
            }
            Flickable {
                y: 60
                width: 360
                height: 500
                contentHeight: txt1.height
                contentWidth: 360//TODO: Less magic numbers?
                Text {
                    id: txt1
                    color: "white"
                    font.pixelSize: 18
                    text: "
Basic Strategy: Good luck, have fun - don't die.
More to come after thorough playtesting.
                    "
                    width: 360
                    wrapMode: Text.WordWrap
                }
            }
            Button {
                x: 20
                y: 560
                height: 40
                width: 120
                text: "Story"
                onClicked: {hLdr.at=0; hLdr.advance();}
            }
            Button {
                x: 220
                y: 560
                height: 40
                width: 120
                text: "Menu"
                onClicked: hLdr.exitDesired();
            }
        }}
    ]
}
