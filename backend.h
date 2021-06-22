#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <stdio.h>
#include <stdlib.h>
#include <QDebug>
#include <QThreadPool>
#include <QtConcurrent>
#include <QFuture>
#include <QUuid>

class Backend : public QObject
{
    Q_OBJECT

//    Q_PROPERTY(string selectedProjectName READ name WRITE setName NOTIFY nameChanged)

public:
    explicit Backend(QObject *parent = nullptr);

signals:

public slots:
    void executeShellCommand(QString command);
    void executeShellCommands(QStringList commands);
    QString generateUUId();

};

#endif // BACKEND_H
