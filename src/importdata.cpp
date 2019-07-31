#include "importdata.h"

#include <QDebug>
#include <QString>

ImportData::ImportData(QObject *parent) : QObject(parent)
{
}

ImportData::State ImportData::state() const
{
    return state_;
}

void ImportData::setState(State state)
{
    if(state_ != state) {
        state_ = state;
        emit stateChanged(state);
    }
}

WordModel* ImportData::words() const
{
    if(dataPtr_) {
        return dataPtr_->words();
    }

    return nullptr;
}
