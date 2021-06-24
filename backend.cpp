#include "backend.h"
using namespace std;

Backend::Backend(QObject* parent)
    : QObject(parent)
{
}

void Backend::executeShellCommand(const QString& command)
{
    QProcess process;
    QProcess rmScriptProcess;
    QString tmpFile;
    QString sh;
    QStringList args;

    QString augmentedCmd = QString("\"export PATH=/usr/local/bin:$PATH") + " && " + command + "\"";

    sh = "/bin/sh";
    tmpFile = generateUUId() + ".sh";
    args << "-c"
         << QString("echo " + augmentedCmd + " > /tmp/%1 && chmod +x /tmp/%1 && open -a Terminal /tmp/%1").arg(tmpFile);

    process.start(sh, args);
    process.waitForFinished();

    rmScriptProcess.start(sh, QStringList() << QString("rm /tmp/%1").arg(tmpFile));
    rmScriptProcess.waitForFinished();

    QString stdOut = process.readAllStandardOutput();
    QString stdError = process.readAllStandardError();

    qInfo() << "StdOut" << stdOut;
    qInfo() << "StdError" << stdError;
    return;
}

void Backend::executeShellCommands(const QStringList& commands)
{
    qInfo() << "commands" << commands;

    for (const QString& cmd : commands)
    {
        QtConcurrent::run(this, &Backend::executeShellCommand, cmd);
    }
}

QString Backend::generateUUId()
{
    QUuid const id = QUuid::createUuid();
    return id.toString();
}
