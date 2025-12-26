#include "StorageManager.h"
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
#include <QDebug>
#include <QStandardPaths>
#include <QDir>

const QString StorageManager::DATA_FILE_PATH =
    QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/curio_data.json";

StorageManager::StorageManager(QObject* parent)
    : QObject(parent)
{
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    if (!dir.exists()) {
        dir.mkpath(".");
    }
}

void StorageManager::setChildRepository(ChildRepository* repo) {
    m_childRepository = repo;
}

void StorageManager::setLessonRepository(LessonRepository* repo) {
    m_lessonRepository = repo;
}

void StorageManager::setTeacherRepository(TeacherRepository* repo) {
    m_teacherRepository = repo;
}

void StorageManager::setRepeatLessonRepository(RepeatLessonRepository* repo) {
    m_repeatLessonRepository = repo;
}

QString StorageManager::getDataFilePath() const {
    return DATA_FILE_PATH;
}

bool StorageManager::saveAll() {
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
    QFile file(DATA_FILE_PATH);

    if (!file.open(QIODevice::WriteOnly)) {
        qWarning() << "Failed to open file for writing:" << DATA_FILE_PATH;
        return false;
    }

    file.write(doc.toJson());
    file.close();

    qDebug() << "Data saved to:" << DATA_FILE_PATH;
    return true;
}

bool StorageManager::loadAll() {
    QFile file(DATA_FILE_PATH);

    if (!file.exists()) {
        qDebug() << "Data file does not exist yet:" << DATA_FILE_PATH;
        return true; 
    }

    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Failed to open file for reading:" << DATA_FILE_PATH;
        return false;
    }

    QByteArray data = file.readAll();
    file.close();

    QJsonDocument doc = QJsonDocument::fromJson(data);
    if (!doc.isObject()) {
        qWarning() << "Invalid JSON format in data file";
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

    qDebug() << "Data loaded from:" << DATA_FILE_PATH;
    return true;
}
