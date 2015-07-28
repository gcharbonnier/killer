#ifndef ENERGYMODEL_H
#define ENERGYMODEL_H

#include "gamedata.h"
#include <QObject>
#include <QAbstractListModel>
#include <QGeoPositionInfoSource>

#include <QDebug>

struct MapItem
{
    MapItem(){    }
    MapItem( QGeoCoordinate _Coord, int _Value, int _Type){
        Coordinate = _Coord;
        Value = _Value;
        Type = _Type;
    }

    enum{
        TypeEnergy = 0,
        TypeHealth,
        TypeCredit
    };

    QVariant getRole(int role) const;

    enum Roles {
        RoleLatitude = Qt::UserRole + 1,
        RoleLongitude,
        RoleValue,
        RoleType
    };
    int Value = 0;
    int Type = TypeEnergy;
    QGeoCoordinate Coordinate;

};

class GeoLocalItemsModel : public QAbstractListModel
{
    Q_OBJECT
public:
    GeoLocalItemsModel(GameData& gameData);
    GeoLocalItemsModel& operator=( const GeoLocalItemsModel& pm){
        Q_UNUSED(pm);

        //FIXME
        return *this;
    }

    ~GeoLocalItemsModel();

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data( const QModelIndex & index, int role = Qt::DisplayRole ) const;
    Q_INVOKABLE Qt::ItemFlags flags(const QModelIndex &index) const Q_DECL_OVERRIDE;


    bool removeItem( int row);
    bool addItem( int Type);
    void checkForEnergyAround();

public slots:
    void resetModel();

signals:
    void bonusItemFound(int Type, int value);

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    GameData& m_gameData;
    QVector< MapItem> m_lstValues ;

    const int m_nearDistance = 20;
    const int m_minRange = 50;
    const int m_maxRange = 500;
    const int m_maxBonusValue = 100;
};


#endif // ENERGYMODEL_H
