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
    bool setOffsetPosition(double Latitude, double Longitude){
        bool bValid = false;
        if ((Latitude !=0.) || (Longitude!=0))
        {
            QGeoCoordinate offsetCoord = m_lastPosition.coordinate();
            offsetCoord.setLatitude( Latitude - offsetCoord.latitude());
            offsetCoord.setLongitude( Longitude - offsetCoord.longitude());
            m_offsetLatitude = offsetCoord.latitude();
            m_offsetLongitude = offsetCoord.longitude();
            bValid = true;
        }
        else
        {
            m_offsetLatitude = 0.;
            m_offsetLongitude = 0.;
        }

        positionUpdated( m_lastPosition);
        return bValid;
    }
signals:
    void directionChanged();
    void positionChanged();
public slots:
    void positionUpdated(const QGeoPositionInfo &info);

private slots:
    void onMagnetoReadingChanged();
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

    double m_offsetLatitude = 0.;
    double m_offsetLongitude = 0.;
};

#endif // POSITIONLOGGER_H
