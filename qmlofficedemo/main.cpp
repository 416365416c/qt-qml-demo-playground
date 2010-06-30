#include <QtGui/QApplication>
#include "mainwindow.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    a.setGraphicsSystem("raster");
    MainWindow w;
    w.show();

    return a.exec();
}
