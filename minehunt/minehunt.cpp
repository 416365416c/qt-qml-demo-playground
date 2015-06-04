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

#include <stdlib.h>
#include <QTime>
#include <QTimer>

#include "minehunt.h"

void tilesPropAppend(QQmlListProperty<TileData>* prop, TileData* value)
{
    Q_UNUSED(prop);
    Q_UNUSED(value);
    return; //Append not supported
}

int tilesPropCount(QQmlListProperty<TileData>* prop)
{
    return static_cast<QList<TileData*>*>(prop->data)->count();
}

TileData* tilesPropAt(QQmlListProperty<TileData>* prop, int index)
{
    return static_cast<QList<TileData*>*>(prop->data)->at(index);
}

QQmlListProperty<TileData> MinehuntGame::tiles(){
    return QQmlListProperty<TileData>(this, &_tiles, &tilesPropAppend,
            &tilesPropCount, &tilesPropAt, 0);
}

MinehuntGame::MinehuntGame()
: numCols(9), numRows(9), playing(true), won(false)
{
    setObjectName("mainObject");
    srand(QTime(0,0,0).secsTo(QTime::currentTime()));

    //initialize array
    for(int ii = 0; ii < numRows * numCols; ++ii) {
        _tiles << new TileData;
    }
    reset();

}

void MinehuntGame::setBoard()
{
    foreach(TileData* t, _tiles){
        t->setHasMine(false);
        t->setHint(-1);
    }
    //place mines
    int mines = nMines;
    remaining = numRows*numCols-mines;
    while ( mines ) {
        int col = int((double(rand()) / double(RAND_MAX)) * numCols);
        int row = int((double(rand()) / double(RAND_MAX)) * numRows);

        TileData* t = tile( row, col );

        if (t && !t->hasMine()) {
            t->setHasMine( true );
            mines--;
        }
    }

    //set hints
    for (int r = 0; r < numRows; r++)
        for (int c = 0; c < numCols; c++) {
            TileData* t = tile(r, c);
            if (t && !t->hasMine()) {
                int hint = getHint(r,c);
                t->setHint(hint);
            }
        }

    setPlaying(true);
}

void MinehuntGame::reset()
{
    foreach(TileData* t, _tiles){
        t->unflip();
        t->setHasFlag(false);
    }
    nMines = 12;
    nFlags = 0;
    emit numMinesChanged();
    emit numFlagsChanged();
    setPlaying(false);
    QTimer::singleShot(600,this, SLOT(setBoard()));
}

int MinehuntGame::getHint(int row, int col)
{
    int hint = 0;
    for (int c = col-1; c <= col+1; c++)
        for (int r = row-1; r <= row+1; r++) {
            TileData* t = tile(r, c);
            if (t && t->hasMine())
                hint++;
        }
    return hint;
}

bool MinehuntGame::flip(int row, int col)
{
    if(!playing)
        return false;

    TileData *t = tile(row, col);
    if (!t || t->hasFlag())
        return false;

    if(t->flipped()){
        int flags = 0;
        for (int c = col-1; c <= col+1; c++)
            for (int r = row-1; r <= row+1; r++) {
                TileData *nearT = tile(r, c);
                if(!nearT || nearT == t)
                    continue;
                if(nearT->hasFlag())
                    flags++;
            }
        if(!t->hint() || t->hint() != flags)
            return false;
        for (int c = col-1; c <= col+1; c++)
            for (int r = row-1; r <= row+1; r++) {
                TileData *nearT = tile(r, c);
                if (nearT && !nearT->flipped() && !nearT->hasFlag()) {
                    flip( r, c );
                }
            }
        return true;
    }

    t->flip();

    if (t->hint() == 0) {
        for (int c = col-1; c <= col+1; c++)
            for (int r = row-1; r <= row+1; r++) {
                TileData* t = tile(r, c);
                if (t && !t->flipped()) {
                    flip( r, c );
                }
            }
    }

    if(t->hasMine()){
        for (int r = 0; r < numRows; r++)//Flip all other mines
            for (int c = 0; c < numCols; c++) {
                TileData* t = tile(r, c);
                if (t && t->hasMine()) {
                    flip(r, c);
                }
            }
        won = false;
        hasWonChanged();
        setPlaying(false);
        return true;
    }

    remaining--;
    if(!remaining){
        won = true;
        hasWonChanged();
        setPlaying(false);
        return true;
    }
    return true;
}

bool MinehuntGame::flag(int row, int col)
{
    TileData *t = tile(row, col);
    if(!t || !playing || t->flipped())
        return false;

    t->setHasFlag(!t->hasFlag());
    nFlags += (t->hasFlag()?1:-1);
    emit numFlagsChanged();
    return true;
}
