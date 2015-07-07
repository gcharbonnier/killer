#ifndef CAMPAIGNMANAGER_H
#define CAMPAIGNMANAGER_H


#include "gamedata.h"
#include <QObject>
#include <QAbstractListModel>


class CampaignItem
{
public:

    enum Type{
        Highlander = 1,
        RingOfDeath
    } ;


    CampaignItem(GameData& gameData) : m_gameData( gameData){}

    CampaignItem( GameData& gameData, uint id, QString name, double centerLatitude, double centerLongitude,
            uint radius, uint nbTeam, Type type, uint owner, uint nbPlayers, bool isConnected): m_gameData( gameData)
    {
        m_id = id;
        m_name = name;
        m_centerLatitude = centerLatitude;
        m_centerLongitude = centerLongitude;
        m_radius= radius;
        m_nbTeam =  nbTeam;
        m_type = type;
        m_owner = owner;
        m_nbPlayers = nbPlayers;
        m_isConnected = isConnected;
    }


    QVariant getRole(int role) const;

    enum Roles {
        RoleIdcampaign = Qt::UserRole + 1,
        RoleName,
        RoleType,
        RoleNbTeam,
        RoleNbPlayers,
        RoleAmIConnected,
        RoleIsMyCampaign
    };

private:
    GameData& m_gameData;

    uint m_id = 0;
    QString m_name = "";
    double m_centerLatitude = 0.;
    double m_centerLongitude = 0.;
    uint m_radius= 1;
    uint m_nbTeam =  0;
    Type m_type;
    uint m_owner = 0;
    uint m_nbPlayers = 0;
    bool m_isConnected = false;


};



class CampaignManager : public QAbstractListModel//: public QObject
{
    Q_OBJECT
public:


    explicit CampaignManager( GameData& gameData, QObject *parent = 0);
    ~CampaignManager();

    CampaignManager& operator=( const CampaignManager& pm){
        return *this; //TODO remove this awful hack!
    }



    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data( const QModelIndex & index, int role = Qt::DisplayRole ) const;
    Q_INVOKABLE Qt::ItemFlags flags(const QModelIndex &index) const Q_DECL_OVERRIDE;


    Q_INVOKABLE int createCampaign(uint owner, CampaignItem::Type type, QString name, uint nbTeam);
    Q_INVOKABLE bool modifyCampaign(uint id, uint owner, CampaignItem::Type type, QString name, uint nbTeam);
    Q_INVOKABLE bool deleteCampaign(uint idcampaign);

    Q_INVOKABLE uint joinCampaign(uint idcampaign, uint idPlayer);
    Q_INVOKABLE uint leaveCampaign(uint idcampaign, uint idPlayer);
    Q_INVOKABLE void resetModel();


    void setCurrentCampaign( uint idCampaign);

    //This is to be able to access a given CampaignItem from QML(editing a campaign)
    Q_INVOKABLE QVariantMap get(int idCampaign) {

        int row = rowFromId(idCampaign);

        QHash<int,QByteArray> names = roleNames();
        QHashIterator<int, QByteArray> i(names);
        QVariantMap res;
        const QModelIndex idx = index(row, 0);
        while (i.hasNext()) {
            i.next();
            res[i.value()] = data( idx, i.key());
        }
        return res;
    }

signals:

public slots:


protected:
    QHash<int, QByteArray> roleNames() const;

private:
    GameData& m_gameData;

    QVariant findCampaignData(uint idCampaign, CampaignItem::Roles );

    int rowFromId(uint id){
        int row = 0;
        for (auto cp :m_lstValues){
            if (cp.getRole( CampaignItem::RoleIdcampaign) == id)
                break;
            row++;
        }
        return row;
    }

    std::vector<CampaignItem> m_lstValues = std::vector<CampaignItem>();
};



#endif // CAMPAIGNMANAGER_H
