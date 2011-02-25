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


#ifndef BOARDLOGIC_H
#define BOARDLOGIC_H

#include <QtDeclarative>
#include <QtCore/QStringList>
class Letters;

class Tile : public QObject
{
    //Just some simple properties describing a tile with a letter on it

    Q_OBJECT
    Q_PROPERTY(int row READ row CONSTANT);
    Q_PROPERTY(int column READ col CONSTANT);
    Q_PROPERTY(QString letter READ letter CONSTANT);
    Q_PROPERTY(qreal score READ score REVISION 1 CONSTANT);
    //Selection state is controlled by the BoardLogic object, see search String
    Q_PROPERTY(bool selected READ isSelected NOTIFY selectedChanged);

public:
    Tile(int row,int col,QString letter, qreal score=1.0, QObject* parent=0):
        QObject(parent), m_row(row), m_col(col), m_letter(letter), m_selected(false), m_score(score) {}

    int row() const { return m_row; }
    int col() const { return m_col; }
    QString letter() const { return m_letter; }
    qreal score() const {return m_score; }
    bool isSelected() const { return m_selected; }
    void setSelected(bool s) { if(s == m_selected) return; m_selected = s; emit selectedChanged(); }
signals:
    void selectedChanged();
private:
    int m_row;
    int m_col;
    QString m_letter;
    bool m_selected;
    qreal m_score;
};

class BoardLogic : public QObject,public QDeclarativeParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QDeclarativeParserStatus)
    /*
        For a board-based word game. If you don't have a board, don't make one of these.
        You can use WordList on its own for those cases.
    */
    //Numbers of columns on the board
    Q_PROPERTY(int columns READ columns WRITE setColumns NOTIFY columnsChanged);
    //Number of rows on the board
    Q_PROPERTY(int rows READ rows WRITE setRows NOTIFY rowsChanged);
    //Number of words found in the board
    Q_PROPERTY(int wordCount READ wordCount NOTIFY wordCountChanged);
    //The board concatenated into one string. You could break it into letters yourself if you want
    //Setting this property allows you to use a specific, instead of random, board.
    Q_PROPERTY(QString boardString READ boardString WRITE setBoardString NOTIFY boardChanged);
    //A list of QObjects suitable for use as a model in QML
    Q_PROPERTY(QDeclarativeListProperty<Tile> board READ board NOTIFY boardChanged);
    //A list of words in the board
    Q_PROPERTY(QStringList boardWords READ boardWords NOTIFY boardWordsChanged);
    //By setting a searchString, Tiles in board get updated to have 'selected' be set to true if and only if it is in
    //the set of tiles which could be used to find that string on the board, with the current adjacency mode.
    //This if not affected by whether the specified string is a valid word or not.
    Q_PROPERTY(QString searchString READ searchString WRITE setSearchString NOTIFY searchStringChanged);
    //searchStringFound is true when the searchString can be found in at least one place on the board.
    Q_PROPERTY(bool searchStringFound READ searchStringFound NOTIFY searchStringFoundChanged);

    //A Letters object is how you can set the individual letter frequencies and score
    Q_PROPERTY(Letters* letters READ letters WRITE setLetters NOTIFY lettersChanged REVISION 1);
public slots:
    //Replaces the existing tiles with another, randomly selected, set of tiles.
    //By default it's called on component complete, unless you explicitly set boardString
    void regenerateBoard();
    //Returns true if and only if the given string can be found in both the word list and the board
    //Faster than testing those two individually.
    bool isValid(const QString& str);
    //END OF QML API

public:
    int columns() const{return m_columns;}
    void setColumns(int c){if(c==m_columns) return; m_columns = c; emit columnsChanged();}

    int rows() const{return m_rows;}
    void setRows(int c){if(c==m_rows) return; m_rows = c; emit rowsChanged();}

    int wordCount() const{return m_wordCount;}

    QDeclarativeListProperty<Tile> board() { return QDeclarativeListProperty<Tile>(this, m_tiles); }
    QList<Tile*>* boardList(){ return &m_tiles; }//C++ convenience
    QStringList boardWords() const{return m_boardWords;}

    QString searchString() const{return m_searchString;}
    void setSearchString(QString c){if(c==m_searchString) return; m_searchString = c; emit searchStringChanged();}

    bool searchStringFound(){return m_searchStringFound;}

    Letters* letters() const { return m_letters; }
    void setLetters(Letters* arg) { if (m_letters != arg) { m_letters = arg; emit lettersChanged(arg); } }

    //Note that boardString and board have non-boilerplate methods
signals:
    void rowsChanged();
    void columnsChanged();
    void wordCountChanged();
    void boardWordsChanged();
    void boardChanged();
    void searchStringChanged();
    void searchStringFoundChanged();
    Q_REVISION(1) void lettersChanged(Letters* arg);

private:
    int m_columns;
    int m_rows;
    int m_wordCount;
    QStringList m_boardWords;
    QString m_searchString;
    QList<Tile*> m_tiles;
    QString m_boardString;
    bool m_searchStringFound;
    Letters* m_letters;
//end of boilerplate code
public:
    BoardLogic(QObject* parent=0):
        QObject(parent), m_columns(1), m_rows(1), m_wordCount(0), m_letters(0)
    {}

    void setBoardString(const QString &);
    QString boardString();
    virtual void componentComplete();//pure virtual from QDeclarativeParserStatus, for costly initialization
    virtual void classBegin(){}//unused pure virtual from QDeclarativeParserStatus


private slots:
    void updateSearchTiles();
    void updateBoardWords();

private:
    void traverse(char string[30], quint64 visited, short at);
    bool selectionTraverse(char*, quint64 visited, short at, QSet<int>*);
    int translate(int,int,int);
    Q_DISABLE_COPY(BoardLogic)
};

#endif // BOARDLOGIC_H

