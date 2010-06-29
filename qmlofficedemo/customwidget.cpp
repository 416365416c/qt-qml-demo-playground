#include "customwidget.h"

CustomWidget::CustomWidget(QGraphicsObject *parent) :
    QGraphicsProxyWidget(parent)
{
    QWidget *qw = new QWidget;
    widget.setupUi(qw);
    setWidget(qw);
}
