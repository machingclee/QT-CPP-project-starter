#include "backend.h"

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

    QString augmentedCmd = "\"" + QString(+"export PATH=/usr/local/bin:$PATH") + QString(" && ") + command + "\"";
    qInfo() << "the augmentedCmd" << augmentedCmd;

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

void Backend::executeShellCommands(const QJsonArray& commands)
{
    qInfo() << "commands" << commands;
    foreach (const QJsonValue& value, commands)
    {
        QJsonObject obj = value.toObject();
        QString dirPath = obj.value("dirPath").toString();
        QString cmd = obj.value("cmd").toString();

        QString finalCommand;
        finalCommand = QString("cd ") + QString("'") + dirPath + QString("'");
        finalCommand = finalCommand + QString(" && code -n ") + QString("'") + dirPath + QString("'");
        if (!cmd.isEmpty() && !cmd.isNull())
        {
            finalCommand = QString(finalCommand + " && " + cmd);
        }

        QtConcurrent::run(this, &Backend::executeShellCommand, finalCommand);
    }
}

QString Backend::generateUUId()
{
    QUuid const id = QUuid::createUuid();
    return id.toString();
}
