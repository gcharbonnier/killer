#include <QDebug>
#include "playermodel.h"

#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>


QVariant PlayerData::getRole(int role) const
{
    switch (role)
    {
        case Roles::RoleId:
            return ID;
            break;
        case Roles::RoleDistance:
            return Distance;
            break;
        case Roles::RoleBearing:
            return Bearing;
            break;
        case Roles::RoleType:
            return Type;
        case Roles::RoleAzimuth:
            return Azimuth;
        case Roles::RoleLatitude:
            return Latitude;
        case Roles::RoleLongitude:
            return Longitude;
        case Roles::RoleNamePlayer:
            return NamePlayer;
        case Roles::RoleHealth:
            return Health;
        case Roles::RoleEnergy:
            return Energy;
        case Roles::RoleXP:
            return Xp;
        case Roles::RoleCredits:
            return Credits;
        case Roles::RoleLevel:
            return Level;



    default:
        return QVariant();
    }
}

PlayerModel::PlayerModel(GameData& gameData) :m_gameData( gameData)
{

}

PlayerModel::~PlayerModel()
{

}

int PlayerModel::rowCount(const QModelIndex & parent) const
{
    Q_UNUSED(parent);
    return m_lstValues.size();
}

QVariant PlayerModel::data( const QModelIndex & index, int role ) const
{
    if ( (index.row() < 0) || (index.row() >= rowCount()) )
        return QVariant();

    return m_lstValues[ index.row()].getRole( role);

}

void PlayerModel::resetModel()
{
    beginResetModel();

    m_lstValues.clear();
    m_maxDistance = std::numeric_limits<int>::min();
    QSqlQuery query;
    QString req = QString("SELECT geo_players.* , LOGIN, TEAM, CONNECTED FROM  `geo_accounts` , geo_players, geo_participants \
            WHERE ID = geo_players.ID_ACCOUNT AND ID = geo_participants.ID_ACCOUNT AND ID_CAMPAIGN = %1").arg( m_gameData.campaignId());
    query.exec( req);
    int indId = query.record().indexOf("ID_ACCOUNT");
    int indName = query.record().indexOf("LOGIN");
    int indLat = query.record().indexOf("LATITUDE");
    int indLong = query.record().indexOf("LONGITUDE");
    int indAlt = query.record().indexOf("ALTITUDE");
    int indHeading = query.record().indexOf("HEADING");

    int indHealth = query.record().indexOf("HEALTH");
    int indCredits = query.record().indexOf("CREDITS");
    int indXp = query.record().indexOf("XP");
    int indEnergy = query.record().indexOf("ENERGY");
    int indLevel = query.record().indexOf("LEVEL");

    while (query.next())
    {
       int Id = query.value( indId ).toInt();
       //if (Id == m_gameData.accountId())
       //    continue;
       QString name = query.value( indName ).toString();
       //compute distance
       double lat = query.value( indLat ).toDouble();
       double lgt = query.value( indLong ).toDouble();
       double alt = query.value( indAlt ).toDouble();
       double hdg = query.value( indHeading ).toDouble();

       uint health = query.value( indHealth ).toUInt();
       uint credits = query.value( indCredits ).toUInt();
       uint xp = query.value( indXp ).toUInt();
       uint energy = query.value( indEnergy ).toUInt();
       uint level = query.value( indLevel ).toUInt();

       QGeoCoordinate coord = QGeoCoordinate( lat, lgt, alt);
       int azimuth = m_gameData.lastPosition().coordinate().azimuthTo( coord);
       int distance = m_gameData.lastPosition().coordinate().distanceTo( coord);
       m_maxDistance = std::max(distance, m_maxDistance);
       m_lstValues.push_back( PlayerData(Id, name, distance, azimuth, int(alt), int(hdg), lat, lgt, health, energy, xp, credits, level ));

    }
    endResetModel();

}

QModelIndex PlayerModel::indexFromIdPlayer(int idPlayer)
{
    int row = 0;
    for (PlayerData player : m_lstValues )
    {
        if (idPlayer == static_cast<int>( player.ID ))
            return index(row);
        row++;
    }
    return QModelIndex();

}

void PlayerModel::updateModel()
{
    std::vector<int> lstActivePlayers = std::vector<int>();

    //m_lstValues.clear();
    m_maxDistance = std::numeric_limits<int>::min();
    QSqlQuery query;
    QString req = QString("SELECT geo_players.* , LOGIN, TEAM, CONNECTED FROM  `geo_accounts` , geo_players, geo_participants \
            WHERE ID = geo_players.ID_ACCOUNT AND ID = geo_participants.ID_ACCOUNT AND ID_CAMPAIGN = %1").arg( m_gameData.campaignId());
    query.exec( req);
    int indId = query.record().indexOf("ID_ACCOUNT");
    int indName = query.record().indexOf("LOGIN");
    int indLat = query.record().indexOf("LATITUDE");
    int indLong = query.record().indexOf("LONGITUDE");
    int indAlt = query.record().indexOf("ALTITUDE");
    int indHeading = query.record().indexOf("HEADING");
    int indHealth = query.record().indexOf("HEALTH");
    int indCredits = query.record().indexOf("CREDITS");
    int indXp = query.record().indexOf("XP");
    int indEnergy = query.record().indexOf("ENERGY");
    int indLevel = query.record().indexOf("LEVEL");
    while (query.next())
    {
       PlayerData player;
       player.ID = query.value( indId ).toInt();
       player.Bearing = query.value( indHeading ).toDouble();
       player.Latitude = query.value( indLat ).toDouble();
       player.Longitude = query.value( indLong ).toDouble();
       player.NamePlayer = query.value( indName ).toString();
       double alt = query.value( indAlt ).toDouble();
       QGeoCoordinate coord = QGeoCoordinate( player.Latitude, player.Longitude, alt);
       player.Distance = m_gameData.lastPosition().coordinate().distanceTo( coord);
       player.Azimuth = m_gameData.lastPosition().coordinate().azimuthTo( coord);

       player.Health = query.value( indHealth ).toUInt();
       player.Credits = query.value( indCredits ).toUInt();
       player.Xp = query.value( indXp ).toUInt();
       player.Energy = query.value( indEnergy ).toUInt();
       player.Level = query.value( indLevel ).toUInt();

       m_maxDistance = std::max( player.Distance , m_maxDistance);

       //update the list of active players
       lstActivePlayers.push_back( player.ID);

       QModelIndex index = indexFromIdPlayer( player.ID);


       //Case 1: new player not already existing in the model
       if ( !index.isValid() )
       {
           int row = rowCount();
           beginInsertRows(QModelIndex(), row, row);
           m_lstValues.push_back( player);
           endInsertRows();
           emit newPlayer(player.NamePlayer);

       }
       //Case 2 : existing player, update if necessary
       else
       {
           setData( index, player.Distance, PlayerData::RoleDistance);
           setData( index, player.Bearing, PlayerData::RoleBearing);
           setData( index, player.Type, PlayerData::RoleType);
           //setData( index, player.Azimuth, PlayerData::RoleAzimuth);
           setData( index, player.Latitude, PlayerData::RoleLatitude);
           setData( index, player.Longitude, PlayerData::RoleLongitude);
           setData( index, player.NamePlayer, PlayerData::RoleNamePlayer);

           setData( index, player.Health, PlayerData::RoleHealth);
           setData( index, player.Credits, PlayerData::RoleCredits);
           setData( index, player.Xp, PlayerData::RoleXP);
           setData( index, player.Energy, PlayerData::RoleEnergy);
           setData( index, player.Level, PlayerData::RoleLevel);

       }

    }

    //Test update
    int row = 0;
    for (PlayerData player : m_lstValues)
    {
        setData( index(row), (player.Azimuth + 1) % 180, PlayerData::RoleAzimuth);
        row++;
    }


    //remove players from the model that are not active anymore
    purgePlayers(lstActivePlayers);
}


void PlayerModel::purgePlayers(const std::vector<int>& lstPlayersIdToKeep)
{
    int row = 0;
    for (PlayerData player : m_lstValues)
    {
        bool bFound = false;
        for (int idplayer : lstPlayersIdToKeep)
        {
            if ( idplayer == static_cast<int>( player.ID ))
                bFound = true;
        }
        if (!bFound)
        {
            emit playerLeave( player.NamePlayer);
            removeRows( row, 1);

        }

        row++;

    }
}

bool PlayerModel::setData(const QModelIndex & index, const QVariant & value, int role)
{
    if ( (index.row() < 0) || (index.row() >= rowCount()) ) return false;

    QVariant oldValue = data( index, role);
    if ( value == oldValue) return false;

    PlayerData& player = m_lstValues[ index.row() ];
    switch (role)
    {
        case PlayerData::RoleId:
            player.ID = value.toInt();
            break;
        case PlayerData::RoleDistance:
            player.Distance = value.toInt();
            break;
        case PlayerData::RoleBearing:
            player.Bearing = value.toInt();
            break;
        case PlayerData::RoleType:
            player.Type = value.toInt();
            break;
        case PlayerData::RoleAzimuth:
            player.Azimuth = value.toInt();
            break;
        case PlayerData::RoleLatitude:
            player.Latitude = value.toDouble();
            break;
        case PlayerData::RoleLongitude:
            player.Longitude = value.toDouble();
            break;
        case PlayerData::RoleNamePlayer:
            player.NamePlayer = value.toString();
            break;
    case PlayerData::RoleHealth:
        player.Health = value.toUInt();
        break;
    case PlayerData::RoleXP:
        player.Xp = value.toUInt();
        break;
    case PlayerData::RoleCredits:
        player.Credits = value.toUInt();
        break;
    case PlayerData::RoleEnergy:
        player.Energy = value.toUInt();
        break;
    case PlayerData::RoleLevel:
        player.Level = value.toUInt();
        break;


    }
    emit dataChanged(index, index );//, QVector<int>( role));

    return true;
}

bool PlayerModel::removeRows(int row, int count, const QModelIndex & parent)
{
    Q_UNUSED( parent);
    beginRemoveRows(QModelIndex(), row, row + (count -1));
    m_lstValues.remove( row, count);
    endRemoveRows();
    return true;
}

QHash<int, QByteArray> PlayerModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[PlayerData::Roles::RoleId] = "IdPlayer";
    roles[PlayerData::Roles::RoleNamePlayer] = "NamePlayer";
    roles[PlayerData::Roles::RoleDistance] = "Distance";
    roles[PlayerData::Roles::RoleAzimuth] = "Azimuth";
    roles[PlayerData::Roles::RoleBearing] = "Bearing";
    roles[PlayerData::Roles::RoleType] = "Type";
    roles[PlayerData::Roles::RoleLatitude] = "Latitude";
    roles[PlayerData::Roles::RoleLongitude] = "Longitude";

    roles[PlayerData::Roles::RoleHealth] = "Health";
    roles[PlayerData::Roles::RoleCredits] = "Credits";
    roles[PlayerData::Roles::RoleEnergy] = "Energy";
    roles[PlayerData::Roles::RoleXP] = "Xp";
    roles[PlayerData::Roles::RoleLevel] = "Level";
    return roles;

}

Qt::ItemFlags PlayerModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
            return 0;

    return Qt::ItemIsEditable | QAbstractItemModel::flags(index);
}
