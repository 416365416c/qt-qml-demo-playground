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
#include "wordlist.h"
#include <QtCore/QFile>
#include <cstring>
#include <QDebug>

const int LEN_MAX=30;//Rounded to a round number for safety (sentinel and null terminator have room)
bool wordCheck(char word[LEN_MAX]);

WordList::WordList(QObject *parent) :
    QObject(parent)
{
    init();
}

WordList* WordList::m_instance = 0;
WordList* WordList::instance()
{
    if(m_instance)
        return m_instance;
    else
        m_instance = new WordList();
    return m_instance;
}

WordList::~WordList()
{
    m_instance = 0;
}

bool WordList::isPartialWord(const QString &c)
{
    return isPartialWord(c.toLatin1().toLower().data());
}

bool WordList::isWord(const QString &string)
{
    return m_words.contains(string.toLower());
}

QStringList WordList::wordsIn(const QString &str)
{
    QStringList ret;
    wordsInHelper(QLatin1String(""), str, ret);
    return ret;
}

//Using a C style global array since I'm using C style strings anyways
const int WORD_MAX=200000;
char dict[WORD_MAX][LEN_MAX];
int idx[26*26];
int numWords;

void WordList::init(){
    //Create 'Binary Tree'
    QFile in(":/words.dict");//Assumed to be in alphabetical order already
    bool opened = in.open(QFile::Text | QFile::ReadOnly);
    Q_ASSERT(opened);
    int c=0;
    char cur[LEN_MAX];
    char curIdx[2];//Assumed all words have at least 2 letters
    curIdx[0] = ' ';
    curIdx[1] = ' ';
    while(in.readLine(cur,LEN_MAX) > 0){
            if(cur[0]=='\n' || cur[0]=='\0')
                continue;
            m_words << QString(cur).toLower().trimmed();
            sprintf(dict[c],"%s", cur);
            if(curIdx[0] < cur[0]){//Assumed each of the 26 letters starts at least one word
                curIdx[0] = cur[0];
                curIdx[1] = 'a';
                idx[(curIdx[0]-'a') * 26] = c;
            }
            while(curIdx[1] < cur[1]){
                curIdx[1]++;
                Q_ASSERT(curIdx[1] >= 'a' && curIdx[1] <= 'z');
                idx[(curIdx[0]-'a') * 26 + (curIdx[1] - 'a')] = c;
            }
            c++;
    }
    numWords = c;
    Q_ASSERT(m_words.count() == c);//Assumed no duplicates
    in.close();
}

bool WordList::isPartialWord(char *c)
{
    int l = strlen(c);
    if(l < 2)
        return true;
    int i = idx[(c[0]-'a') * 26 + (c[1]-'a')];
    for(i; i<numWords && strncmp(dict[i],c,l) < 0; i++){};
    return (strncmp(dict[i],c,l) == 0);
}


void WordList::wordsInHelper(const QString &given, const QString &left, QStringList &ret)
{
    for(int i=0; i<left.length(); i++){
        QString part = given + left[i];
        if(isPartialWord(part)){
            if(isWord(part)){
                if(ret.contains(part))
                    return;//We've hit a duplicate letter arrangement
                ret << part;
            }
            QString nowLeft(left);
            nowLeft.remove(i,1);
            wordsInHelper(part, nowLeft, ret);
        }

    }
}
