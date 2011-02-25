#include "letters.h"
#include <QFile>
#include <QStringList>
#include <QTime>

Letters::Letters(QObject *parent) :
    QObject(parent) , m_frequenciesChanged(true), m_scoresChanged(true)
{
    QTime time;
    qsrand(time.msecsTo(QTime::currentTime()));
}

QString Letters::generateCharacters(int number)
{
    if(m_frequenciesChanged)
        generateFrequencies();
    QString ret;
    for(int i=0; i<number; i++){
        int r = qrand() / RAND_MAX;
        for(QHash<QChar, qreal>::iterator iter = m_frequencies.begin();
            iter != m_frequencies.end(); iter++){
            if(r < *iter){
                ret += iter.key();
                break;
            }
            r -= *iter;
        }
    }
    return ret;
}

qreal Letters::scoreWord(QString word)
{
    if(m_scoresChanged)
        generateScores();
    qreal ret = 0;
    for(int i=0; i<word.length(); i++){
        if(m_scores.contains(word.at(i)))
            ret += m_scores[word.at(i)];
        else
            ret += 1.0;
    }
    return ret;
}

QHash<QChar, qreal> loadFile(QUrl url)
{
    QHash<QChar, qreal> ret;
    QStringList input;
    QFile in(url.toLocalFile());
    if(!in.open(QFile::ReadOnly | QFile::Text))
        return ret;

    while(!in.atEnd())
        input << QString(in.readLine());

    foreach(const QString &s, input){
        QChar c = s.at(0);
        qreal p = s.mid(1).toDouble();
        ret.insert(c, p);
    }

    return ret;
}

void Letters::generateFrequencies()
{
    m_frequencies = loadFile(m_frequenciesSource);
    //Normalize frequencies
    qreal total = 0;
    for(QHash<QChar, qreal>::iterator iter = m_frequencies.begin();
        iter != m_frequencies.end(); iter++)
        total += (*iter);
    for(QHash<QChar, qreal>::iterator iter = m_frequencies.begin();
        iter != m_frequencies.end(); iter++)
        m_frequencies.insert(iter.key(), (*iter)/total);

}

void Letters::generateScores()
{
    m_scores = loadFile(m_scoresSource);
}
