#ifndef GPSLOGGER_H
#define GPSLOGGER_H

#include "gamedata.h"
#include "playermodel.h"
#include "messagemodel.h"
#include "campaignmanager.h"
#include "accountmanager.h"
#include "positionlogger.h"
#include "geolocalitemsmodel.h"

#include <QTimer>




class GameManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(qreal direction      READ direction      NOTIFY directionChanged)
    Q_PROPERTY(QString campaignName      READ campaignName NOTIFY campaignNameChanged)
    Q_PROPERTY(QGeoCoordinate lastPosition      READ lastPosition      NOTIFY lastPositionChanged)

public:
    explicit GameManager(QObject *parent = 0);
    ~GameManager();

    PlayerModel& playerModel(){ return m_playerModel;}
    CampaignManager& campaignModel(){ return m_campaignManager;}
    AccountManager& accountModel() { return m_accountManager;}
    MessageModel& messageModel() { return m_messageModel;}
    GeoLocalItemsModel& geoLocalItemsModel() { return m_geoLocalItemsModel;}

    qreal direction(){
        return m_gameData.lastDirection();
    }
    QGeoCoordinate lastPosition(){
        return m_gameData.lastPosition().coordinate();
    }
    QString campaignName(){
        return m_gameData.campaignName();
    }
    Q_INVOKABLE bool startGame(uint idCampaign);
    Q_INVOKABLE bool stopGame();

    Q_INVOKABLE bool setOffsetPosition(double Latitude, double Longitude){
        bool bValid = m_positionLogger.setOffsetPosition(Latitude, Longitude);
        QTimer::singleShot(1500, &m_geoLocalItemsModel, SLOT(resetModel()) );
        //m_geoLocalItemsModel.resetModel();
        return bValid;
    }

    Q_INVOKABLE QList<int> getStuffItemData( int IdStuff);

signals:
    void playerModelChanged();
    void campaignModelChanged();
    void directionChanged();
    void lastPositionChanged();
    void campaignNameChanged();
    void gameStarted();
    void gameStopped();

    void killedBy(QString killer);
    void killed(QString victim);

public slots:

    bool shoot(int idTarget, bool shoot = true);

    void simulateGPS(const QGeoCoordinate &info){
        QGeoPositionInfo geocoord(info, QDateTime::currentDateTime());
        m_positionLogger.positionUpdated(geocoord);
    }

    int createCampaign(int type, QString name, uint nbTeam, uint idcampaignMod = 0){
        if (idcampaignMod)
            return m_campaignManager.modifyCampaign(idcampaignMod, m_accountManager.accountId(), static_cast<CampaignItem::Type>(type), name, nbTeam);
        else return m_campaignManager.createCampaign(m_accountManager.accountId(), static_cast<CampaignItem::Type>(type), name, nbTeam);
    }

    bool saveStuffItem(int idStuff, int idQty, bool isSelected);


private slots:
    void play();


private:
    void processEvent(int type, int emitter, QString option );
    void aknowledgeEvent(const std::vector<int>& lstEventId);



    GameData m_gameData;
    AccountManager m_accountManager;
    CampaignManager m_campaignManager;
    PositionLogger m_positionLogger;
    PlayerModel m_playerModel;
    MessageModel m_messageModel;
    GeoLocalItemsModel m_geoLocalItemsModel;



    QTimer* m_gameTimer = nullptr;

};

#endif // GPSLOGGER_H
