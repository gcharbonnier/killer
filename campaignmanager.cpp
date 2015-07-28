#include "campaignmanager.h"
#include <QSqlQuery>
#include <QSqlRecord>
#include <QVariant>


QVariant CampaignItem::getRole(int role) const
{
    switch (role)
    {
        case Roles::RoleIdcampaign:
            return m_id;
            break;
        case Roles::RoleName:
            return m_name;
            break;
        case Roles::RoleType:
            return m_type;
            break;
        case Roles::RoleNbTeam:
            return m_nbTeam;
        case Roles::RoleNbPlayers:
            return m_nbPlayers;
        case Roles::RoleIsMyCampaign:
            return m_gameData.accountId() == m_owner;
        case Roles::RoleAmIConnected:
            return m_isConnected;

    default:
        return QVariant();
    }
}


CampaignManager::CampaignManager(GameData& gameData, QObject *parent) : QAbstractListModel(parent), m_gameData( gameData)
{




}

CampaignManager::~CampaignManager()
{

}

int CampaignManager::createCampaign(uint owner, CampaignItem::Type type, QString name, uint nbTeam)
{
    uint id = 0;

    QString req = QString("INSERT INTO `simplisim_dejavu`.`geo_campaign` (`ID`, `ID_OWNER`, `TYPE`, `AREA_CENTER_LATITUDE`, `AREA_CENTER_LONGITUDE`, `NAME`, `RADIUS`, `NBTEAM`) VALUES (NULL, '%1', '%2', '%3', '%4', '%5', '%6', '%7')")
            .arg(owner).arg(type).arg(0.0).arg(0.0).arg(name).arg(5000).arg(nbTeam);
    QSqlQuery query;
    if (query.exec(  req ))
    {
        QVariant res = query.lastInsertId();
        if ( res.isValid() )
        {
            id = res.toUInt();
            resetModel();
            //joinCampaign(idTeam, owner);
        }
    }

    return id;
}
bool CampaignManager::modifyCampaign(uint id, uint owner, CampaignItem::Type type, QString name, uint nbTeam)
{
    QString req = QString("REPLACE INTO `simplisim_dejavu`.`geo_campaign` (`ID`, `ID_OWNER`, `TYPE`, `AREA_CENTER_LATITUDE`, `AREA_CENTER_LONGITUDE`, `NAME`, `RADIUS`, `NBTEAM`) VALUES ('%8', '%1', '%2', '%3', '%4', '%5', '%6', '%7')")
            .arg(owner).arg(type).arg(0.0).arg(0.0).arg(name).arg(5000).arg(nbTeam).arg(id);
    QSqlQuery query;
    if (query.exec(  req ))
    {
        resetModel();
        return true;
    }

    return false;
}


bool CampaignManager::deleteCampaign(uint idcampaign)
{
    QString req = QString("DELETE FROM `simplisim_dejavu`.`geo_campaign` WHERE `geo_campaign`.`ID` = %1").arg(idcampaign);
    QSqlQuery query;

    bool bRet = query.exec(  req );

    //TODO also remove participants of the deleted campaign
    resetModel();
    return bRet;
}

uint CampaignManager::joinCampaign(uint idcampaign, uint idPlayer)
{

    int numTeam = 0;//TODO
    QString req = QString("INSERT INTO  `simplisim_dejavu`.`geo_participants` \
                            ( `ID_ACCOUNT` ,`ID_CAMPAIGN` ,`TEAM`) \
                     VALUES ('%1',  '%2',  '%3')")
            .arg(idPlayer).arg(idcampaign).arg(numTeam);
    QSqlQuery query;
    if (query.exec(  req ))
    {
        resetModel();
    }

    //TODO update assignements of targets

    return 0;
}

uint CampaignManager::leaveCampaign(uint idcampaign, uint idPlayer)
{
    QString req = QString("DELETE FROM `simplisim_dejavu`.`geo_participants` \
                                WHERE `geo_participants`.`ID_ACCOUNT` = %1 AND `geo_participants`.`ID_CAMPAIGN` = %2")
            .arg(idPlayer).arg(idcampaign);
    QSqlQuery query;

    //TODO update reassignements of targets
    bool bRet = query.exec(  req );
    resetModel();
    return bRet;
}

QVariant CampaignManager::findCampaignData(uint idCampaign, CampaignItem::Roles role)
{
    QVariant data;
    for (CampaignItem camp:m_lstValues)
    {
        if (camp.getRole( CampaignItem::RoleIdcampaign) == idCampaign)
            return camp.getRole( role);
    }
    return data;
}


void CampaignManager::setCurrentCampaign( uint idCampaign)
{
    //load campaign data
    m_gameData.setcampaignData(idCampaign, findCampaignData( idCampaign, CampaignItem::RoleName ).toString());
}

QHash<int, QByteArray> CampaignManager::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[CampaignItem::RoleIdcampaign] = "idcampaign";
    roles[CampaignItem::RoleName] = "name";
    roles[CampaignItem::RoleType] = "type";
    roles[CampaignItem::RoleNbTeam] = "nbTeam";
    roles[CampaignItem::RoleNbPlayers] = "nbPlayers";
    roles[CampaignItem::RoleIsMyCampaign] = "isMyCampaign";
    roles[CampaignItem::RoleAmIConnected] = "AmIConnected";

    return roles;

}

Qt::ItemFlags CampaignManager::flags(const QModelIndex &index) const
{
    Q_UNUSED(index);
    return Qt::ItemIsEditable;

}

int CampaignManager::rowCount(const QModelIndex & parent) const
{
    Q_UNUSED(parent);
    return m_lstValues.size();
}

QVariant CampaignManager::data( const QModelIndex & index, int role ) const
{
    if ( (index.row() < 0) || (index.row() >= rowCount()) )
        return QVariant();

    return m_lstValues[ index.row()].getRole( role);

}

void CampaignManager::resetModel()
{
    beginResetModel();
    m_lstValues.clear();

    QSqlQuery query;
    QString req = QString("select sub1.*, (pions2.ID_ACCOUNT = %1) as Connected from (select pty.*, count(pions.ID_CAMPAIGN) as NbPlayers from geo_campaign as pty \
                          left join geo_participants as pions\
                          on pty.id = pions.ID_CAMPAIGN\
                          group by pty.id) as sub1\
                          left join (select i_pty.id,i_pions.ID_ACCOUNT from geo_campaign as i_pty\
                          left join geo_participants as i_pions\
                          on i_pty.id = i_pions.ID_CAMPAIGN\
                          where i_pions.ID_ACCOUNT = %1 ) as pions2\
                          on pions2.id = sub1.id").arg( m_gameData.accountId() );
    query.exec( req );
                //"SELECT geo_campaign.*,  count(ID_ACCOUNT) as NbPlayer FROM  `geo_campaign` LEFT JOIN `geo_participants` on ID_CAMPAIGN = ID  group by ID");


    int indId = query.record().indexOf("ID");
    int indLat = query.record().indexOf("AREA_CENTER_LATITUDE");
    int indLong = query.record().indexOf("AREA_CENTER_LONGITUDE");
    int indName = query.record().indexOf("NAME");
    int indRadius = query.record().indexOf("RADIUS");
    int indNbTeam = query.record().indexOf("NBTEAM");
    int indOwner = query.record().indexOf("ID_OWNER");
    int indType = query.record().indexOf("TYPE");
    int indNbPlayer = query.record().indexOf("NbPlayers");
    int indConnected = query.record().indexOf("Connected");
    while (query.next())
    {
       uint Id = query.value( indId ).toUInt();
       QString Name = query.value( indName ).toString();
       double lat = query.value( indLat ).toDouble();
       double lgt = query.value( indLong ).toDouble();
       uint radius = query.value( indRadius ).toUInt();
       uint nbTeam = query.value( indNbTeam ).toUInt();
       uint type = query.value( indType ).toUInt();
       uint owner = query.value( indOwner ).toUInt();
       uint nbPlayers = query.value( indNbPlayer ).toUInt();
       bool connected = query.value( indConnected ).toBool();

       m_lstValues.push_back( CampaignItem( m_gameData, Id, Name, lat, lgt, radius, nbTeam, static_cast<CampaignItem::Type>(type), owner, nbPlayers, connected ) );
    }

    //
    //emit dataChanged( createIndex(0,0), createIndex(m_lstValues.size(), 3));
    endResetModel();

}
