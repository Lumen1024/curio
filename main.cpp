#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include "src/data/Teacher.h"
#include "src/data/Lesson.h"
#include "src/data/LessonType.h"
#include "src/data/Child.h"
#include "src/data/RepeatLesson.h"
#include "src/repository/ChildRepository.h"
#include "src/repository/LessonRepository.h"
#include "src/repository/TeacherRepository.h"
#include "src/repository/RepeatLessonRepository.h"
#include "src/storage/StorageManager.h"
#include "src/export/ExportManager.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQuickStyle::setStyle("Basic");

    qRegisterMetaType<Teacher>("Teacher");
    qRegisterMetaType<Lesson>("Lesson");
    qRegisterMetaType<LessonType>("LessonType");
    qRegisterMetaType<Child>("Child");
    qRegisterMetaType<RepeatLesson>("RepeatLesson");
    qmlRegisterType<ChildRepository>("curio", 1, 0, "ChildRepository");
    qmlRegisterType<LessonRepository>("curio", 1, 0, "LessonRepository");
    qmlRegisterType<TeacherRepository>("curio", 1, 0, "TeacherRepository");
    qmlRegisterType<RepeatLessonRepository>("curio", 1, 0, "RepeatLessonRepository");
    qmlRegisterType<StorageManager>("curio", 1, 0, "StorageManager");
    qmlRegisterType<ExportManager>("curio", 1, 0, "ExportManager");

    ChildRepository childRepo;
    LessonRepository lessonRepo;
    TeacherRepository teacherRepo;
    RepeatLessonRepository repeatLessonRepo;

    StorageManager storageManager;
    storageManager.setChildRepository(&childRepo);
    storageManager.setLessonRepository(&lessonRepo);
    storageManager.setTeacherRepository(&teacherRepo);
    storageManager.setRepeatLessonRepository(&repeatLessonRepo);

    ExportManager exportManager;
    exportManager.setChildRepository(&childRepo);
    exportManager.setLessonRepository(&lessonRepo);
    exportManager.setTeacherRepository(&teacherRepo);
    exportManager.setRepeatLessonRepository(&repeatLessonRepo);

    storageManager.loadAll();

    QObject::connect(&app, &QApplication::aboutToQuit, [&storageManager]() {
        storageManager.saveAll();
    });

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("globalChildRepo", &childRepo);
    engine.rootContext()->setContextProperty("globalLessonRepo", &lessonRepo);
    engine.rootContext()->setContextProperty("globalTeacherRepo", &teacherRepo);
    engine.rootContext()->setContextProperty("globalRepeatLessonRepo", &repeatLessonRepo);
    engine.rootContext()->setContextProperty("globalStorageManager", &storageManager);
    engine.rootContext()->setContextProperty("globalExportManager", &exportManager);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("curio", "Main");

    return app.exec();
}
