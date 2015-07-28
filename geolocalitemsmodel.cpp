#include <QDebug>
#include "geolocalitemsmodel.h"
#include <QTimer>




QVariant MapItem::getRole(int role) const
{
    switch (role)
    {

        case Roles::RoleLatitude:
            return Coordinate.latitude();
        case Roles::RoleLongitude:
            return Coordinate.longitude();
        case Roles::RoleValue:
            return Value;
        case Roles::RoleType:
            return Type;

    default:
        return QVariant();
    }
}

GeoLocalItemsModel::GeoLocalItemsModel(GameData& gameData) :m_gameData( gameData)
{
    srand (time(NULL));

}

GeoLocalItemsModel::~GeoLocalItemsModel()
{

}

int GeoLocalItemsModel::rowCount(const QModelIndex & parent) const
{
    Q_UNUSED(parent);
    return m_lstValues.size();
}

QVariant GeoLocalItemsModel::data( const QModelIndex & index, int role ) const
{
    if ( (index.row() < 0) || (index.row() >= rowCount()) )
        return QVariant();

    return m_lstValues[ index.row()].getRole( role);

}



bool GeoLocalItemsModel::removeItem(int row)
{
    beginRemoveRows(QModelIndex(), row, row);
    m_lstValues.remove( row);
    endRemoveRows();
    return true;

}

bool GeoLocalItemsModel::addItem(int Type)
{
    QGeoCoordinate center = m_gameData.lastPosition().coordinate();
    int row = rowCount();
    beginInsertRows(QModelIndex(), row, row);
    QGeoCoordinate newCoordinate =  center.atDistanceAndAzimuth( (rand() %(m_maxRange-m_minRange)) + m_minRange, rand() %360);
    m_lstValues.push_back( MapItem( newCoordinate, (rand() %m_maxBonusValue) +1, Type));
    endInsertRows();

    return true;
}

void GeoLocalItemsModel::checkForEnergyAround()
{
    QGeoCoordinate center = m_gameData.lastPosition().coordinate();

    int rank = 0;
    for (MapItem bonusItem : m_lstValues)
    {
        qreal dist = center.distanceTo( bonusItem.Coordinate );
        if (  (dist!=0) && (dist <= m_nearDistance) ){
            //Remove
            removeItem(rank);

            //Create new
            addItem( bonusItem.Type );

            //notify
            bonusItemFound(bonusItem.Type, bonusItem.Value);


            return;
        }
        rank++;
    }

}


void GeoLocalItemsModel::resetModel()
{
    QGeoCoordinate center = m_gameData.lastPosition().coordinate();
    if ( !center.isValid() )
    {
        //try again later
        QTimer::singleShot(1000, this, SLOT(resetModel()) );
        return;
    }


    beginResetModel();

    m_lstValues.clear();
    for (int i = 0; i < 10; i++){
        QGeoCoordinate newCoordinate =  center.atDistanceAndAzimuth( (rand() %(m_maxRange-m_minRange)) + m_minRange, rand() %360);
        m_lstValues.push_back( MapItem( newCoordinate, (rand() %m_maxBonusValue) +1, MapItem::TypeEnergy));
    }

    for (int i = 0; i < 2; i++){
        QGeoCoordinate newCoordinate =  center.atDistanceAndAzimuth( (rand() %(m_maxRange-m_minRange)) + m_minRange, rand() %360);
        m_lstValues.push_back( MapItem( newCoordinate, (rand() %m_maxBonusValue) +1, MapItem::TypeHealth));
    }
    for (int i = 0; i < 2; i++){
        QGeoCoordinate newCoordinate =  center.atDistanceAndAzimuth( (rand() %(m_maxRange-m_minRange)) + m_minRange, rand() %360);
        m_lstValues.push_back( MapItem( newCoordinate, (rand() %m_maxBonusValue) +1, MapItem::TypeCredit));
    }


    endResetModel();

}



QHash<int, QByteArray> GeoLocalItemsModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[MapItem::Roles::RoleLatitude] = "Latitude";
    roles[MapItem::Roles::RoleLongitude] = "Longitude";
    roles[MapItem::Roles::RoleValue] = "Value";
    roles[MapItem::Roles::RoleType] = "Type";

    return roles;

}

Qt::ItemFlags GeoLocalItemsModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
            return 0;

    return Qt::ItemIsEditable | QAbstractItemModel::flags(index);
}
