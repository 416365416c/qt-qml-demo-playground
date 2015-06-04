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


#include <qqml.h>

class TileData : public QObject
{
    Q_OBJECT
public:
    TileData() : _hasFlag(false), _hasMine(false), _hint(-1), _flipped(false) {}

    Q_PROPERTY(bool hasFlag READ hasFlag WRITE setHasFlag NOTIFY hasFlagChanged)
    bool hasFlag() const { return _hasFlag; }

    Q_PROPERTY(bool hasMine READ hasMine NOTIFY hasMineChanged)
    bool hasMine() const { return _hasMine; }

    Q_PROPERTY(int hint READ hint NOTIFY hintChanged)
    int hint() const { return _hint; }

    Q_PROPERTY(bool flipped READ flipped NOTIFY flippedChanged())
    bool flipped() const { return _flipped; }

    void setHasFlag(bool flag) {if(flag==_hasFlag) return; _hasFlag = flag; emit hasFlagChanged();}
    void setHasMine(bool mine) {if(mine==_hasMine) return; _hasMine = mine; emit hasMineChanged();}
    void setHint(int hint) { if(hint == _hint) return; _hint = hint; emit hintChanged(); }
    void flip() { if (_flipped) return; _flipped = true; emit flippedChanged(); }
    void unflip() { if(!_flipped) return; _flipped = false; emit flippedChanged(); }

signals:
    void flippedChanged();
    void hasFlagChanged();
    void hintChanged();
    void hasMineChanged();

private:
    bool _hasFlag;
    bool _hasMine;
    int _hint;
    bool _flipped;
};

class MinehuntGame : public QObject
{
    Q_OBJECT
public:
    MinehuntGame();

    Q_PROPERTY(QQmlListProperty<TileData> tiles READ tiles CONSTANT)
    QQmlListProperty<TileData> tiles();

    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY isPlayingChanged)
    bool isPlaying() {return playing;}

    Q_PROPERTY(bool hasWon READ hasWon NOTIFY hasWonChanged)
    bool hasWon() {return won;}

    Q_PROPERTY(int numMines READ numMines NOTIFY numMinesChanged)
    int numMines() const{return nMines;}

    Q_PROPERTY(int numFlags READ numFlags NOTIFY numFlagsChanged)
    int numFlags() const{return nFlags;}

public slots:
    Q_INVOKABLE bool flip(int row, int col);
    Q_INVOKABLE bool flag(int row, int col);
    void setBoard();
    void reset();

signals:
    void isPlayingChanged();
    void hasWonChanged();
    void numMinesChanged();
    void numFlagsChanged();

private:
    bool onBoard( int r, int c ) const { return r >= 0 && r < numRows && c >= 0 && c < numCols; }
    TileData *tile( int row, int col ) { return onBoard(row, col) ? _tiles[col+numRows*row] : 0; }
    int getHint(int row, int col);
    void setPlaying(bool b){if(b==playing) return; playing=b; emit isPlayingChanged();}

    QList<TileData *> _tiles;
    int numCols;
    int numRows;
    bool playing;
    bool won;
    int remaining;
    int nMines;
    int nFlags;
};
