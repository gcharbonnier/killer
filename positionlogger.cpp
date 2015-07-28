#include "positionlogger.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

PositionLogger::PositionLogger(GameData& gameData, QObject *parent) : QObject(parent), m_gameData(gameData)
{
    //initialise sensors : gps, orientation and magnetometer
    m_pPosSource = QGeoPositionInfoSource::createDefaultSource(this);

    if (m_pPosSource && m_gameData.accountName()!="charby-dev")
    {
        connect( m_pPosSource, SIGNAL(positionUpdated(QGeoPositionInfo)),
                this, SLOT(positionUpdated(QGeoPositionInfo)));
        m_pPosSource->setUpdateInterval(0); //Default
        m_pPosSource->setPreferredPositioningMethods( QGeoPositionInfoSource::AllPositioningMethods);
    }

    m_orientation = new QOrientationSensor(this);
    m_magnetometer = new QMagnetometer(this);
    m_magnetometer->setReturnGeoValues(true);
    connect(m_magnetometer, SIGNAL(readingChanged()), this, SLOT(onMagnetoReadingChanged()));

}

PositionLogger::~PositionLogger()
{

}


bool PositionLogger::start()
{

    if (m_pPosSource  && m_gameData.accountName()!="charby-dev")
    {
        m_pPosSource->startUpdates();
        m_orientation->start();
        m_magnetometer->start();
        m_orientation->setActive(true);
        m_magnetometer->setActive(true);
    }
    else{
        //write default position (dev)
        positionUpdated( QGeoPositionInfo( QGeoCoordinate(47.096412, -1.636881, 8), QDateTime::currentDateTime()) );
        log();
    }

    return true;
}

bool PositionLogger::stop()
{
    bool bValid = false;
    if (m_pPosSource)
    {
        m_pPosSource->stopUpdates();
        m_orientation->stop();
        m_magnetometer->stop();
        m_orientation->setActive(false);
        m_magnetometer->setActive(false);

        bValid = true;
    }
    return bValid;
}


void PositionLogger::onMagnetoReadingChanged()
{

    static const int MaxSamples = 5;

    static bool bufferReady = false;
    static int count = 0;

    static qreal m_magReading[MaxSamples*3] ={0};


    QMagnetometerReading* reading = m_magnetometer->reading();

    if (!reading) return;
    if (!m_magnetometer->isActive() || m_magnetometer->isBusy()) return;

    m_magReading[3*count] = reading->x();
    m_magReading[3*count+1] = reading->y();
    m_magReading[3*count+2] = reading->z();

    count++;
    if (count > MaxSamples) {
        count = 0;
        bufferReady = true;
    }

    if (!bufferReady) return;

    //compute mean values over the last MAX_SAMPLES
    qreal meanX = 0., meanY = 0., meanZ = 0.;
    for (int i=0; i < MaxSamples; i++) {
        meanX += m_magReading[3*i];
        meanY += m_magReading[3*i+1];
        meanZ += m_magReading[3*i+2];
    }



    if (m_orientation && m_orientation->reading() && m_orientation->reading()->orientation())
        changeAxis(meanX, meanY, meanZ, m_orientation->reading()->orientation());

    m_lastDirection = computeHeading( meanX, meanZ);
    m_gameData.setLastDirection( m_lastDirection );

    emit directionChanged();


}

void PositionLogger::changeAxis( qreal& X, qreal& Y, qreal& Z, int Orient)
{
    qreal newX = 0, newY= 0, newZ = 0;
    switch (Orient)
    {
        case QOrientationReading::LeftUp:
        case QOrientationReading::RightUp:
            newX = -Y;
            newY = X;
            newZ = -Z;
            break;
        case QOrientationReading::FaceDown:
        case QOrientationReading::FaceUp:
            newX = -Y;
            newY = Z;
            newZ = -X;
            break;
        case QOrientationReading::TopDown:
        case QOrientationReading::Undefined:
        case QOrientationReading::TopUp:
            newX = X;
            newY = Y;
            newZ = -Z;//Z;
            break;
        default:
            break;
    }
    X = newX;
    Y = newY;
    Z = newZ;
}


qreal PositionLogger::computeHeading( qreal AccX, qreal AccZ)
{
    const float rad2deg = 57.2957795;
    qreal heading = 0;
    if ( AccZ!=0)
    {
        heading = atan( AccX / AccZ) * rad2deg;
        if (AccZ < 0)
            heading += 180;
    }
    return heading;
}

void PositionLogger::positionUpdated(const QGeoPositionInfo &info)
{
    m_lastPosition = info;
    if ( (m_offsetLatitude != 0) ||  (m_offsetLongitude != 0))
    {
        QGeoCoordinate offsetedCoord = m_lastPosition.coordinate();
        offsetedCoord.setLatitude( offsetedCoord.latitude() + m_offsetLatitude);
        offsetedCoord.setLongitude( offsetedCoord.longitude() + m_offsetLongitude);
        m_lastPosition.setCoordinate( offsetedCoord);
    }
    m_gameData.setLastPosition( m_lastPosition );
    emit positionChanged();
    log();
}

QString PositionLogger::constructPositionQuery(uint id_account, double latitude, double longitude, double altitude, double heading)
{
    QString str = QString("UPDATE  `simplisim_dejavu`.`geo_players` SET  `LATITUDE` =  '%1',\
                          `LONGITUDE` =  '%2', \
                          `ALTITUDE` =  '%3', \
                          `HEADING` =  '%4' \
                          WHERE  `geo_players`.`ID_ACCOUNT` =%5;")
            .arg( latitude)
            .arg( longitude)
            .arg( altitude)
            .arg( heading)
            .arg( id_account);

    return str;
}


bool PositionLogger::log()
{
    QSqlQuery query;
    QGeoCoordinate lastPos = m_lastPosition.coordinate();

    QString str = constructPositionQuery( m_gameData.accountId(), lastPos.latitude(), lastPos.longitude(), lastPos.type() == QGeoCoordinate::Coordinate3D ? lastPos.altitude() : 0., m_lastDirection );
    bool ok = query.exec( str );
    if (!ok)
    {
        qDebug() << "Error with query : "<< str;
        qDebug() << "last error : " << query.lastError();

    }



    return true;
}
