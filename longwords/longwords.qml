import Qt 4.7
import Qt.labs.wordgame 1.0 as WordGame

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
    }
    Item{
        id: gameBoard
        width: 320
        height: 320
        Rectangle{
            id: bg
            anchors.fill: parent
            color: "palegoldenrod"
        }
        Repeater{
            model: logic.board
            delegate: TileDelegate{property int tileSize: 64}
        }
    }
    MyLineEdit{
        id: input
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
        function startEnd(){
            if(!logic.searchStringFound){
                dialog.text = "That word is not in this board.";
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
            }
        }
        anchors.top: gameBoard.bottom
        anchors.topMargin: 18
        anchors.horizontalCenter: parent.horizontalCenter

        focus: true
        Keys.onPressed:if(dialog.shown){dialog.hide(); event.accepted = true;}
        Keys.onReturnPressed: startEnd();
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
            onClicked: Qt.quit();
        }
    }
    Dialog{
        id: dialog
        anchors.fill: parent
    }
}
