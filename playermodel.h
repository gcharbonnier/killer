#ifndef PLAYERMODEL_H
#define PLAYERMODEL_H

#include "gamedata.h"
#include <QObject>
#include <QAbstractListModel>
#include <QGeoPositionInfoSource>

#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

struct PlayerData
{
    PlayerData(){    }
    PlayerData(uint _ID, QString _Name, int _Distance, int _Azimuth, int heading, int type, double lat, double lng,
               uint _Health, uint _Energy, uint _Xp, uint _Credits, uint _Level){
        ID = _ID;
        Distance = _Distance;
        Azimuth = _Azimuth;
        Bearing = heading;
        Type = type;

        if (ID == 5 || ID == 6 || ID == 7) //Aka Bot1, Bot2, Bot3
            Type = 0;

        Latitude = lat;
        Longitude = lng;
        NamePlayer = _Name;

        Health = _Health;
        Energy = _Energy;
        Xp = _Xp;
        Credits = _Credits;
        Level = _Level;
    }

    uint ID = 0;
    int Distance = -1;
    int Bearing = -1;
    int Type = 0;
    int Azimuth = -1;
    double Latitude = 0.;
    double Longitude = 0.;
    QString NamePlayer = "Invalid";
    uint Health = 0.;
    uint Energy = 0.;
    uint Xp = 0.;
    uint Credits = 0.;
    uint Level = 0.;
    QVariant getRole(int role) const;

    enum Roles {
        RoleId = Qt::UserRole + 1,
        RoleDistance,
        RoleBearing,
        RoleType,
        RoleAzimuth,
        RoleLatitude,
        RoleLongitude,
        RoleNamePlayer,
        RoleHealth,
        RoleEnergy,
        RoleXP,
        RoleCredits,
        RoleLevel
    };


};

class PlayerModel : public QAbstractListModel
{
    Q_OBJECT
public:
    PlayerModel(GameData& gameData);
    PlayerModel& operator=( const PlayerModel& pm){
        Q_UNUSED(pm);

        //FIXME
        return *this;
    }

    ~PlayerModel();

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data( const QModelIndex & index, int role = Qt::DisplayRole ) const;
    Q_INVOKABLE Qt::ItemFlags flags(const QModelIndex &index) const Q_DECL_OVERRIDE;

    Q_INVOKABLE void changeCharbyAzimuth(float azim)
    {
        QModelIndex inCd = indexFromIdPlayer(1);
        setData( inCd, azim, PlayerData::RoleAzimuth);
        emit dataChanged(inCd, inCd);
    }

    virtual bool setData(const QModelIndex & index, const QVariant & value, int role = Qt::EditRole);
    //bool insertRows(int row, int count, const QModelIndex & parent = QModelIndex());
    bool removeRows(int row, int count, const QModelIndex & parent = QModelIndex());

    void resetModel();
    void updateModel();
    //void setMyCurrentPos( QGeoPositionInfo pos);
    //void setMyId( uint id);
    int maxDistance(){ return m_maxDistance;}

    Q_INVOKABLE QList<int> getMyData(){
        QList<int> myData = QList<int>();
        PlayerData pdata = getPlayerData( m_gameData.accountId());
        myData.append(pdata.Health);
        myData.append(pdata.Xp);
        myData.append(pdata.Credits);
        myData.append(pdata.Energy);
        myData.append(pdata.Level);
        return myData;
    }
    Q_INVOKABLE void updateMyData( uint health, uint xp, uint credits, uint energy, uint level ){
        QString str = QString("UPDATE  `simplisim_dejavu`.`geo_players` SET  `HEALTH` =  '%1',\
                              `XP` =  '%2', \
                              `CREDITS` =  '%3', \
                              `ENERGY` =  '%4', \
                              `LEVEL` =  '%5' WHERE  `geo_players`.`ID_ACCOUNT` =%6;")
                .arg( health)
                .arg( xp)
                .arg( credits)
                .arg( energy)
                .arg( level)
                .arg( m_gameData.accountId());
        QSqlQuery query;
        if ( !query.exec( str ) )
        {
            qDebug() << "Error with query : "<< str;
            qDebug() << "last error : " << query.lastError();

        }

    }

    PlayerData getPlayerData(int PlayerID){
        QModelIndex index = indexFromIdPlayer( PlayerID );
        if (index.isValid() && index.row() < m_lstValues.size())
            return m_lstValues.at( index.row());
        else
        {
            return PlayerData();
        }
    }

signals:
    void newPlayer(QString playerName);
    void playerLeave(QString playerName);

    //void dataChanged(const QModelIndex & topLeft, const QModelIndex & bottomRight, const QVector<int> & roles = QVector<int> ());

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    GameData& m_gameData;
    QVector< PlayerData> m_lstValues ;
    QModelIndex indexFromIdPlayer(int);
    void purgePlayers(const std::vector<int>& lstPlayersIdToKeep);
    QGeoPositionInfo m_myPosition = QGeoPositionInfo();

    int m_maxDistance =-1;
};


#endif // PLAYERMODEL_H
