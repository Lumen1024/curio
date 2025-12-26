#pragma once

#include <QObject>
#include <QString>

class ChildRepository;
class LessonRepository;
class TeacherRepository;
class RepeatLessonRepository;

class ExportManager : public QObject {
    Q_OBJECT

public:
    explicit ExportManager(QObject* parent = nullptr);

    void setChildRepository(ChildRepository* repo);
    void setLessonRepository(LessonRepository* repo);
    void setTeacherRepository(TeacherRepository* repo);
    void setRepeatLessonRepository(RepeatLessonRepository* repo);

    Q_INVOKABLE bool exportToJson();
    Q_INVOKABLE bool importFromJson();

private:
    ChildRepository* m_childRepository = nullptr;
    LessonRepository* m_lessonRepository = nullptr;
    TeacherRepository* m_teacherRepository = nullptr;
    RepeatLessonRepository* m_repeatLessonRepository = nullptr;

    QString openSaveFileDialog();
    QString openOpenFileDialog();
    bool saveToFile(const QString& filePath);
    bool loadFromFile(const QString& filePath);
};
