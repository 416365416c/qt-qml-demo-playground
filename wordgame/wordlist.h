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

#ifndef WORDLIST_H
#define WORDLIST_H

#include <QObject>
#include <QSet>
#include <QStringList>

class WordList : public QObject
{
    Q_OBJECT
    /*
       This object provides a set of functions that word games might need.
       They use a built in word list.

       When you import the WordGame module, it is registered into the
       WordList import namespace as a module API.
    */
public:
    explicit WordList(QObject *parent = 0);
    ~WordList();
    static WordList *instance();
    bool isPartialWord(char*);//Convenience for the C style code
signals:

public slots:
    //Returns true iff str is in word list
    bool isWord(const QString &str);
    //Returns true iff there exists 0 or more letters which could be appended
    //to str so that passing the resultant word to isWord would return true.
    bool isPartialWord(const QString &str);
    //Returns the set of words you can form with the letters in str.
    //Useful for anagrams or games where you create words from a set of letters
    //This is probably slow, and is not currently put in another thread
    QStringList wordsIn(const QString &str);
private:
    void init();
    static WordList* m_instance;
    QSet<QString> m_words;
    void wordsInHelper(const QString &given, const QString &left, QStringList &ret);
};

#endif // WORDLIST_H
