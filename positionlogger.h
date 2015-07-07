#ifndef POSITIONLOGGER_H
#define POSITIONLOGGER_H

#include <QObject>
#include <QMagnetometer>
#include <QOrientationSensor>
#include <QGeoPositionInfoSource>
#include "gamedata.h"

class PositionLogger : public QObject
{
    Q_OBJECT
public:
    explicit PositionLogger(GameData& gameData, QObject *parent = 0);
    ~PositionLogger();

    bool start();
    bool log();
    bool stop();
signals:
    void directionChanged();
    void positionChanged();
public slots:

private slots:
    void onMagnetoReadingChanged();
    void positionUpdated(const QGeoPositionInfo &info);
private:
    GameData& m_gameData;
    QGeoPositionInfo m_lastPosition = QGeoPositionInfo();
    qreal m_lastDirection = 0;

    static void changeAxis( qreal& X, qreal& Y, qreal& Z, int Orient);
    static qreal computeHeading( qreal AccX, qreal AccZ);

    QString constructPositionQuery(uint id_account, double latitude, double longitude, double altitude = 0.0, double heading = 0.0);
    QGeoPositionInfoSource* m_pPosSource = nullptr;
    QMagnetometer* m_magnetometer = nullptr;
    QOrientationSensor* m_orientation = nullptr;
};

#endif // POSITIONLOGGER_H
