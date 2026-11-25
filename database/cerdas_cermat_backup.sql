-- MariaDB dump 10.19  Distrib 10.4.28-MariaDB, for osx10.10 (x86_64)
--
-- Host: localhost    Database: cerdas_cermat
-- ------------------------------------------------------
-- Server version	10.4.28-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `cerdas_cermat`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `cerdas_cermat` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `cerdas_cermat`;

--
-- Table structure for table `buzz_events`
--

DROP TABLE IF EXISTS `buzz_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `buzz_events` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `match_id` bigint(20) unsigned NOT NULL,
  `team_id` bigint(20) unsigned NOT NULL,
  `accepted` tinyint(1) NOT NULL DEFAULT 0,
  `reason` varchar(120) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  KEY `fk_buzz_team` (`team_id`),
  KEY `idx_buzz_match_time` (`match_id`,`created_at`),
  CONSTRAINT `fk_buzz_match` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_buzz_team` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buzz_events`
--

LOCK TABLES `buzz_events` WRITE;
/*!40000 ALTER TABLE `buzz_events` DISABLE KEYS */;
INSERT INTO `buzz_events` VALUES (1,6,16,1,'Bel diterima','2026-11-25 14:26:08.711303'),(2,6,17,1,'Bel diterima','2026-11-25 14:26:11.881794'),(3,8,19,1,'Bel diterima','2026-11-25 14:44:22.645976'),(4,8,17,1,'Bel diterima','2026-11-25 14:44:50.815252'),(5,8,19,1,'Bel diterima','2026-11-25 14:45:02.447609'),(6,8,16,1,'Bel diterima','2026-11-25 14:45:07.732245'),(7,8,18,1,'Bel diterima','2026-11-25 14:45:13.275193'),(8,8,16,1,'Bel diterima','2026-11-25 14:45:18.832168'),(9,8,17,1,'Bel diterima','2026-11-25 14:45:25.531298'),(10,8,17,1,'Bel diterima','2026-11-25 14:45:30.177292');
/*!40000 ALTER TABLE `buzz_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `events` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(180) NOT NULL,
  `location` varchar(180) DEFAULT NULL,
  `event_date` date DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'draft',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (1,'Peringatan Isra Mi\'raj Nabi Muhammad SAW 1446 H','Aula Utama Masjid Agung Al-Falah, Surabaya','2025-01-27','finished','2026-09-10 09:00:55','2026-09-10 09:00:55'),(2,'Semarak Cerdas Cermat Ramadhan 1446 H & Nuzulul Qur\'an','Masjid Raya An Nuur, Kompleks Islamic Center','2025-03-18','finished','2026-09-10 09:00:55','2026-09-10 09:22:14'),(3,'Festival Tahun Baru Islam 1 Muharram 1447 H','Auditorium Kampus Madani & Madrasah Diniyah An Nuur','2025-06-27','finished','2026-09-10 09:00:55','2026-09-10 09:22:14'),(4,'Gema Peringatan Maulid Nabi Muhammad SAW 1447 H','Gedung Pertemuan & Serbaguna Al-Hidayah','2025-09-05','finished','2026-09-10 09:00:55','2026-09-10 09:22:14'),(5,'Gebyar Hari Santri Nasional & Milad Pesantren 2025','Panggung Budaya Pesantren Luhur An Nuur','2025-10-22','inactive','2026-09-10 09:00:55','2026-11-25 07:32:55'),(6,'Lomba Cepat Tepat Santri Madrasah An Nuur 2026','Panggung Utama Madrasah An Nuur','2026-09-10','active','2026-09-10 09:00:55','2026-11-25 07:35:23');
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `match_teams`
--

DROP TABLE IF EXISTS `match_teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `match_teams` (
  `match_id` bigint(20) unsigned NOT NULL,
  `team_id` bigint(20) unsigned NOT NULL,
  `score` int(11) NOT NULL DEFAULT 0,
  `display_order` int(10) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`match_id`,`team_id`),
  KEY `fk_match_team_team` (`team_id`),
  CONSTRAINT `fk_match_team_match` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_match_team_team` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `match_teams`
--

LOCK TABLES `match_teams` WRITE;
/*!40000 ALTER TABLE `match_teams` DISABLE KEYS */;
INSERT INTO `match_teams` VALUES (1,1,350,1),(1,2,250,2),(1,3,150,3),(2,4,400,1),(2,5,300,2),(2,6,150,3),(3,7,350,1),(3,8,250,2),(3,9,200,3),(4,10,425,1),(4,11,350,2),(4,12,225,3),(5,13,450,1),(5,14,300,2),(5,15,150,3),(6,16,100,1),(6,17,0,2),(6,18,0,3),(7,13,0,2),(7,14,0,3),(7,15,0,1),(8,16,50,2),(8,17,150,3),(8,18,100,4),(8,19,100,1);
/*!40000 ALTER TABLE `match_teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matches`
--

DROP TABLE IF EXISTS `matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matches` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `round_id` bigint(20) unsigned NOT NULL,
  `current_question` int(10) unsigned NOT NULL DEFAULT 0,
  `status` varchar(30) NOT NULL DEFAULT 'ready',
  `buzzer_team_id` bigint(20) unsigned DEFAULT NULL,
  `question_opened_at` datetime(6) DEFAULT NULL,
  `buzzed_at` datetime(6) DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_match_buzzer_team` (`buzzer_team_id`),
  KEY `idx_match_round_status` (`round_id`,`status`),
  CONSTRAINT `fk_match_buzzer_team` FOREIGN KEY (`buzzer_team_id`) REFERENCES `teams` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_match_round` FOREIGN KEY (`round_id`) REFERENCES `rounds` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matches`
--

LOCK TABLES `matches` WRITE;
/*!40000 ALTER TABLE `matches` DISABLE KEYS */;
INSERT INTO `matches` VALUES (1,1,10,'finished',NULL,NULL,NULL,'2025-01-27 15:45:00','2026-09-10 09:00:55','2026-09-10 09:00:55'),(2,2,12,'finished',NULL,NULL,NULL,'2025-03-18 16:35:00','2026-09-10 09:00:55','2026-09-10 09:00:55'),(3,3,10,'finished',NULL,NULL,NULL,'2025-06-27 11:30:00','2026-09-10 09:00:55','2026-09-10 09:00:55'),(4,4,12,'finished',NULL,NULL,NULL,'2025-09-05 21:15:00','2026-09-10 09:00:55','2026-09-10 09:00:55'),(5,5,12,'finished',NULL,NULL,NULL,'2025-10-22 20:30:00','2026-09-10 09:00:55','2026-09-10 09:00:55'),(6,6,1,'finished',NULL,NULL,NULL,'2026-11-25 14:35:35','2026-09-10 09:00:55','2026-11-25 07:35:35'),(7,5,0,'finished',NULL,NULL,NULL,'2026-11-25 14:32:46','2026-11-25 07:26:36','2026-11-25 07:32:46'),(8,6,7,'judged',17,'2026-11-25 14:45:29.199691','2026-11-25 14:45:30.178074',NULL,'2026-11-25 07:35:55','2026-11-25 07:45:31');
/*!40000 ALTER TABLE `matches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rounds`
--

DROP TABLE IF EXISTS `rounds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rounds` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `event_id` bigint(20) unsigned NOT NULL,
  `name` varchar(120) NOT NULL,
  `display_order` int(10) unsigned NOT NULL DEFAULT 1,
  `correct_score` int(11) NOT NULL,
  `wrong_score` int(11) NOT NULL DEFAULT 0,
  `answer_seconds` int(10) unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_round_event` (`event_id`,`display_order`),
  CONSTRAINT `fk_round_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rounds`
--

LOCK TABLES `rounds` WRITE;
/*!40000 ALTER TABLE `rounds` DISABLE KEYS */;
INSERT INTO `rounds` VALUES (1,1,'Babak Final Rebutan Sirah & Tarikh Mi\'raj',1,100,-50,10,'2026-09-10 09:00:55'),(2,2,'Babak Final Rebutan Cepat Tepat Ramadhan',1,100,-50,10,'2026-09-10 09:00:55'),(3,3,'Babak Rebutan Tarikh Hijrah & Penanggalan Islam',1,100,-50,10,'2026-09-10 09:00:55'),(4,4,'Babak Cepat Tepat Sirah Nabawiyah & Akhlaqul Karimah',1,100,-25,12,'2026-09-10 09:00:55'),(5,5,'Babak Final Cerdas Cermat Kitab Kuning & Resolusi Jihad',1,100,-50,10,'2026-09-10 09:00:55'),(6,6,'Babak Rebutan Cepat Tepat Pengetahuan Agama',1,100,-50,10,'2026-09-10 09:00:55');
/*!40000 ALTER TABLE `rounds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `score_events`
--

DROP TABLE IF EXISTS `score_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `score_events` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `match_id` bigint(20) unsigned NOT NULL,
  `team_id` bigint(20) unsigned NOT NULL,
  `operator_id` bigint(20) unsigned NOT NULL,
  `score_before` int(11) NOT NULL,
  `delta` int(11) NOT NULL,
  `score_after` int(11) NOT NULL,
  `reason` varchar(160) NOT NULL,
  `reversed_at` datetime DEFAULT NULL,
  `reversed_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_score_team` (`team_id`),
  KEY `fk_score_operator` (`operator_id`),
  KEY `fk_score_reversed_by` (`reversed_by`),
  KEY `idx_score_match_time` (`match_id`,`id`),
  CONSTRAINT `fk_score_match` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_score_operator` FOREIGN KEY (`operator_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_score_reversed_by` FOREIGN KEY (`reversed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_score_team` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `score_events`
--

LOCK TABLES `score_events` WRITE;
/*!40000 ALTER TABLE `score_events` DISABLE KEYS */;
INSERT INTO `score_events` VALUES (1,1,1,1,0,100,100,'Jawaban benar soal 1 (Perjalanan Malam Isra)',NULL,NULL,'2025-01-27 08:10:00'),(2,1,2,1,0,100,100,'Jawaban benar soal 2 (Perintah Shalat 5 Waktu)',NULL,NULL,'2025-01-27 08:14:00'),(3,1,3,1,0,100,100,'Jawaban benar soal 3 (Nama Langit Tingkat Ketujuh)',NULL,NULL,'2025-01-27 08:18:00'),(4,1,1,1,100,100,200,'Jawaban benar soal 5 (Nabi yang Ditemui di Langit Keenam)',NULL,NULL,'2025-01-27 08:25:00'),(5,1,2,1,100,100,200,'Jawaban benar soal 7 (Masjidil Aqsha & Baitul Maqdis)',NULL,NULL,'2025-01-27 08:32:00'),(6,1,3,1,100,100,200,'Jawaban benar soal 8 (Surah Al-Isra Ayat 1)',NULL,NULL,'2025-01-27 08:36:00'),(7,1,3,1,200,-50,150,'Jawaban salah soal rebutan 9 (Tahun Terjadinya Isra Mi\'raj)',NULL,NULL,'2025-01-27 08:40:00'),(8,1,1,1,200,100,300,'Jawaban benar soal rebutan 9 lemparan',NULL,NULL,'2025-01-27 08:41:00'),(9,1,2,1,200,50,250,'Jawaban separuh tepat soal bonus',NULL,NULL,'2025-01-27 08:43:00'),(10,1,1,1,300,50,350,'Jawaban penutup babak rebutan final',NULL,NULL,'2025-01-27 08:44:30'),(11,2,4,1,0,100,100,'Jawaban benar soal 1 (Malam Lailatul Qadr)',NULL,NULL,'2025-03-18 09:05:00'),(12,2,5,1,0,100,100,'Jawaban benar soal 2 (Hukum Fiqih Puasa Musafir)',NULL,NULL,'2025-03-18 09:09:00'),(13,2,6,1,0,100,100,'Jawaban benar soal 3 (Nuzulul Qur\'an di Gua Hira)',NULL,NULL,'2025-03-18 09:13:00'),(14,2,4,1,100,100,200,'Jawaban benar soal 5 (Zakat Fitrah & Takaran Sha\')',NULL,NULL,'2025-03-18 09:18:00'),(15,2,5,1,100,100,200,'Jawaban benar soal 7 (Ayat Pertama Turun QS Al-Alaq 1-5)',NULL,NULL,'2025-03-18 09:22:00'),(16,2,4,1,200,100,300,'Jawaban benar soal rebutan 9',NULL,NULL,'2025-03-18 09:26:00'),(17,2,6,1,100,-50,50,'Jawaban salah soal rebutan 10 (Fidyah Puasa)',NULL,NULL,'2025-03-18 09:29:00'),(18,2,5,1,200,100,300,'Jawaban benar soal rebutan 11',NULL,NULL,'2025-03-18 09:31:00'),(19,2,6,1,50,100,150,'Jawaban benar soal penutup 12',NULL,NULL,'2025-03-18 09:33:00'),(20,2,4,1,300,100,400,'Kunci kemenangan soal rebutan terakhir',NULL,NULL,'2025-03-18 09:34:30'),(21,3,7,1,0,100,100,'Jawaban benar soal 1 (Penetapan Kalender Khalifah Umar)',NULL,NULL,'2025-06-27 04:05:00'),(22,3,8,1,0,100,100,'Jawaban benar soal 2 (Puasa Asyura 10 Muharram)',NULL,NULL,'2025-06-27 04:09:00'),(23,3,9,1,0,100,100,'Jawaban benar soal 3 (Perjalanan Hijrah ke Madinah)',NULL,NULL,'2025-06-27 04:13:00'),(24,3,7,1,100,100,200,'Jawaban benar soal 5 (Masjid Quba Pertama Dibangun)',NULL,NULL,'2025-06-27 04:18:00'),(25,3,9,1,100,100,200,'Jawaban benar soal 7 (Piagam Madinah)',NULL,NULL,'2025-06-27 04:22:00'),(26,3,8,1,100,100,200,'Jawaban benar soal rebutan 8',NULL,NULL,'2025-06-27 04:25:00'),(27,3,8,1,200,50,250,'Jawaban separuh tepat soal rebutan 9',NULL,NULL,'2025-06-27 04:27:00'),(28,3,7,1,200,150,350,'Jawaban sempurna soal penutup 10',NULL,NULL,'2025-06-27 04:29:30'),(29,4,10,1,0,100,100,'Jawaban benar soal 1 (Tahun Gajah & Pasukan Abrahah)',NULL,NULL,'2025-09-05 13:30:00'),(30,4,11,1,0,100,100,'Jawaban benar soal 2 (Ibunda Halimah As-Sa\'diyah)',NULL,NULL,'2025-09-05 13:35:00'),(31,4,12,1,0,100,100,'Jawaban benar soal 3 (Gelar Al-Amin Saat Renovasi Ka\'bah)',NULL,NULL,'2025-09-05 13:40:00'),(32,4,10,1,100,100,200,'Jawaban benar soal 5 (Perdagangan ke Negeri Syam)',NULL,NULL,'2025-09-05 13:46:00'),(33,4,11,1,100,100,200,'Jawaban benar soal 6 (Sayyidah Khadijah Al-Kubra)',NULL,NULL,'2025-09-05 13:50:00'),(34,4,12,1,100,100,200,'Jawaban benar soal 8 (Kitab Maulid Al-Barzanji & Simtuddurar)',NULL,NULL,'2025-09-05 13:56:00'),(35,4,11,1,200,100,300,'Jawaban benar soal 9 (Fathu Makkah)',NULL,NULL,'2025-09-05 14:01:00'),(36,4,10,1,200,100,300,'Jawaban benar soal rebutan 10',NULL,NULL,'2025-09-05 14:05:00'),(37,4,11,1,300,50,350,'Jawaban separuh tepat soal 11',NULL,NULL,'2025-09-05 14:09:00'),(38,4,12,1,200,25,225,'Poin tambahan soal pelengkap 11',NULL,NULL,'2025-09-05 14:10:00'),(39,4,10,1,300,125,425,'Jawaban sempurna soal pamungkas Sirah',NULL,NULL,'2025-09-05 14:14:00'),(40,5,13,1,0,100,100,'Jawaban benar soal 1 (Sejarah Resolusi Jihad 22 Oktober 1945)',NULL,NULL,'2025-10-22 12:40:00'),(41,5,14,1,0,100,100,'Jawaban benar soal 2 (Kitab Fathul Qarib Bab Thaharah)',NULL,NULL,'2025-10-22 12:45:00'),(42,5,15,1,0,100,100,'Jawaban benar soal 3 (Muqaddimah Ibnu Khaldun)',NULL,NULL,'2025-10-22 12:50:00'),(43,5,13,1,100,100,200,'Jawaban benar soal 5 (Matan Al-Jurumiyyah & I\'rab)',NULL,NULL,'2025-10-22 12:57:00'),(44,5,14,1,100,100,200,'Jawaban benar soal 7 (Kitab Ta\'limul Muta\'allim)',NULL,NULL,'2025-10-22 13:04:00'),(45,5,13,1,200,100,300,'Jawaban benar soal rebutan 9 (Ulama Nusantara di Haramain)',NULL,NULL,'2025-10-22 13:12:00'),(46,5,15,1,100,50,150,'Jawaban separuh tepat soal 10',NULL,NULL,'2025-10-22 13:18:00'),(47,5,14,1,200,100,300,'Jawaban benar soal rebutan 11',NULL,NULL,'2025-10-22 13:23:00'),(48,5,13,1,300,150,450,'Jawaban mutlak soal pamungkas Resolusi Jihad',NULL,NULL,'2025-10-22 13:28:30'),(49,8,19,1,0,-50,-50,'Jawaban salah','2026-11-25 14:44:37',1,'2026-11-25 07:44:26'),(50,8,17,1,0,100,100,'Jawaban benar',NULL,NULL,'2026-11-25 07:44:56'),(51,8,19,1,0,100,100,'Jawaban benar',NULL,NULL,'2026-11-25 07:45:03'),(52,8,16,1,0,100,100,'Jawaban benar',NULL,NULL,'2026-11-25 07:45:08'),(53,8,18,1,0,100,100,'Jawaban benar',NULL,NULL,'2026-11-25 07:45:14'),(54,8,16,1,100,-50,50,'Jawaban salah',NULL,NULL,'2026-11-25 07:45:20'),(55,8,17,1,100,100,200,'Jawaban benar',NULL,NULL,'2026-11-25 07:45:26'),(56,8,17,1,200,-50,150,'Jawaban salah',NULL,NULL,'2026-11-25 07:45:31');
/*!40000 ALTER TABLE `score_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `teams` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `event_id` bigint(20) unsigned NOT NULL,
  `name` varchar(120) NOT NULL,
  `members` text DEFAULT NULL,
  `access_code` varchar(32) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_team_code_per_event` (`event_id`,`access_code`),
  KEY `idx_team_event` (`event_id`,`is_active`),
  CONSTRAINT `fk_team_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teams`
--

LOCK TABLES `teams` WRITE;
/*!40000 ALTER TABLE `teams` DISABLE KEYS */;
INSERT INTO `teams` VALUES (1,1,'Regu Al-Quds','Ahmad Fauzi (Juru Bicara), Zidan Pratama, Bilal Ramadhan','QUDS01',1,'2026-09-10 09:00:55'),(2,1,'Regu Sidratul Muntaha','Hanif Rabbani (Juru Bicara), Rayhan Ilham, Naufal Hakim','SIDRA2',1,'2026-09-10 09:00:55'),(3,1,'Regu Buraq Elit','Fathur Rahman (Juru Bicara), Haidar Ali, Salman Al-Farisi','BURAQ3',1,'2026-09-10 09:00:55'),(4,2,'Regu Al-Furqan','Thoriq Ziyad (Juru Bicara), Daffa Izzuddin, Yusuf Mansur','FURQN1',1,'2026-09-10 09:00:55'),(5,2,'Regu Al-Fatih','Faris Abdillah (Juru Bicara), Lukman Hakim, Ammar Yasir','FATIH2',1,'2026-09-10 09:00:55'),(6,2,'Regu Al-Kautsar','Ihsan Kamil (Juru Bicara), Arkan Syahputra, Ghaisan Robbani','KAUTS3',1,'2026-09-10 09:00:55'),(7,3,'Regu Anshar','Abdullah Azzam (Juru Bicara), Fikri Hamdani, Fadhil Muzakki','ANSHR1',1,'2026-09-10 09:00:55'),(8,3,'Regu Muhajirin','M. Ridwan (Juru Bicara), Anas Al-Ayyubi, Hilman Syakir','MUHAJ2',1,'2026-09-10 09:00:55'),(9,3,'Regu Al-Yatsrib','Faiz Syahbana (Juru Bicara), Mirza Ghulam, Irsyadul Ibad','YATSR3',1,'2026-09-10 09:00:55'),(10,4,'Regu Madinah Al-Munawwarah','Harits Al-Bantani (Juru Bicara), Ilham Maulana, Wildan Mukhallad','MADIN1',1,'2026-09-10 09:00:55'),(11,4,'Regu Makkah Al-Mukarramah','Dzaki Rahmatullah (Juru Bicara), Basyir Al-Ghazali, Farhan Makarim','MAKKA2',1,'2026-09-10 09:00:55'),(12,4,'Regu Baitul Maqdis','Rasyid Shiddiq (Juru Bicara), Nabil Mubarak, Akram Hidayat','MAQDS3',1,'2026-09-10 09:00:55'),(13,5,'Regu Hasyim Asy\'ari','Zainul Arifin (Juru Bicara), Gus Wahid, Bahauddin','HASYM1',1,'2026-09-10 09:00:55'),(14,5,'Regu Wahab Chasbullah','Bisri Syansuri (Juru Bicara), As\'ad Syamsul, Idham Chalid','WAHAB2',1,'2026-09-10 09:00:55'),(15,5,'Regu Ahmad Dahlan','Fachrudin (Juru Bicara), Syamsul Arifin, AR Fachruddin','DAHLN3',1,'2026-09-10 09:00:55'),(16,6,'Regu Abu Bakar Ash-Shiddiq','M. Zaki (Juru Bicara), Rifqi Ramadhan, Dimas Prasetya','ABU01',1,'2026-09-10 09:00:55'),(17,6,'Regu Umar bin Khattab','Fauzan Adhim (Juru Bicara), Reza Pahlevi, Danang Wijaya','UMAR02',1,'2026-09-10 09:00:55'),(18,6,'Regu Utsman bin Affan','Rian Hidayat (Juru Bicara), Surya Kencana, Bintang Pratama','UTSM03',1,'2026-09-10 09:00:55'),(19,6,'Masyaallah','Zidan, Adul, Hanif','MAS01',1,'2026-11-25 07:23:54'),(20,5,'Masyaallah','Zidan, Adul, Hanif','MASYA1',1,'2026-11-25 07:28:04');
/*!40000 ALTER TABLE `teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `username` varchar(80) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` varchar(30) NOT NULL DEFAULT 'operator',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Operator Demo','admin','$2y$12$fc6vT4ergl/1KC5ICds98.42BQxx4s.fjsDz9m3D7gQ6uw1p/HhLu','admin','2026-09-10 07:58:12');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-25 17:02:07
