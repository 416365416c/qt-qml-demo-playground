#include "customwidget.h"
#include "ui_customwidget.h"

CustomWidget::CustomWidget(QGraphicsObject *parent) :
    QGraphicsProxyWidget(parent)
{
    ui = new Ui::CustomWidget;
    widget = new QWidget;
    ui->setupUi(widget);
    setWidget(widget);
}
