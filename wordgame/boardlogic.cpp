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

#include <QtCore/QTime>
#include <QtQml/qqml.h>

#include "boardlogic.h"
#include "wordlist.h"
#include "letters.h"
//C style strings used as extreme efficiency is desired
const int CHARS_MAX = 33;
const char* sentinelWord = "";


void BoardLogic::componentComplete(){
    //qDebug() << "Woohoo!  Now to do my costly initialization";
    QTime time(0,0,0,0);
    qsrand(time.msecsTo(QTime::currentTime()));
    connect(this, SIGNAL(boardChanged()),
            this, SLOT(updateBoardWords()));
    connect(this, SIGNAL(searchStringChanged()),
            this, SLOT(updateSearchTiles()));
    if(!m_tiles.count())//May have been populated by setting boardString
        regenerateBoard();
    else
        updateBoardWords();//Signal wasn't caught
    if(m_searchString != QString())
        updateSearchTiles();//Signal wasn't caught
}

void BoardLogic::regenerateBoard()
{
    foreach (Tile* t, m_tiles)
        t->deleteLater();
    m_tiles = QList<Tile*>();
    m_boardString = QString();
    for(int i=0; i<m_rows*m_columns; i++){
        QString letter;
        if(m_letters){
            letter = m_letters->generateCharacters(1);
            m_tiles << new Tile(i/m_columns, i%m_columns, letter, m_letters->scoreWord(letter), this);
        }else{
            letter = QChar(qrand() % 26 + 'a');
            m_tiles << new Tile(i/m_columns, i%m_columns, letter, 1.0, this);
        }
        m_boardString += letter;
    }

    emit boardChanged();
}

void BoardLogic::setBoardString(const QString &str)
{
    if(str.length() != m_rows * m_columns){
        qWarning() << "Given board string is the wrong size for this board. Not setting board string.";
        return;
    }
    if(m_tiles.count())
        qDeleteAll(m_tiles);
    m_tiles = QList<Tile*>();
    for(int i=0; i<str.length(); i++)
        m_tiles << new Tile(i/m_columns, i%m_columns, str.at(i), m_letters?m_letters->scoreWord(str.at(i)):0, this);

    m_boardString = str;
    emit boardChanged();
}

QString BoardLogic::boardString(){
    return m_boardString;
}

bool BoardLogic::isValid(const QString& str)
{
    return m_boardWords.contains(str, Qt::CaseInsensitive);
}

void BoardLogic::updateSearchTiles()
{
    if(m_rows*m_columns > 64){
        qWarning() << "Boards larger than 64 tiles will not get tiles selected";
        return;
    }

    QSet<int> selectSet;
    for(int i=0; i<m_rows*m_columns; i++)
        selectionTraverse(m_searchString.toLower().toLatin1().data(), 0, i, &selectSet);

    for(int i=0; i<m_rows*m_columns; i++)
        m_tiles.at(i)->setSelected(selectSet.contains(i));

    m_searchStringFound = !selectSet.isEmpty();
    emit searchStringFoundChanged();
}

void BoardLogic::updateBoardWords()
{
    m_boardWords = QStringList();
    if(m_rows*m_columns > 64){
        qWarning() << "Boards larger than 64 tiles will not get boardWords generated";
        return;
    }
    for(int i=0; i<m_rows*m_columns; i++)
        traverse(sentinelWord,0,i);

    m_boardWords.sort();//Alphabetical order
    emit boardWordsChanged();
}

QML_DECLARE_TYPE(BoardLogic);
QML_DECLARE_TYPE(Tile);

void BoardLogic::traverse(const char string[CHARS_MAX], quint64 visited, short at){
    if (visited&(1<<at))
        return;
    visited |= 1<<at;
    char new_string[CHARS_MAX] = "";
    sprintf(new_string,"%s%c",string,m_boardString.at(at).toLower().toLatin1());
    if(!WordList::instance()->isPartialWord(new_string))
        return;
    QString newString(new_string);
    if(WordList::instance()->isWord(newString) && !m_boardWords.contains(newString))
        m_boardWords << newString;
    for(int i=-1;i<=1;i++){
        for(int j=-1;j<=1;j++){
            if(i==0&&j==0)
                continue;
            traverse(new_string,visited,translate(at,i,j));
        }
    }
    return;
}

//Return value unused by initial caller - it only cares about ret
//Return value means it found the rest
bool BoardLogic::selectionTraverse(char* string, quint64 visited, short at, QSet<int>* ret){
    if(string[0] == '\0')
        return true;
    if (visited&(1<<at))
        return false;
    visited |= 1<<at;
    if(string[0] != m_tiles[at]->letter().at(0).toLower().toLatin1())
        return false;
    bool valid = false;
    for(int i=-1;i<=1;i++){
        for(int j=-1;j<=1;j++){
            if(i==0&&j==0)
                continue;
            if(selectionTraverse(&string[1],visited,translate(at,i,j), ret)){
                *ret << at;
                valid = true;
            }
        }
    }
    return valid;
}

int BoardLogic::translate(int at, int R, int C){
    int i,j;
    i = at / m_columns;
    j = at % m_columns;
    if(i+R<0||i+R>=m_rows||j+C<0||j+C>=m_columns)
        return at;//already visited, so instantly returns
    return (i+R)*m_columns+(j+C);
}
