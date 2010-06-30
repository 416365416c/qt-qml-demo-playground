#ifndef CUSTOMWIDGET_H
#define CUSTOMWIDGET_H

#include <QGraphicsProxyWidget>
#include <qdeclarative.h>

namespace Ui{
    class CustomWidget;
}

class QWidget;
class CustomWidget : public QGraphicsProxyWidget
{
    Q_OBJECT
public:
    explicit CustomWidget(QGraphicsObject *parent = 0);

private:
    Ui::CustomWidget *ui;
    QWidget* widget;

signals:

public slots:

};

QML_DECLARE_TYPE(CustomWidget);

#endif // CUSTOMWIDGET_H
