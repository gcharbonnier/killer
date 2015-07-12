#ifndef GPSLOGGER_H
#define GPSLOGGER_H

#include "gamedata.h"
#include "playermodel.h"
#include "messagemodel.h"
#include "campaignmanager.h"
#include "accountmanager.h"
#include "positionlogger.h"

#include <QTimer>




class GameManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(qreal direction      READ direction      NOTIFY directionChanged)
    Q_PROPERTY(QString campaignName      READ campaignName NOTIFY campaignNameChanged)

public:
    explicit GameManager(QObject *parent = 0);
    ~GameManager();

    PlayerModel& playerModel(){ return m_playerModel;}
    CampaignManager& campaignModel(){ return m_campaignManager;}
    AccountManager& accountModel() { return m_accountManager;}
    MessageModel& messageModel() { return m_messageModel;}

    qreal direction(){
        return m_gameData.lastDirection();
    }
    QString campaignName(){
        return m_gameData.campaignName();
    }
    Q_INVOKABLE bool startGame(uint idCampaign);
    Q_INVOKABLE bool stopGame();


signals:
    void playerModelChanged();
    void campaignModelChanged();
    void directionChanged();
    void campaignNameChanged();

    void killedBy(QString killer);
    void killed(QString victim);

public slots:

    bool shoot(int idTarget, bool shoot = true);



    int createCampaign(int type, QString name, uint nbTeam, uint idcampaignMod = 0){
        if (idcampaignMod)
            return m_campaignManager.modifyCampaign(idcampaignMod, m_accountManager.accountId(), static_cast<CampaignItem::Type>(type), name, nbTeam);
        else return m_campaignManager.createCampaign(m_accountManager.accountId(), static_cast<CampaignItem::Type>(type), name, nbTeam);
    }


private slots:
    void play();


private:
    void processEvent(int type, int emitter, QString option );
    void aknowledgeEvent(const std::vector<int>& lstEventId);



    GameData m_gameData;
    CampaignManager m_campaignManager;
    AccountManager m_accountManager;
    PlayerModel m_playerModel;
    PositionLogger m_positionLogger;
    MessageModel m_messageModel;



    QTimer* m_gameTimer = nullptr;

};

#endif // GPSLOGGER_H
