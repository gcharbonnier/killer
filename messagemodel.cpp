#include "messagemodel.h"

#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>


QVariant Message::getRole(int role) const
{
    switch (role)
    {
        case Roles::RoleId:
            return ID;
            break;
        case Roles::RoleEmitter:
            return Emitter;
            break;
        case Roles::RoleRecipient:
            return Recipient;
            break;
        case Roles::RoleType:
            return Type;
        case Roles::RoleMessage:
            return MessageContent;
        case Roles::RoleEmitted:
            return Emitted;

    default:
        return QVariant();
    }
}

MessageModel::MessageModel(GameData& gameData) :m_gameData( gameData)
{

}

MessageModel::~MessageModel()
{

}

int MessageModel::rowCount(const QModelIndex & parent) const
{
    Q_UNUSED(parent);
    return m_lstValues.size();
}

QVariant MessageModel::data( const QModelIndex & index, int role ) const
{
    if ( (index.row() < 0) || (index.row() >= rowCount()) )
        return QVariant();

    return m_lstValues[ index.row()].getRole( role);

}

void MessageModel::resetModel()
{
    beginResetModel();

    m_lstValues.clear();
    QSqlQuery query;
    QString req = QString("SELECT * from geo_messages \
            WHERE (EMITTER = '%1' or RECIPIENT = '%1' or TYPE = 0 ) AND ID_CAMPAIGN = %2").arg(m_gameData.accountName()).arg( m_gameData.campaignId());

            query.exec( req);
    int indId = query.record().indexOf("ID");
    int indRecipient = query.record().indexOf("RECIPIENT");
    int indType = query.record().indexOf("TYPE");
    int indMessage = query.record().indexOf("MESSAGE");
    //int indCampaign = query.record().indexOf("ID_CAMPAIGN");
    int indEmitter = query.record().indexOf("EMITTER");
    int indEmitted = query.record().indexOf("EMITTED");
    while (query.next())
    {
       int Id = query.value( indId ).toInt();
       int type = query.value( indType ).toInt();
       QString recipient = query.value( indRecipient ).toString();
       QString emitter = query.value( indEmitter ).toString();
       QString message = query.value( indMessage ).toString();
       QString dateEmitted = query.value( indEmitted ).toString();

       m_lstValues.push_back( Message(Id, emitter, recipient, type, message, dateEmitted));

    }
    endResetModel();

}


void MessageModel::updateModel()
{
    QSqlQuery query;
    QString req = QString("SELECT * from geo_messages \
            WHERE (EMITTER = '%1' or RECIPIENT = '%1' or TYPE = 0 ) AND ID_CAMPAIGN = %2").arg(m_gameData.accountName()).arg( m_gameData.campaignId());


    query.exec( req);
    int indId = query.record().indexOf("ID");
    int indRecipient = query.record().indexOf("RECIPIENT");
    int indType = query.record().indexOf("TYPE");
    int indMessage = query.record().indexOf("MESSAGE");
    //int indCampaign = query.record().indexOf("ID_CAMPAIGN");
    int indEmitter = query.record().indexOf("EMITTER");
    int indEmitted = query.record().indexOf("EMITTED");
    while (query.next())
    {
       int Id = query.value( indId ).toInt();
       int type = query.value( indType ).toInt();
       QString recipient = query.value( indRecipient ).toString();
       QString emitter = query.value( indEmitter ).toString();
       QString message = query.value( indMessage ).toString();
       QString dateEmitted = query.value( indEmitted ).toString();
       Message msg(Id, emitter, recipient, type, message, dateEmitted);


       bool found = false;
       for (Message msg2 : m_lstValues){
            if (msg2.ID == msg.ID)
                found = true;
       }
       if (!found)
       {
           int row = rowCount();
           beginInsertRows(QModelIndex(), row, row);
           m_lstValues.push_back( Message(Id, emitter, recipient, type, message, dateEmitted));
           endInsertRows();
       }

    }


}


QHash<int, QByteArray> MessageModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Message::Roles::RoleId] = "IdMessage";
    roles[Message::Roles::RoleEmitter] = "NameEmitter";
    roles[Message::Roles::RoleRecipient] = "NameRecipient";
    roles[Message::Roles::RoleMessage] = "MessageContent";
    roles[Message::Roles::RoleType] = "Type";
    roles[Message::Roles::RoleEmitted] = "DateTime";

    return roles;

}

Qt::ItemFlags MessageModel::flags(const QModelIndex &index) const
{
    return Qt::ItemIsEditable;

}


bool MessageModel::addMessage( QString emitter, QString recip, uint type, QString mesg, uint CampaignId){

    QString str = QString("INSERT INTO `simplisim_dejavu`.`geo_messages` (`ID`, `ID_CAMPAIGN`, `EMITTER`, `RECIPIENT`, `TYPE`, `MESSAGE`, `EMITTED`) \
            VALUES (NULL,'%1', '%2', '%3', '%4', '%5', CURRENT_TIMESTAMP);")
            .arg( CampaignId).arg( emitter ).arg( recip).arg( type).arg( mesg);

    QSqlQuery query;
    return query.exec( str );
}

bool MessageModel::sendSystemMessage(QString message)
{
    return addMessage("System","",0,message, m_gameData.campaignId());
}

bool MessageModel::sendMessage(QString message, QString recipient)
{
    return addMessage(m_gameData.accountName(),recipient,1,message, m_gameData.campaignId());
}
