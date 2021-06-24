#ifndef BACKEND_H
#define BACKEND_H

#include <QDebug>
#include <QFuture>
#include <QObject>
#include <QProcess>
#include <QThreadPool>
#include <QUuid>
#include <QtConcurrent>
#include <stdio.h>
#include <stdlib.h>
class Backend : public QObject
{
    Q_OBJECT

//    Q_PROPERTY(string selectedProjectName READ name WRITE setName NOTIFY nameChanged)

public:
    explicit Backend(QObject *parent = nullptr);

signals:

public slots:
    void executeShellCommand(const QString& command);
    void executeShellCommands(const QStringList& commands);
    QString generateUUId();

};

#endif // BACKEND_H
