/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the example applications of the Qt Toolkit.
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
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
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
** $QT_END_LICENSE$
**
****************************************************************************/
.pragma library//For global shared state
Qt.include("list.js");

var rootItem;
var scoreItem;
var explosionItem;
var defender = null;
var defenderProjectiles = new List();
var defenderProjectileComponent = Qt.createComponent("DefenderProjectile.qml");
var invaders = new List();
var invaderProjectileComponent = Qt.createComponent("InvaderProjectile.qml");
var invaderProjectiles = new List();
var blocks = new List();
var score = 0;
var gameStarted = false;

var invaderDirection = "Right";

function startLevel(root,scoreBox,explosionSys)
{
    //Create Components
    var invaderComponent = Qt.createComponent("Invader.qml");
    var defenderComponent = Qt.createComponent("Defender.qml");
    var blockComponent = Qt.createComponent("Block.qml");
    rootItem = root;
    explosionItem = explosionSys;
    scoreItem = scoreBox;
    defenderProjectiles.clearItems();
    invaderProjectiles.clearItems();
    invaders.clearItems();
    blocks.clearItems();
    score = 0;
    scoreBox.text = "000";

    //Create Objects
    if(defender == null || defender.toString() == "null")
        defender = defenderComponent.createObject(rootItem, {"y" : rootItem.height - 40, "focus" : true});
    for(var i = 0; i < 16; i++){
        var col = i % 4;
        var row = Math.floor(i/4);
        invaders.append(invaderComponent.createObject(rootItem, {"x" : col * 44, "y" : 20 + row * 24 }));
    }
    for(var i = 0; i < 32; i++){
        var col = i % 16;
        var row = Math.floor(i/16);
        for(var j = 0; j < 4; j++)
            if(col + row >= 1 && col - row <= 14) //Gives the corner effect on the top face
                blocks.append(blockComponent.createObject(rootItem, {"x" : 30 + j * 80 + col * 4, "y" : rootItem.height - 80 + row * 4 }));
    }
    gameStarted = true;
}

function endLevel(won)
{
    if(!gameStarted)
        return;
    if(won == true)
        score += 1000;
    else
        defender.destroy();
    scoreItem.text = "GAME OVER - FINAL SCORE: " + score;
    defenderProjectiles.clearItems();
    invaderProjectiles.clearItems();
    gameStarted = false;
}

function fire(x,y)//Invoked by the defender
{
    defenderProjectiles.append(defenderProjectileComponent.createObject(rootItem, {"x":x, "initialY":y, "targetY" : -10}));
    console.log(defenderProjectileComponent.errorString());
}

function cleanUpItem(list, item)
{
    for(var i = 0; i < list.size; i++){
        if(list.at(i) == item){
            list.destroy(i);
            return true;
        }
    }
    return false;
}

function cleanUpProjectile(item)//They want to delete themselves when animation finishes
{
    if(!cleanUpItem(defenderProjectiles,item))
        cleanUpItem(invaderProjectiles, item);
}

function intersect(rect1, rect2)
{
    if(rect1 == undefined || rect2 == undefined)
        return false;
    if(rect1.x + rect1.width > rect2.x && rect1.x < rect2.x + rect2.width
            && rect1.y + rect1.height > rect2.y && rect1.y < rect2.y + rect2.height)
        return true;
    return false;
}

function collisionHelper(list, hostile)
{
    for(var i = 0; i < list.size; i++){
        if(hostile){
            if(intersect(list.at(i), defender)) {
                explosionItem.burst(400, list.at(i).x, list.at(i).y);
                endLevel();
            }
        }else{
            for(var j = 0; j < invaders.size; j++){
                if(intersect(list.at(i), invaders.at(j))){
                    explosionItem.burst(400, list.at(i).x, list.at(i).y);
                    list.destroy(i--);
                    invaders.destroy(j--);
                    score += 100;
                    scoreItem.text = score.toString();
                }
            }
        }

        for(var j = 0; j < blocks.size; j++){
            if(intersect(list.at(i), blocks.at(j))){
                explosionItem.burst(400, list.at(i).x, list.at(i).y);
                if(list != invaders) {
                    list.destroy(i--);
                }
                blocks.destroy(j--);
            }
        }
    }
}

function tick()
{
    if(invaders.size == 0)
        endLevel(true);
    if(!gameStarted)
        return;

    //Note that projectiles move via an animation. We manually move the invaders. The player moves the defender.
    //Move invaders
    var moveDown = false;
    if(invaderDirection == "Right"){
        for(var i = 0; i < invaders.size; i++){
            if(invaders.at(i).x + invaders.at(i).width + 4 > rootItem.width){
                invaderDirection = "Left";
                moveDown = true;
            }
        }
    }else{
        for(var i = 0; i < invaders.size; i++){
            if(invaders.at(i).x - 4 < 0){
                invaderDirection = "Right";
                moveDown = true;
            }
        }
    }

    var invaderMoveIncrement = 4 - Math.floor((invaders.size - 1)/4);
    if(moveDown == true){
        for(var i = 0; i < invaders.size; i++)
            invaders.at(i).y += invaders.at(i).height;
    }else if(invaderDirection == "Right"){
        for(var i = 0; i < invaders.size; i++)
            invaders.at(i).x += invaderMoveIncrement;
    }else{
        for(var i = 0; i < invaders.size; i++)
            invaders.at(i).x -= invaderMoveIncrement;
    }

    //Invaders Shoot (same amount on average, no matter how many there are, about 1.6 shots per second)
    for(var i = 0; i < invaders.size; i++){
        var r = Math.random() * 60 * invaders.size/1.6;
        if(r < 1)
            invaderProjectiles.append(invaderProjectileComponent.createObject(rootItem, {"x":invaders.at(i).x, "initialY":invaders.at(i).y, "targetY" : rootItem.height}));
    }

    //Check Collisions
    collisionHelper(defenderProjectiles, false);
    collisionHelper(invaderProjectiles, true);
    collisionHelper(invaders, true);
}
