#include "gamemanager.h"

#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>


GameManager::GameManager(QObject *parent) : QObject(parent), m_gameData(),
            m_accountManager(m_gameData),m_campaignManager(m_gameData), m_positionLogger(m_gameData), m_playerModel(m_gameData), m_messageModel(m_gameData), m_geoLocalItemsModel(m_gameData)
{


    m_gameTimer = new QTimer(this);
    connect( m_gameTimer, SIGNAL( timeout()), this, SLOT( play()));

    connect( &m_positionLogger, SIGNAL(directionChanged()), this, SIGNAL(directionChanged()) );
    connect( &m_positionLogger, SIGNAL(positionChanged()), this, SIGNAL(lastPositionChanged()) );

}

GameManager::~GameManager()
{
}

bool GameManager::startGame(uint idCampaign)
{
    m_campaignManager.joinCampaign( idCampaign, m_accountManager.accountId());
    m_campaignManager.setCurrentCampaign( idCampaign);

    //Remove unprocessed events
    //Read events
    QString str = QString("DELETE FROM  `simplisim_dejavu`.`geo_events` WHERE ( \
        `EMITTER` =%1 OR  `RECIPIENT` =%1 ) AND  `PROCESSED` =0").arg( m_gameData.accountId() );
    QSqlQuery query(str);
    query.exec();

    m_positionLogger.start();

    //Notify the others players using the intercom
    m_messageModel.sendSystemMessage( m_gameData.accountName() + " joined the campaign");

    m_gameTimer->start(3000);

    m_playerModel.resetModel();
    m_messageModel.resetModel();
    m_geoLocalItemsModel.resetModel(); //QTimer::singleShot(1000, &m_geoLocalItemsModel, SLOT(resetModel()) );


    emit campaignNameChanged();
    emit gameStarted();
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
    emit gameStopped();
    return true;
}


void GameManager::play()
{
    static long nbTic = 0;
    nbTic++;

    //update players model
    m_playerModel.resetModel();//m_playerModel.updateModel(); //bug Qt with dataSignal for MapViewItem
    if (nbTic % 2 == 0)
        m_messageModel.updateModel();
    //if (nbTic > 10)
        m_geoLocalItemsModel.checkForEnergyAround();

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
    Q_UNUSED(option)
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

bool GameManager::saveStuffItem(int idStuff, int idQty, bool isSelected)
{
    QString str = QString("replace INTO  `simplisim_dejavu`.`geo_stuff` ( `ID_PLAYER` ,`ID_STUFF` , `QTY` , `SELECTED`) \
                          VALUES ('%1',  '%2',  '%3',  '%4' );")
            .arg( m_gameData.accountId() ).arg(idStuff).arg( idQty ).arg(isSelected ? 1 : 0);
    QSqlQuery query;
    return query.exec( str );


}

QList<int> GameManager::getStuffItemData( int IdStuff){
    QList<int> stuffData = QList<int>();

    int IsSelected = -1;
    int Qty = -1;
    //Retrieve stuffitem from db
    QString str = QString("SELECT *  FROM `geo_stuff` WHERE `ID_PLAYER` = %1 AND `ID_STUFF` = %2")
            .arg( m_gameData.accountId() ).arg( IdStuff);
    QSqlQuery query(str);

    if (query.next())
    {
            Qty= query.value(2).toInt();
            IsSelected = query.value(3).toInt();
    }

    stuffData.append(Qty);
    stuffData.append(IsSelected);

    return stuffData;
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




