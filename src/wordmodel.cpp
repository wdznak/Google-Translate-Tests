#include "wordmodel.h"
#include <functional>
#include <QDebug>

/*
    -- Word Class --
 */

Word::Word(const QString &word, const QString &translation)
    : word_(word), translation_(translation)
{

}

QString Word::word() const
{
    return word_;
}

QString Word::translation() const
{
    return translation_;
}

/*
    -- WordModel Class --
 */

WordModel::WordModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

void WordModel::addHeader(QString first, QString second)
{
    header_.first = first;
    header_.second = second;
}

void WordModel::addWord(const Word &word)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    words_ << word;
    endInsertRows();
}

void WordModel::addWord(const QString &word, const QString &translation)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    words_ << Word(word, translation);
    endInsertRows();
}

int WordModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return words_.count();
}

QVariant WordModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= words_.count())
        return QVariant();

    const Word &word = words_[index.row()];
    if (role == WordRole)
        return word.word();
    else if (role == TranslationRole)
        return word.translation();

    return QVariant();
}

void WordModel::removeRow(int row)
{
    beginRemoveRows(QModelIndex(), row, row);
    words_.removeAt(row);
    endRemoveRows();
}

void WordModel::removeRows(QVector<int> list)
{
    std::sort(list.begin(), list.end(), [](const auto& a, const auto& b){return a > b;});

    QVectorIterator<int> i(list);

    while (i.hasNext()) {
        auto row = i.next();
        beginRemoveRows(QModelIndex(), row, row);
        words_.removeAt(row);
        endRemoveRows();
    }
}

void WordModel::editRow(const int row, const QString &word, const int role)
{
    const QModelIndex index = QAbstractItemModel::createIndex(row, 0);

    if (role == WordRole) {
        words_[row] = Word(word, words_[row].translation());
        dataChanged(index, index);
    } else if (role == TranslationRole) {
        words_[row] = Word(words_[row].word(), word);
        dataChanged(index, index);
    }
}

QString WordModel::wordOrigin() const
{
    return header_.first;
}

QString WordModel::translationOrigin() const
{
    return header_.second;
}

QHash<int, QByteArray> WordModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[WordRole] = "word";
    roles[TranslationRole] = "translation";

    return roles;
}
