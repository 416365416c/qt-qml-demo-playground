#ifndef INTERFACE_H
#define INTERFACE_H

#include <QObject>

class Interface : public QObject
{
    Q_OBJECT
public:
    explicit Interface(QObject *parent = 0);

signals:

public slots:
    void process(const QString &str);
};

#endif // INTERFACE_H
