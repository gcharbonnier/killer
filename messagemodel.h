#ifndef MESSAGEMODEL_H
#define MESSAGEMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include "gamedata.h"


struct Message
{
    Message(){    }
    Message(uint _ID, QString _Emitter, QString _Recipient , uint _Type,  QString _MessageContent, QString _Emitted){
        ID = _ID;
        Emitter = _Emitter;
        Recipient = _Recipient;
        MessageContent = _MessageContent;
        Type = _Type;
        Emitted = _Emitted;
    }

    uint ID = 0;
    QString Emitter = "Invalid";
    QString Recipient = "Invalid";
    uint Type = 0;
    QString MessageContent = "Invalid";
    QString Emitted = "Invalid";
    QVariant getRole(int role) const;


    enum Roles {
        RoleId = Qt::UserRole + 1,
        RoleEmitter,
        RoleRecipient,
        RoleType,
        RoleMessage,
        RoleEmitted
    };


};

class MessageModel : public QAbstractListModel
{
    Q_OBJECT
public:
    MessageModel(GameData& gameData);
    MessageModel& operator=( const MessageModel& mm){
        Q_UNUSED(mm);
        //FIXME
        return *this;
    }

    ~MessageModel();

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data( const QModelIndex & index, int role = Qt::DisplayRole ) const;
    Q_INVOKABLE Qt::ItemFlags flags(const QModelIndex &index) const Q_DECL_OVERRIDE;

    //bool setData(const QModelIndex & index, const QVariant & value, int role = Qt::EditRole);
    //bool insertRows(int row, int count, const QModelIndex & parent = QModelIndex());
    //bool removeRows(int row, int count, const QModelIndex & parent = QModelIndex());

    void resetModel();
    void updateModel();

public slots:
    bool sendSystemMessage(QString message);
    bool sendMessage(QString message, QString recipient);



signals:


protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QVector< Message> m_lstValues ;
    GameData& m_gameData;

    bool addMessage( QString emitter, QString recip, uint type, QString mesg, uint CampaignId);

};


#endif // MESSAGEMODEL_H
