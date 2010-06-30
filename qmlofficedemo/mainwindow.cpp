#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "customwidget.h"
#include <QtDeclarative>
#include "interface.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    qmlRegisterType<CustomWidget>("MyApp",1,0,"CustomWidget");
    Interface* interface = new Interface(this);
    ui->setupUi(this);
    ui->declarativeView->setSource(QUrl("./qml/main.qml"));
    ui->declarativeView->setFocus();
    ui->declarativeView->rootContext()->setContextObject(interface);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_actionQuit_triggered()
{
    qApp->quit();
}
