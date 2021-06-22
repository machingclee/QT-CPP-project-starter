#include "backend.h"

Backend::Backend(QObject *parent) : QObject(parent)
{

}

void Backend::executeShellCommand(QString command)
{
    system(command.toStdString().c_str());
}

void Backend::executeShellCommands(QStringList commands)
{
    qInfo() << "commands" << commands;

    for(const QString &cmd : commands){
        qInfo() << "going to execute" << cmd;
        QFuture<void> future = QtConcurrent::run(this, &Backend::executeShellCommand, cmd);
    }
}

QString Backend::generateUUId()
{
    QUuid const id = QUuid::createUuid();
    return id.toString();
}
