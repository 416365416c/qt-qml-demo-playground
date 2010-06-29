#ifndef CUSTOMWIDGET_H
#define CUSTOMWIDGET_H

#include <QGraphicsProxyWidget>
#include <qdeclarative.h>
#include "ui_customwidget.h"

class CustomWidget : public QGraphicsProxyWidget
{
    Q_OBJECT
public:
    explicit CustomWidget(QGraphicsObject *parent = 0);

private:
    Ui::KWStartupWidget widget;
};

QML_DECLARE_TYPE(CustomWidget);

#endif // CUSTOMWIDGET_H
