#include "ExportManager.h"
#include "../repository/ChildRepository.h"
#include "../repository/LessonRepository.h"
#include "../repository/TeacherRepository.h"
#include "../repository/RepeatLessonRepository.h"
#include "../data/Child.h"
#include "../data/Lesson.h"
#include "../data/Teacher.h"
#include "../data/RepeatLesson.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QFile>
#include <QFileDialog>
#include <QDebug>

ExportManager::ExportManager(QObject* parent)
    : QObject(parent)
{
}

void ExportManager::setChildRepository(ChildRepository* repo) {
    m_childRepository = repo;
}

void ExportManager::setLessonRepository(LessonRepository* repo) {
    m_lessonRepository = repo;
}

void ExportManager::setTeacherRepository(TeacherRepository* repo) {
    m_teacherRepository = repo;
}

void ExportManager::setRepeatLessonRepository(RepeatLessonRepository* repo) {
    m_repeatLessonRepository = repo;
}

QString ExportManager::openSaveFileDialog() {
    QString filePath = QFileDialog::getSaveFileName(
        nullptr,
        QString::fromUtf8("Экспорт расписания"),
        "curio_export.json",
        QString::fromUtf8("JSON файлы (*.json);;Все файлы (*.*)")
    );
    return filePath;
}

QString ExportManager::openOpenFileDialog() {
    QString filePath = QFileDialog::getOpenFileName(
        nullptr,
        QString::fromUtf8("Импорт расписания"),
        "",
        QString::fromUtf8("JSON файлы (*.json);;Все файлы (*.*)")
    );
    return filePath;
}

bool ExportManager::exportToJson() {
    QString filePath = openSaveFileDialog();

    if (filePath.isEmpty()) {
        qDebug() << "Export cancelled by user";
        return false;
    }

    return saveToFile(filePath);
}

bool ExportManager::importFromJson() {
    QString filePath = openOpenFileDialog();

    if (filePath.isEmpty()) {
        qDebug() << "Import cancelled by user";
        return false;
    }

    return loadFromFile(filePath);
}

bool ExportManager::saveToFile(const QString& filePath) {
    QJsonObject root;

    if (m_childRepository) {
        QJsonArray childrenArray;
        for (const auto& child : m_childRepository->getAll()) {
            childrenArray.append(child.toJson());
        }
        root["children"] = childrenArray;
    }

    if (m_teacherRepository) {
        QJsonArray teachersArray;
        for (const auto& teacher : m_teacherRepository->getAll()) {
            teachersArray.append(teacher.toJson());
        }
        root["teachers"] = teachersArray;
    }

    if (m_lessonRepository) {
        QJsonArray lessonsArray;
        for (const auto& lesson : m_lessonRepository->getAll()) {
            lessonsArray.append(lesson.toJson());
        }
        root["lessons"] = lessonsArray;
    }

    if (m_repeatLessonRepository) {
        QJsonArray repeatLessonsArray;
        for (const auto& repeatLesson : m_repeatLessonRepository->getAll()) {
            repeatLessonsArray.append(repeatLesson.toJson());
        }
        root["repeatLessons"] = repeatLessonsArray;
    }

    QJsonDocument doc(root);
    QFile file(filePath);

    if (!file.open(QIODevice::WriteOnly)) {
        qWarning() << "Failed to open file for writing:" << filePath;
        return false;
    }

    file.write(doc.toJson(QJsonDocument::Indented));
    file.close();

    qDebug() << "Data exported to:" << filePath;
    return true;
}

bool ExportManager::loadFromFile(const QString& filePath) {
    QFile file(filePath);

    if (!file.exists()) {
        qWarning() << "File does not exist:" << filePath;
        return false;
    }

    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Failed to open file for reading:" << filePath;
        return false;
    }

    QByteArray data = file.readAll();
    file.close();

    QJsonDocument doc = QJsonDocument::fromJson(data);
    if (!doc.isObject()) {
        qWarning() << "Invalid JSON format in file";
        return false;
    }

    QJsonObject root = doc.object();

    if (m_childRepository && root.contains("children")) {
        m_childRepository->loadFromJson(root["children"].toArray());
    }

    if (m_teacherRepository && root.contains("teachers")) {
        m_teacherRepository->loadFromJson(root["teachers"].toArray());
    }

    if (m_lessonRepository && root.contains("lessons")) {
        m_lessonRepository->loadFromJson(root["lessons"].toArray());
    }

    if (m_repeatLessonRepository && root.contains("repeatLessons")) {
        m_repeatLessonRepository->loadFromJson(root["repeatLessons"].toArray());
    }

    qDebug() << "Data imported from:" << filePath;
    return true;
}
