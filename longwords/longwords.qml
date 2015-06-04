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
import Qt.labs.wordgame 2.0 as WordGame

Item{
    id: root
    height: 480
    width: 320
    GameProps{id:props}
    WordGame.BoardLogic{
        id: logic
        rows: 5
        columns: 5
        searchString: input.text
        /* Some JS functions added to facilitate this specific word game. Not
            placed in a separate file because it is only one exposed function,
            tightly integrated with the QML.
        */
        function addWordsOfLength(n){
            var first = true;
            for(var i in logic.boardWords){
                if(logic.boardWords[i].length != n || logic.boardWords[i] == input.text)
                    continue;
                if(first == true)
                    first = false;
                else
                    dialog.text += ", "
                dialog.text += logic.boardWords[i];
            }
        }
        function endGame(){
            if(!logic.searchStringFound){
                if (WordGame.WordList.isWord(searchString))
                    dialog.text = "That word is not in this board (although the word is a valid word)";
                else
                    dialog.text = "That word is not in this board (and the word is not a valid word)";
                dialog.show();
            } else if(!logic.isValid(input.text)){
                dialog.text = "That is not a valid word.";
                dialog.show();
            } else {
                var bestLength = 0;
                for(var i in logic.boardWords){
                    if(logic.boardWords[i].length > bestLength)
                        bestLength = logic.boardWords[i].length;
                }
                if(input.text.length == bestLength){
                    dialog.text = "That is a longest word! Well done!\nHere are some of the other longest words:\n";
                }else if(input.text.length == bestLength - 1){
                    dialog.text = "That is nearly a longest word. Well done.\nHere are the longest words:\n";
                }else{
                    dialog.text = "That is not a longest word.\nHere are the longest words:\n";
                }
                addWordsOfLength(bestLength);
                dialog.text += "\nAnd here are some more long, but not longest, words:\n";
                addWordsOfLength(bestLength-1);
                dialog.show();
                logic.regenerateBoard();
                input.text = "";
            }
        }
    }
    Rectangle{
        id: bg
        anchors.fill: parent
        color: "palegoldenrod"
    }
    Item{
        id: gameBoard
        width: 320
        height: 320
        Repeater{
            model: logic.board
            delegate: TileDelegate {
                property int tileSize: 64
                onClicked: input.text = input.text + letter
            }
        }
    }
    MyLineEdit{
        id: input
        anchors.top: gameBoard.bottom
        anchors.topMargin: 18
        anchors.horizontalCenter: parent.horizontalCenter

        focus: true
        Keys.onPressed:if(dialog.shown){dialog.hide(); event.accepted = true;}
        Keys.onReturnPressed: if(dialog.shown){dialog.hide();}else{logic.endGame();}//happens before onPressed
    }
    Text{
        id: guide
        opacity: logic.searchStringFound?1:0
        Behavior on opacity{ NumberAnimation{}}
        text: "Length: " + input.text.length
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: input.bottom
        anchors.topMargin: 16
    }
    Button{
        id: done
        opacity: logic.searchStringFound?1:0
        Behavior on opacity{ NumberAnimation{}}
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: guide.bottom
        anchors.topMargin: 16
        text: "Done"
        onClicked: {if(logic.searchStringFound) logic.endGame(); input.text="";}
    }
    Row{
        spacing: 8
        height: newGameButton.height
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        Button{
            id: newGameButton
            text: "New Board"
            onClicked: logic.regenerateBoard();
        }
        Button{
            anchors.margins: 4
            text: "Quit Game"
            onClicked: Qt.quit()
        }
    }
    Dialog{
        id: dialog
        anchors.fill: parent
    }
}
