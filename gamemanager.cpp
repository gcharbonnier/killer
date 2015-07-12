#include "gamemanager.h"

#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>


GameManager::GameManager(QObject *parent) : QObject(parent), m_gameData(),
            m_accountManager(m_gameData),m_campaignManager(m_gameData), m_positionLogger(m_gameData), m_playerModel(m_gameData), m_messageModel(m_gameData)
{


    m_gameTimer = new QTimer(this);
    connect( m_gameTimer, SIGNAL( timeout()), this, SLOT( play()));


}

GameManager::~GameManager()
{
}

bool GameManager::startGame(uint idCampaign)
{
    m_campaignManager.joinCampaign( idCampaign, m_accountManager.accountId());
    m_campaignManager.setCurrentCampaign( idCampaign);
    m_positionLogger.start();

    //Notify the others players using the intercom
    m_messageModel.sendSystemMessage( m_gameData.accountName() + " joined the campaign");

    m_gameTimer->start(1000);

    m_playerModel.resetModel();
    m_messageModel.resetModel();

    emit campaignNameChanged();
    return true;
}

bool GameManager::stopGame()
{
    //Notify the others players using the intercom
    m_messageModel.sendSystemMessage( m_gameData.accountName() + " left the campaign");

    m_campaignManager.leaveCampaign(m_gameData.campaignId(), m_accountManager.accountId());
    m_campaignManager.setCurrentCampaign( 0);
    m_positionLogger.stop();

    m_gameTimer->stop();
    emit campaignNameChanged();
    return true;
}


void GameManager::play()
{
    //update players model
    m_playerModel.updateModel();
    m_messageModel.updateModel();

    //Read events
    QString str = QString("SELECT *  FROM `geo_events` WHERE `RECIPIENT` IN (%1,0) AND `PROCESSED` = 0")

            .arg( m_gameData.accountId() );
    QSqlQuery query(str);

    std::vector<int> lstEventId;
    while (query.next())
    {
            int id = query.value(0).toInt();
            lstEventId.push_back( id);
            int type = query.value(1).toInt();

            int emitter = query.value(2).toInt();
            QString options = query.value(4).toString();
            processEvent(type, emitter, options);
    }
    //Set the processed flag to the read event
    aknowledgeEvent( lstEventId);
    //TODO : handle the case of the broadcast event (timeout)
}

void GameManager::processEvent(int type, int emitter, QString option )
{
    //retrieve emitter data
    PlayerData emitterData = m_playerModel.getPlayerData( emitter);
    if (emitterData.ID != 0)
    {
        switch (type)
        {
        case 1: //SHOOT (by someone)
            shoot( emitter, false);
            emit killedBy( emitterData.NamePlayer );
            break;
        case 2: //(someone has been) KILLED (by us)
            emit killed( emitterData.NamePlayer );
            break;
        }
    }

}

void GameManager::aknowledgeEvent(const std::vector<int>& lstEventId)
{

    QString sLstEventId ="";
    int i=0;
    for (auto id:lstEventId)
    {
        if ( i>0 )
            sLstEventId += QString(",%1").arg(id);
        else sLstEventId += QString("%1").arg(id);
        i++;
    }

    //Read events
    QString str = QString("UPDATE  `simplisim_dejavu`.`geo_events` SET  `PROCESSED` =  '1',`ProcessedTime` = NOW( ) WHERE  `geo_events`.`ID` IN(%1);")
            .arg( sLstEventId);
    QSqlQuery query(str);



}


bool GameManager::shoot(int idTarget, bool shoot)
{
    int action = 1;//SHOOT
    if (!shoot) action = 2;//"KILLED";
    QString str = QString("INSERT INTO  `simplisim_dejavu`.`geo_events` (`ID` ,`TYPE`, `EMITTER` ,`RECIPIENT` ,`OPTIONS` ,`PROCESSED`) VALUES ( NULL ,  '%1',  '%2',  '%3', '',  '0')")
            .arg( action).arg( m_gameData.accountId() ).arg( idTarget);
    QSqlQuery query;
    return query.exec( str );
}




