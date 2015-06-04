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
import QtQuick.LocalStorage 2.0 as Sql

// Models a high score table.
//
// Use this component like this:
//
//  HighScoreModel {
//      id: highScores
//      game: "MyCoolGame"
//  }
//
// Then use either use the top-score properties:
//
//  Text { text: "HI: " + highScores.topScore }
//
// or, use the model in a view:
//
//  ListView {
//      model: highScore
//      delegate: Component {
//                    ... player ... score ...
//                }
//  }
//
// Add new scores via:
//
//  saveScore(newScore)
//
// or:
//
//  savePlayerScore(playerName,newScore)
//
// The best maxScore scores added by this method will be retained in an SQL database,
// and presented in the model and in the topScore/topPlayer properties.
//

ListModel {
    id: model
    property string game: ""
    property int topScore: 0
    property string topPlayer: ""
    property int maxScores: 10

    function __db()
    {
        return Sql.openDatabaseSync("HighScoreModel", "1.0", "Generic High Score Functionality for QML", 1000000);
    }
    function __ensureTables(tx)
    {
        tx.executeSql('CREATE TABLE IF NOT EXISTS HighScores(game TEXT, score INT, player TEXT)', []);
    }

    function fillModel() {
        __db().transaction(
            function(tx) {
                __ensureTables(tx);
                var rs = tx.executeSql("SELECT score,player FROM HighScores WHERE game=? ORDER BY score DESC", [game]);
                model.clear();
                if (rs.rows.length > 0) {
                    topScore = rs.rows.item(0).score
                    topPlayer = rs.rows.item(0).player
                    for (var i=0; i<rs.rows.length; ++i) {
                        if (i < maxScores)
                            model.append(rs.rows.item(i))
                    }
                    if (rs.rows.length > maxScores)
                        tx.executeSql("DELETE FROM HighScores WHERE game=? AND score <= ?",
                                            [game, rs.rows.item(maxScores).score]);
                }
            }
        )
    }

    function savePlayerScore(player,score) {
        __db().transaction(
            function(tx) {
                __ensureTables(tx);
                tx.executeSql("INSERT INTO HighScores VALUES(?,?,?)", [game,score,player]);
                fillModel();
            }
        )
    }

    function saveScore(score) {
        savePlayerScore("player",score);
    }

    function clearScores() {
        __db().transaction(
            function(tx) {
                tx.executeSql("DELETE FROM HighScores WHERE game=?", [game]);
                fillModel();
            }
        )
    }

    Component.onCompleted: { fillModel() }
}
