#ifndef LETTERS_H
#define LETTERS_H

#include <QObject>
#include <QHash>
#include <QUrl>

class Letters : public QObject
{
    Q_OBJECT
    //A file with each line of the form '<character> <frequency>'. Frequencies are relative weightings, but it's usally easiest to make them 0-1 probabilites
    Q_PROPERTY(QUrl frequenciesSource READ frequenciesSource WRITE setFrequenciesSource NOTIFY frequenciesSourceChanged)
    //A file with each line of the form '<character> <points-value>'. If a character is not in that file then it scores 1 point.
    Q_PROPERTY(QUrl scoresSource READ scoresSource WRITE setScoresSource NOTIFY scoresSourceChanged)
public:
    //Returns a string 'number' characters long. Each character is chosen from the specified frequency list. If no list is set, always returns 'a's.
    Q_INVOKABLE QString generateCharacters(int number);
    //Scores a word based on the specifed score file.
    Q_INVOKABLE qreal scoreWord(QString word);
//End of QML API

    explicit Letters(QObject *parent = 0);

    QUrl frequenciesSource() const
    {
        return m_frequenciesSource;
    }

    QUrl scoresSource() const
    {
        return m_scoresSource;
    }

signals:

    void frequenciesSourceChanged(QUrl arg);
    void scoresSourceChanged(QUrl arg);

public slots:

void setFrequenciesSource(QUrl arg)
{
    if (m_frequenciesSource != arg) {
        m_frequenciesSource = arg;
        m_frequenciesChanged = true;
        emit frequenciesSourceChanged(arg);
    }
}

void setScoresSource(QUrl arg)
{
    if (m_scoresSource != arg) {
        m_scoresSource = arg;
        m_scoresChanged = true;
        emit scoresSourceChanged(arg);
    }
}

private:
void generateFrequencies();
void generateScores();
bool m_frequenciesChanged;
bool m_scoresChanged;

QUrl m_frequenciesSource;
QUrl m_scoresSource;
QHash<QChar, qreal> m_frequencies;
QHash<QChar, qreal> m_scores;
};

#endif // LETTERS_H
