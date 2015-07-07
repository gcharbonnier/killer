#ifndef PLAYERMODEL_H
#define PLAYERMODEL_H

#include "gamedata.h"
#include <QObject>
#include <QAbstractListModel>
#include <QGeoPositionInfoSource>


struct PlayerData
{
    PlayerData(){}
    PlayerData(uint _ID, QString _Name, int _Distance, int _Azimuth, int heading, int type, double lat, double lng){
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
    }

    uint ID = 0;
    int Distance = -1;
    int Bearing = -1;
    int Type = 0;
    int Azimuth = -1;
    double Latitude = 0.;
    double Longitude = 0.;
    QString NamePlayer = "";
    QVariant getRole(int role) const;

    enum Roles {
        RoleId = Qt::UserRole + 1,
        RoleDistance,
        RoleBearing,
        RoleType,
        RoleAzimuth,
        RoleLatitude,
        RoleLongitude,
        RoleNamePlayer
    };


};

class PlayerModel : public QAbstractListModel
{
    Q_OBJECT
public:
    PlayerModel(GameData& gameData);
    PlayerModel& operator=( const PlayerModel& pm){

        //FIXME
        return *this;
    }

    ~PlayerModel();

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data( const QModelIndex & index, int role = Qt::DisplayRole ) const;
    Q_INVOKABLE Qt::ItemFlags flags(const QModelIndex &index) const Q_DECL_OVERRIDE;

    bool setData(const QModelIndex & index, const QVariant & value, int role = Qt::EditRole);
    //bool insertRows(int row, int count, const QModelIndex & parent = QModelIndex());
    bool removeRows(int row, int count, const QModelIndex & parent = QModelIndex());

    void resetModel();
    void updateModel();
    //void setMyCurrentPos( QGeoPositionInfo pos);
    //void setMyId( uint id);
    int maxDistance(){ return m_maxDistance;}

    const PlayerData& getPlayerData(int PlayerID){
        int row = indexFromIdPlayer( PlayerID ).row();
        return m_lstValues.at( row);
    }


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
