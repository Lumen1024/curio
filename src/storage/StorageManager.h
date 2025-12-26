#pragma once

#include <QObject>
#include <QString>

class ChildRepository;
class LessonRepository;
class TeacherRepository;
class RepeatLessonRepository;

class StorageManager : public QObject {
    Q_OBJECT

public:
    explicit StorageManager(QObject* parent = nullptr);

    void setChildRepository(ChildRepository* repo);
    void setLessonRepository(LessonRepository* repo);
    void setTeacherRepository(TeacherRepository* repo);
    void setRepeatLessonRepository(RepeatLessonRepository* repo);

    Q_INVOKABLE bool loadAll();
    Q_INVOKABLE bool saveAll();

    QString getDataFilePath() const;

private:
    ChildRepository* m_childRepository = nullptr;
    LessonRepository* m_lessonRepository = nullptr;
    TeacherRepository* m_teacherRepository = nullptr;
    RepeatLessonRepository* m_repeatLessonRepository = nullptr;

    static const QString DATA_FILE_PATH;
};
