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
    property ParticleSystem sys
    ImageParticle {
        system: sys
        groups: ["default"]
        source: "pics/blur-circle3.png"
        color: "#003A3A3A"
        colorVariation: 0.1
        z: 0
    }
    ImageParticle {
        system: sys
        groups: ["redTeam"]
        source: "pics/blur-circle3.png"
        color: "#0028060A"
        colorVariation: 0.1
        z: 0
    }
    ImageParticle {
        system: sys
        groups: ["greenTeam"]
        source: "pics/blur-circle3.png"
        color: "#0006280A"
        colorVariation: 0.1
       z: 0
    }
    ImageParticle {
        system: sys
        groups: ["blaster"]
        source: "pics/star2.png"
        //color: "#0F282406"
        color: "#0F484416"
        colorVariation: 0.2
        z: 2
    }
    ImageParticle {
        system: sys
        groups: ["laser"]
        source: "pics/star3.png"
        //color: "#00123F68"
        color: "#00428FF8"
        colorVariation: 0.2
        z: 2
    }
    ImageParticle {
        system: sys
        groups: ["cannon"]
        source: "pics/particle.png"
        color: "#80FFAAFF"
        colorVariation: 0.1
        z: 2
    }
    ImageParticle {
        system: sys
        groups: ["cannonCore"]
        source: "pics/particle.png"
        color: "#00666666"
        colorVariation: 0.8
        z: 1
    }
    ImageParticle {
        system: sys
        groups: ["cannonWake"]
        source: "pics/star.png"
        color: "#00CCCCCC"
        colorVariation: 0.2
        z: 1
    }
    ImageParticle {
        system: sys
        groups: ["frigateShield"]
        source: "pics/blur-circle2.png"
        color: "#00000000"
        colorVariation: 0.05
        blueVariation: 0.5
        greenVariation: 0.1
        z: 3
    }
    ImageParticle {
        system: sys
        groups: ["cruiserArmor"]
        z: 1
        sprites:[Sprite {
                id: spinState
                name: "spinning"
                source: "pics/meteor.png"
                frameCount: 35
                frameDuration: 40
                to: {"death":0, "spinning":1}
            },Sprite {
                name: "death"
                source: "pics/meteor_explo.png"
                frameCount: 22
                frameDuration: 40
                to: {"null":1}
            }, Sprite {
                name: "null"
                source: "pics/nullRock.png"
                frameCount: 1
                frameDuration: 1000
            }
        ]
    }
    TrailEmitter {
        system: sys
        group: "cannonWake"
        follow: "cannon"
        emitRatePerParticle: 64
        lifeSpan: 600
        speed: AngleDirection { angleVariation: 360; magnitude: 48}
        size: 16
        endSize: 8
        sizeVariation: 2
        enabled: true
        width: 1000//XXX: Terrible hack
        height: 1000
    }
    TrailEmitter {
        system: sys
        group: "cannonCore"
        follow: "cannon"
        emitRatePerParticle: 256
        lifeSpan: 128
        size: 24
        endSize: 8
        enabled: true
        width: 1000//XXX: Terrible hack
        height: 1000
    }
}
