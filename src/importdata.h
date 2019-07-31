#ifndef IMPORTDATA_H
#define IMPORTDATA_H

#include "gtestssqlqueries.h"
#include "wordsimportinterface.h"
#include "wordmodel.h"
#include "wordsimportfactory.h"
#include "usermanager.h"

#include <QObject>
#include <QDir>

#include <memory>

class ImportData : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl loadFile WRITE loadFile)
    Q_PROPERTY(State state READ state NOTIFY stateChanged)

public:
    explicit ImportData(QObject *parent = nullptr);

    enum State{ READY, ERROR, EMPTY };
    Q_ENUM(State)

    State state() const;

    template<class T = WordsImportFactory>
    void loadFile(const QUrl& filePath)
    {
        setState(State::EMPTY);

        dataPtr_ = T::create(QDir::toNativeSeparators(filePath.toLocalFile()));

        if(dataPtr_) {
            setState(State::READY);
        } else {
            setState(State::ERROR);
        }
    }

public slots:
    WordModel* words() const;

signals:
    void stateChanged(State state);

private:
    std::unique_ptr<WordsImportInterface> dataPtr_;
    State state_{ EMPTY };
    void setState(State state);
};

#endif // IMPORTDATA_H
