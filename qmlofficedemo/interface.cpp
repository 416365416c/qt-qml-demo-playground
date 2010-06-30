#include "interface.h"
#include <QMessageBox>
Interface::Interface(QObject *parent) :
    QObject(parent)
{

}

void Interface::process(const QString &str){
    QMessageBox::information(qobject_cast<QWidget*>(parent()),"A message box", "I have no clue what to do with this input:\n"+str);
}
