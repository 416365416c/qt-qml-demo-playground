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

import QtQuick 2.0
import Qt.labs.presentation 1.0

Presentation {

    width: 1600
    height: 1200
    //Launch with qmlscene for resize
    
    Rectangle {
        anchors.fill: parent
        color: "white"
        Image {
            anchors.fill: parent
            source: "bg.png"
        }
    }

    Clock { textColor: "black" }
    SlideCounter { textColor: "black" }

    titleColor: "white"
    Slide { centeredText: "Adaptable UIs with QtQuick"; fontScale: 2; }
    Slide1{}
    Slide { title:"What is Adaptable UI?"; centeredText: "Magic"; }
    Slide2{}
    Slide3{}
    Slide4{}
    Slide5{}
    Slide6{}
    Slide7{}
    Slide8{}
    Slide9{}
    SlideA{}
    SlideA2{}
    SlideB{}
    SlideC{}
    SlideD{}
    SlideE{}
    SlideF{}
    SlideF2{}
    SlideG{}
    SlideH{}
    SlideH2{}
    SlideI{}
    SlideJ{}
     
}
