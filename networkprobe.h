#ifndef NETWORKPROBE_H
#define NETWORKPROBE_H

#include <QSqlDatabase>
#include <QNetworkInterface>

class NetworkProbe : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isNetworkAvailable      READ isNetworkAvailable      NOTIFY networkAvailableChanged)

public:
    NetworkProbe(QSqlDatabase* pDatabase);

    bool isNetworkAvailable(){ return bNetworkAvailable;}

signals:
    void networkAvailableChanged();

private:
    bool bNetworkAvailable = false;
    QSqlDatabase* m_pDatabase;
};

#endif // NETWORKPROBE_H
