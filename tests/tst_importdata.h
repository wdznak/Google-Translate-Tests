#ifndef TST_IMPORTDATA_H
#define TST_IMPORTDATA_H

#include "importdata.h"
#include "wordsimportinterface.h"
#include "wordmodel.h"

#include <gtest/gtest.h>
#include <gmock/gmock.h>
#include <memory>

#include <QString>

using ::testing::AtLeast;
using ::testing::Invoke;

/*
 * Mock used to test loadFile functionality
 */
class MockWordsImport: public WordsImportInterface
{
public:
    MOCK_CONST_METHOD0(words, WordModel*());

    void DelegateToFake() {
        ON_CALL(*this, words())
                .WillByDefault(Return(&wm));
    }
private:
    WordModel wm;
};

/*
 * Factory class that returns mock object
 */
class WordsImportFactoryFake
{
public:
    static std::unique_ptr<WordsImportInterface> create(const QString&) {
        NiceMock<MockWordsImport>* mwi = new NiceMock<MockWordsImport>;
        mwi->DelegateToFake();
        return std::unique_ptr<WordsImportInterface>(mwi);
    }
};

TEST(WordsImport, LoadsFileAndChangeState)
{
    ImportData id;
    bool signalEmited = false;
    QObject::connect(&id, &ImportData::stateChanged,
                     [&signalEmited](){ signalEmited = true; });
    EXPECT_EQ(ImportData::EMPTY, id.state());

    id.loadFile<WordsImportFactoryFake>(QUrl());
    EXPECT_EQ(ImportData::READY, id.state());
    EXPECT_TRUE(signalEmited);
}

TEST(WordsImport, HasWordModelAfterFileIsLoaded)
{
    ImportData id;
    EXPECT_TRUE(id.words() == nullptr);

    id.loadFile<WordsImportFactoryFake>(QUrl());
    EXPECT_TRUE(id.words() != nullptr);
}

TEST(WordsImport, HasEMPTYstateWhenCreated)
{
    ImportData id;
    EXPECT_EQ(ImportData::EMPTY, id.state());
}

//TEST(WordsImport, SetState)
//{
//    ImportData id;
//    bool signalEmited = false;
//    ImportData::State state = ImportData::EMPTY;
//    QObject::connect(&id, &ImportData::stateChanged,
//                     [&signalEmited, &state](ImportData::State state_){
//                                                signalEmited = true;
//                                                state = state_; });
//    id.setState(ImportData::ERROR);
//    EXPECT_TRUE(signalEmited);
//    EXPECT_EQ(ImportData::ERROR, id.state());
//}

#endif // TST_IMPORTDATA_H
