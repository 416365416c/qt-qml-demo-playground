/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the QML Presentation System.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/


import Qt.labs.presentation 1.0
import QtQuick 2.2
import QtQuick.Particles 2.0
import QtQuick.Controls 1.1
import "dialogue" as Dialogue

Presentation
{
    id: presentation

    width: 1900
    height: 1080

    SlideCounter {}
    Clock {}


    Slide {
        centeredText: "The Many Ways to Unite QML and C++"
    }

    Slide {
        title: "Way 0 - QtQuick UI"
        content: [
            "Powerful",
            "Simple",
            "Common",
        ]

        CodeSection {
            text: "import QtQuick.Particles 2.0
ParticleSystem {
    anchors.fill: parent
    ImageParticle {
        source: \"qrc:///particleresources/star.png\"
        alpha: 0.8
        colorVariation: 1.0
        z:10000
    }

    Emitter {
        id: burstEmitter
        anchors.centerIn: parent
        emitRate: 1000
        lifeSpan: 2000
        enabled: false
        velocity: AngleDirection {
            magnitude: 64;
            angleVariation: 360
        }
        size: 24
        sizeVariation: 8
    }
}
"
    ParticleSystem {
        anchors.fill: parent
        MouseArea {
            anchors.fill: parent
            onClicked: burstEmitter.pulse(1000);
        }
        ImageParticle {
            source: "qrc:///particleresources/star.png"
            alpha: 0.8
            colorVariation: 1.0
            z:10000
        }

        Emitter {
            id: burstEmitter
            anchors.centerIn: parent
            emitRate: 1000
            lifeSpan: 2000
            enabled: false
            velocity: AngleDirection{magnitude: 64; angleVariation: 360}
            size: 24
            sizeVariation: 8
        }
    }
        }
    }

    Slide {
        title: "Way 1 - JSON++"
        content: [
            "Can you spot all the errors?",
            "Do you get any help?",
            "Impact at parse or run time?",
            "It is human readable...",
            "But is it human writable?"
        ]
        CodeSection {
            text: "{
  'alpha' : 1,
  'beta' : 2,
  'gama' : 3,
  'numberOfThings: 'four',
}"
        }
        
    }
    
    Slide {
        title: "Way 1 - JSON++"
        content: [
            "Comments",
            "Default values",
            "Typed data",
            "Parse error on misspelling"
        ]
        CodeSection {
            text: 'import QtQml 2.2
QtObject {
    property int alpha
    property int beta
    property int gamma
    //Can use comments, which is nice
    property int numberOfThings: 4
}

import "DataDefinition"
Datum {
  alpha: 1
  beta: 2
  gama: 3
  numberOfThings: "four"
}'
        }
    }
    Slide {
        title: "Way 1 - JSON++"
        content: [
            "Easy Qt/C++ for JSON",
            "For reading it",
            "Error handling very manual"
        ]
        CodeSection {
            text: 'QFile file("data.json");
if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
    return handleError("Cannot open file");
QJsonParseError err;
QJsonDocument jd =
        QJsonDocument::fromJson(file.readAll(), &err);
if (err.error != QJsonParseError::NoError)
    return handleError(err.errorString());
if (!jd.isObject())
    return handleError("File valid, but not object");
QJsonValue alpha = jd.object().value("alpha");
if (alpha.isUndefined())
    return QLatin1String("defaultValue");
if (!alpha.isString())
    return handleError("Alpha value is not a string");
return alpha.toString();
'
        }
    }
    Slide {
        title: "Way 1 - JSON++"
        content: [
            "Easy Qt/C++ for QML",
            "Error handling done for you",
            "Errors as array as well",
            "Also turns data into QObjects"
        ]
        CodeSection {
            text: 'QQmlEngine engine;
QQmlComponent c(&engine, "data.qml");
QObject* qmlObject = c.create();
if (!qmlObject)
    return handleError(c.errorString());
return qmlObject->property("foo").toString();
'
        }
    }
    Slide {
        title: "Way 2 - Impatient Scripting"
        content: [
            "Unreal QtScript replacement",
            "JS functions",
            "Pass in as args or context"
        ]
        CodeSection {
            text: "import QtQml 2.0
QtObject {
    function getRand() {
        setRand(Math.floor(Math.random() * 200)
                + 100;
    }
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: saveDoc();
    }
}
"
        }
    }
    Slide {
        title: "Way 2 - Impatient Scripting"
        content: [
            "QML Engine does type conversion",
            "Network transparent",
            "C++ side is QObject<->QObject",
            "Plus context"
        ]
        CodeSection {
            text: 'QQmlEngine engine;
engine.rootContext()->setContextObject(enabler);
QUrl url("https://trusted.server.com/qml/custom.qml");
QQmlComponent c(&engine, url);
qmlObject = c.create();
if (!qmlObject)
    return handleError(c.errorString());
//Connection could be done in QML too!
QObject::connect(enabler, SIGNAL(newRand()),
        qmlObject, SLOT(getRand()));
'
        }
    }
    Slide {
        title: "Way 2 - Impatient Scripting"
        content: [
            "Script can be directed",
            "Custom object harness",
            "Or something like QQSM"
        ]
        CodeSection {
            text: "import QtQml.StateMachine 1.0
StateMachine {
    initialState: start
    FinalState {
        id: final
    }
    StateBase {
        id: start
        SignalTransition {
            targetState: middle
        }
    }
    StateBase {
        id: middle 
        SignalTransition {
            targetState: final
        }
    }
}
"
        }
    }
    Slide {
        title: "Way 2 - Impatient Scripting"
        content: [
            "No Sandbox",
            "Imports can load native code",
            "Can't (yet) disable QtQuick"
        ]
        CodeSection {
            text:'import QtQuick.Window 2.1
import QtQuick 2.1

Window {
    width: 1920
    height: 1280
    visible: true
    Rectangle {
        color: "blue"
        anchors.fill: parent
        Text {
            color: "red"
            text: "I HAXXED UR MAHCINE"
            anchors.centerIn: parent
            font.pixelSize: 128
        }
    }
}
'
        }
    }
    Slide {
        title: "Way 3 - Enriched Data"
        content: [
            "Combining the last two",
            "Data + Logic",
            "Are we programming yet?"
        ]
        CodeSection {
        text: 'import "DataDefinition"
Datum {
  alpha: 1
  beta: 2
  gama: 3
  numberOfThings: "four"
  function getRand() {
      setRand(Math.floor(Math.random() * 200)
              + 100;
  }
}'
        }
    }
    Slide {
        title: "Way 3 - qbs"
        content: [
            "qtgerrit:qt-labs/qbs.git",
            "Advanced Config Files",
            "Snippet from qtcreator.qbs"
        ]
        CodeSection {
        text: 'import qbs 1.0

Project {
    minimumQbsVersion: "1.3"
    property bool withAutotests: qbs.buildVariant === "debug"
    [...]
    property string ide_bin_path: qbs.targetOS.contains("osx")
            ? ide_app_target + ".app/Contents/MacOS"
            : ide_app_path
    property bool testsEnabled: qbs.getEnv("TEST") || qbs.buildVariant === "debug"
    property stringList generalDefines: [
        "QT_CREATOR",
        \'IDE_LIBRARY_BASENAME="\' + libDirName + \'"\',
        "QT_NO_CAST_TO_ASCII",
        "QT_NO_CAST_FROM_ASCII"
    ].concat(testsEnabled ? ["WITH_TESTS"] : [])
    qbsSearchPaths: "qbs"
    references: [
        "src/src.qbs",
        "share/share.qbs",
        "share/qtcreator/translations/translations.qbs",
        "tests/tests.qbs"
    ]
}
'
        }
    }
    Slide {
        title: "Way 3 - KineticTD"
        content: [
            "Unit data for a TD",
            "Parameters for managed instance",
            "+ Full UI control"
        ]
        CodeSection {
        text: 'MovingUnit {
    id: innerContainer
    speed: 1
    hp: 1
    onHpChanged: if(hp<=0) innerContainer.kill();
    [...]
    width: 10
    height: 10
    Rectangle{
        id: rect2
        anchors.fill: parent
        radius: 4
        border.color: "black"
        color: "white"
    }
}'
        }
    }
    Slide {
        title: "Way 3 - Dialogue Tree"
        content: [
            "Complex Dialogue Tree",
            "Allows non-trivial branching",
            "Data + Logic"
        ]
        CodeSection {
            text:'import "dialogue" as Dialogue
Dialogue.TestContent{
    id: story
    onCurrentNodeChanged: {
        if(currentNode.prechoiceText != "")
            historyText.append(currentNode.prechoiceText)
        choiceBox.model = currentNode.choices;
    }
}

ScrollView {
    id: dialogue1
    anchors.fill: parent
    anchors.bottomMargin: 300
    Text {
        id: historyText
        width: parent.width
        wrapMode: Text.WordWrap
        text: "Welcome to Space Pirates VS Socrates!"
        function append(newStuff) {
            historyText.text = historyText.text
                    + "\\n" + newStuff
        }
    }
}
'
        }
    }
    Slide {
        title: "Way 3 - Dialogue Tree"
        Dialogue.TestContent{
            id: story
            onCurrentNodeChanged: {
                if(currentNode.prechoiceText != "")
                    historyText.append(currentNode.prechoiceText)
                choiceBox.model = currentNode.choices;
            }
        }

        ScrollView {
            id: dialogue1
            anchors.fill: parent
            anchors.bottomMargin: 300
            Text {
                id: historyText
                width: parent.width
                wrapMode: Text.WordWrap
                text: "Welcome to Space Pirates VS Socrates!"
                function append(newStuff) {
                    historyText.text = historyText.text + "\n" + newStuff
                }
            }
        }
        Column {
            property Item otherRefToHT: historyText
            anchors.fill: parent
            anchors.topMargin: 350
            id: choiceCol
            //fills the scrollview, and behavior depends on implicit height???
            Repeater {
                id: choiceBox
                delegate: Text {
                    id: delegateContainer
                    text: playerText
                    width: parent ? parent.width : 1337
                    y: delegateContainer.height * index //HACK: Until I learn scrollview, this spaces single line options
                    visible: modelData.enabled
                    wrapMode: Text.WordWrap
                    color: choiceMA.containsMouse ? "red" : "blue"

                    MouseArea {
                        id: choiceMA
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            historyText.append(modelData.playerText);
                            historyText.append(modelData.responseText);
                            modelData.select() //starts cleanup process on this delegate!
                        }
                    }
                }
            }
        }
    }

}
