#ifndef BACKEND_H
#define BACKEND_H

#include <QDebug>
#include <QProcess>
#include <QUuid>
#include <QtConcurrent>

class Backend : public QObject
{
    Q_OBJECT

    //    Q_PROPERTY(string selectedProjectName READ name WRITE setName NOTIFY nameChanged)

public:
    explicit Backend(QObject *parent = nullptr);

signals:

public slots:
    void executeShellCommand(const QString& command);
    void executeShellCommands(const QJsonArray& commands);
    QString generateUUId();

};

#endif // BACKEND_H
