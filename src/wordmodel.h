#ifndef WORDMODEL_H
#define WORDMODEL_H

#include <QAbstractListModel>
#include <QStringList>
#include <QVariantList>
#include <QDebug>

/*
    -- Word Class --
 */

class Word
{

public:
    Word(const QString& word, const QString& translation);

    QString word() const;
    QString translation() const;

private:
    QString word_;
    QString translation_;
};

/*
    -- WordModel Class --
 */

class WordModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString wordOrigin READ wordOrigin CONSTANT)
    Q_PROPERTY(QString translationOrigin READ translationOrigin CONSTANT)

public:
    enum WordRoles {
        WordRole = Qt::UserRole + 1,
        TranslationRole
    };
    Q_ENUM(WordRoles)

    WordModel(QObject *parent = nullptr);

    void addHeader(QString first, QString second);
    void addWord(const Word &word);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QString wordOrigin() const;
    QString translationOrigin() const;

public slots:
    void addWord(const QString &word, const QString &translation);
    void removeRow(int row);
    void removeRows(QVector<int> list);
    void editRow(const int row, const QString& word, const int role);

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QList<Word> words_;
    QPair<QString, QString> header_;
};

#endif // WORDMODEL_H
