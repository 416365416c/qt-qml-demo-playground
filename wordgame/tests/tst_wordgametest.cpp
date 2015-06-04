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

#include <QtCore/QString>
#include <QtTest/QtTest>
#include "../boardlogic.h"
#include "../wordlist.h"
#include <QDebug>

class WordGameTest : public QObject
{
    Q_OBJECT

public:
    WordGameTest();

private Q_SLOTS:
    void initTestCase();
    void cleanupTestCase();
    void isWordTest();
    void isWordTest_data();
    void wordsInTest();
    void wordsInTest_data();
    void validBoardTest();
    void isValidTest();
    void selectionTest();
private:
    BoardLogic* board;
    WordList* list;
};

WordGameTest::WordGameTest()
{
}

void WordGameTest::initTestCase()
{
    list = WordList::instance();
    QVERIFY(list);
    board = new BoardLogic(this);
    //Note that, as it isn't created by the declarative parser, we need to call those fns manually
    QVERIFY(board->boardString() == QString());
    board->classBegin();
    board->setRows(5);
    board->setColumns(5);
    board->componentComplete();
    QCOMPARE(board->boardString().length(), 5*5);
}

void WordGameTest::cleanupTestCase()
{
    delete board;
}

void WordGameTest::isWordTest()
{
    QFETCH(QString, file);
    QFETCH(bool, result);
    QFile in(file);
    QVERIFY(in.open(QFile::Text | QFile::ReadOnly));
    QTextStream stream(&in);
    QString line = " ";
    while (!line.isNull()){
        line = stream.readLine().trimmed();
        if(line.length()<2)//don't check the blank line at the end
            continue;
        if(list->isWord(line) != result){
            qDebug() << "Dispute over" << line;
            QCOMPARE(list->isWord(line), result);
        }
        line = line.toUpper();//Test not case sensitive
        QCOMPARE(list->isWord(line), result);
    }
}

void WordGameTest::isWordTest_data()
{
    QTest::addColumn<QString>("file");
    QTest::addColumn<bool>("result");
    QTest::newRow("valid") << QString("allwords.dict") << true;
    QTest::newRow("invalid") << QString("notwords.dict") << false;
    QTest::newRow("dictionary") << QString("words.dict") << true;
}

void WordGameTest::wordsInTest()
{
    QFETCH(QString, file);
    QFile in(file);
    QVERIFY(in.open(QFile::Text | QFile::ReadOnly));
    QTextStream stream(&in);
    QString line = stream.readLine().trimmed();
    QString firstLine = line;
    QStringList ret = list->wordsIn(line);
    while (!line.isNull()){
        line = stream.readLine().trimmed();
        if(line.length()<2)//don't check the blank line at the end
            continue;
        if(!ret.contains(line,Qt::CaseInsensitive))
            qDebug() << "It didn't find" << line << "in" << firstLine;
        QVERIFY(ret.contains(line,Qt::CaseInsensitive));
        QVERIFY(list->isWord(line));
        QCOMPARE(ret.removeAll(line), 1);
    }
    if(ret.count())
        qDebug() << "It also found" << ret << "in" << firstLine;
    QCOMPARE(ret.count(), 0);
}

void WordGameTest::wordsInTest_data()
{
    QTest::addColumn<QString>("file");
    QTest::newRow("simple") << QString("wordsInTest.1");
    QTest::newRow("none") << QString("wordsInTest.2");
    QTest::newRow("complex") << QString("wordsInTest.3");
    QTest::newRow("doubleLetter") << QString("wordsInTest.4");
}

void WordGameTest::validBoardTest()
{
    //Tests that the randomly generated boards are valid, or at least internally consistent.
    QString lastBoard = "";
    for(int run=0; run<10; run++){//run on 10 different random boards
        int boardSize = board->rows() * board->columns();
        QCOMPARE(board->boardString().length(), boardSize);
        QCOMPARE(board->boardList()->count(), boardSize);
        for(int i=0; i<boardSize; i++){
            Tile* tile = board->boardList()->at(i);
            QCOMPARE(tile->letter().length(), 1);
            QCOMPARE(tile->letter().at(0), board->boardString().at(i));
        }
        QVERIFY(lastBoard != board->boardString());
        lastBoard = board->boardString();
        board->regenerateBoard();
    }
}

void WordGameTest::isValidTest()
{
    for(int run=0; run<10; run++){//run on 10 different random boards
        board->regenerateBoard();
        //Technically unstable, but in reality I doubt it will ever get a grid with 1 or 0 words - if it's working properly
        if(board->boardWords().count() <= 1)
            qDebug() << "This board is impossible: " << board->boardString();
        QVERIFY(board->boardWords().count() > 1);
        //Below test is greatly simplified compared to the actual code. But provides a basic sanity check, considering the number of words
        foreach(const QString &word, board->boardWords()){
            for(int letter=0; letter<word.length() - 1; letter++){
                bool valid = false; //Valid iff the next letter in the board is adjacent
                for(int tile=0; tile<board->boardString().length(); tile++){
                    if(board->boardString().at(tile).toLower() != word.at(letter).toLower())
                        continue;
                    for(int adj=0; adj<8; adj++){
                        int next = tile;
                        int cols = board->columns();
                        switch(adj){
                        case 0: next += -1*cols - 1; break;
                        case 1: next += 0*cols - 1; break;
                        case 2: next += 1*cols - 1; break;
                        case 3: next += -1*cols + 0; break;
                        case 4: next += 1*cols + 0; break;
                        case 5: next += -1*cols + 1; break;
                        case 6: next += 0*cols + 1; break;
                        case 7: next += 1*cols + 1; break;
                        }
                        if(next >=0 && next < board->boardString().length()
                                && board->boardString().at(next).toLower() == word.at(letter+1).toLower())
                            valid = true;
                        if(valid)
                            break;
                    }
                    if(valid)
                        break;
                }
                if(!valid){
                    qDebug() << board->boardString() << " couldn't possibly contain "
                             << word << " because " << word.at(letter) << " isn't next to " << word.at(letter+1);
                }
                QVERIFY(valid);
            }
        }
    }
}

void WordGameTest::selectionTest()
{
    for(int run=0; run<10; run++){//run on 10 different random boards
        board->regenerateBoard();
        //run on all board words
        foreach(const QString &word, board->boardWords()){
            board->setSearchString(word);
            QSet<int> usedIndices;
            for(int letter=0; letter<word.length() - 1; letter++){
                bool valid = false; //Valid iff there's an appropriate letter selected
                for(int tile=0; tile<board->boardList()->count(); tile++){
                    if(!usedIndices.contains(tile) && board->boardList()->at(tile)->isSelected()
                            && board->boardList()->at(tile)->letter().at(0).toLower() == word.at(letter).toLower()){
                        valid = true;
                        usedIndices << tile;
                        break;
                    }
                }
                if(!valid)
                    qDebug() << "I cannot find a selected " << word.at(letter) << " for "
                             << board->searchString() << " on " << board->boardString();
                QVERIFY(valid);
            }
        }

       //run on a few wrong words
       QStringList totallyWrong;
       totallyWrong << "abcdefghijklmnopqrstuvwxyz" << "a!" << "aaaaaaaaaaaaaaaaaaaaaaaaaa" << "supercalifragilisticexpialidocious";
       QStringList maybeWrong;
       maybeWrong << "hello" << "test" << "string" << "pandas" << "abysmal" << "harpy" << "fig" << "demure" << "the";
       foreach(const QString &str, maybeWrong)
           if(!board->boardWords().contains(str))
               totallyWrong << str;
       foreach(const QString &str, totallyWrong){
           board->setSearchString(str);
           for(int tile=0; tile<board->boardList()->count(); tile++){
               if(board->boardList()->at(tile)->isSelected())
                   qDebug() << "For some reason," << tile << " is selected when the searchString is " << board->searchString()
                               << "on the board" << board->boardString();
               QVERIFY(!board->boardList()->at(tile)->isSelected());
           }
       }
    }

}

QTEST_APPLESS_MAIN(WordGameTest);

#include "tst_wordgametest.moc"
