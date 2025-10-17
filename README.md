# 🧩 Kotlin Monsters – Sprint 3 : Base de Données & DAO

## 🎯 Contexte

Ce troisième sprint a pour objectif d’introduire une **connexion entre le projet _Kotlin Monsters_ et une base de données relationnelle MySQL/MariaDB.**

Jusqu’à présent, les données (entraîneurs, monstres, espèces…) étaient créées directement dans le code (`Main.kt`).  
Le but de ce module est de :

- 💾 Centraliser et stocker les données dans une base de données (BDD)
- ⚙️ Automatiser les opérations CRUD (Create, Read, Update, Delete)
- 🧠 Utiliser un DAO (*Data Access Object*) pour simplifier les interactions avec la BDD

En fin de sprint, le projet sera capable de **charger automatiquement** les entraîneurs, espèces et monstres depuis la base de données.

---

## 🧱 Étape 1 — Création de la base de données

1. Connectez-vous à votre serveur MySQL/MariaDB :
   ```sql
   CREATE DATABASE db_monsters_monlogin;

2. Dans IntelliJ IDEA, configurez une connexion :
Database > New > Data Source > MariaDB

Renseignez vos identifiants (IP, port, utilisateur, mot de passe)

Téléchargez le driver si nécessaire

Testez et validez la connexion

3. Créez un fichier resources/tables.sql contenant vos requêtes SQL.
   ```sql
CREATE TABLE Entraineurs(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255),
    argents INTEGER
);```
## 🧬 Étape 2 — Création des tables principales

Transformez les classes Kotlin suivantes en entités SQL :
EspeceMonstre
IndividuMonstre
Entraineur
Zone

Créez un diagramme ERD (PlantUML) pour représenter vos relations.
Ajoutez vos tables dans tables.sql.

## 🌱 Étape 3 — Insertion des données de base

Insérez quelques données de test :
```sql
INSERT INTO Entraineurs (nom, argents)
VALUES ('Bob', 1000), ('Alice', 1200), ('Clara', 1500);

INSERT INTO EspecesMonstre (id, nom, type, baseAttaque, baseDefense, baseVitesse, baseAttaqueSpe, baseDefenseSpe, basePv,
    modAttaque, modDefense, modVitesse, modAttaqueSpe, modDefenseSpe, modPv,
    description, particularites, caracteres)
VALUES
(1, 'springleaf', 'Graine', 9, 11, 10, 12, 14, 60, 6.5, 9.0, 8.0, 7.0, 10.0, 14.0,
'Un petit monstre espiègle...', 'Sa feuille sur la tête...', 'Curieux, amical, un peu timide.');
``` 
## ⚙️ Étape 4 — Connexion à la base dans Kotlin

Ajoutez la dépendance JDBC MySQL dans build.gradle.kts :
implementation("mysql:mysql-connector-java:8.0.33")

Créez une classe BDD.kt :
```kotlin
class BDD(
    var url: String = "jdbc:mysql://localhost:3306/db_monsters_monlogin",
    var user: String = "root",
    var password: String = ""
) {
    var connectionBDD: Connection? = null

    init {
        try {
            this.connectionBDD = getConnection()
        } catch (e: SQLException) {
            println("Erreur lors de la connexion : ${e.message}")
        }
    }

    fun getConnection(): Connection? {
        Class.forName("com.mysql.cj.jdbc.Driver")
        return DriverManager.getConnection(url, user, password)
    }

    fun executePreparedStatement(preparedStatement: PreparedStatement): ResultSet? =
        try { preparedStatement.executeQuery() }
        catch (e: SQLException) {
            println("Erreur d'exécution : ${e.message}")
            null
        }

    fun close() = connectionBDD?.close()
}```
Test de connexion :
val db = BDD()
db.close()

🧪 Étape 5 — Tests unitaires de la connexion
   ```kotlin
@Test
fun executePreparedStatement() {
    val bdd = BDD()
    val sql = bdd.connectionBDD!!.prepareStatement("SELECT * FROM Entraineurs")
    val result = bdd.executePreparedStatement(sql)!!

    val dresseurs = mutableListOf<Entraineur>()
    while (result.next()) {
        val id = result.getInt("id")
        val nom = result.getString("nom")
        val argents = result.getInt("argents")
        dresseurs.add(Entraineur(id, nom, argents))
    }

    assertEquals(3, dresseurs.size)
    bdd.close()
}``` 
## 🧩 Étape 6 — DAO : Gestion des entraîneurs
Création de EntraineurDAO.kt avec les méthodes suivantes :

🔍 findByNom
fun findByNom(nom: String): Entraineur? { ... }

💾 save
fun save(entraineur: Entraineur): Int { ... }

💾 saveAll
fun saveAll(entraineurs: List<Entraineur>): List<Int> { ... }

❌ deleteById
fun deleteById(id: Int): Boolean { ... }

## 🔄 Étape 7 — DAO des autres entités

Créez un DAO par entité pour séparer les responsabilités :

EspeceMonstreDAO
IndividuMonstreDAO
ZoneDAO
Chaque DAO doit proposer :
findAll()
findById(id: Int)
save(entity)
deleteById(id: Int)

## 🔗 Étape 8 — Intégration dans le Main.kt
```kotlin
fun main() {
    val bdd = BDD()
    val entraineurDAO = EntraineurDAO(bdd)

    val entraineurs = entraineurDAO.findAll()
    entraineurs.forEach { println(it) }

    val nouveau = Entraineur(0, "Dylan", 2000)
    entraineurDAO.save(nouveau)

    bdd.close()
}``` 
## 🧪 Étape 9 — Tests unitaires des DAO
```kotlin
@Test
fun testFindAllEntraineurs() {
    val bdd = BDD()
    val dao = EntraineurDAO(bdd)
    val entraineurs = dao.findAll()

    assertTrue(entraineurs.isNotEmpty())
    assertTrue(entraineurs.any { it.nom == "Alice" })

    bdd.close()
}``` 

📦 KotlinMonsters
├── src
│   ├── main
│   │   ├── kotlin
│   │   │   ├── dao
│   │   │   │   ├── EntraineurDAO.kt
│   │   │   │   └── EspeceMonstreDAO.kt
│   │   │   ├── jdbc
│   │   │   │   └── BDD.kt
│   │   │   ├── model
│   │   │   │   ├── Entraineur.kt
│   │   │   │   └── EspeceMonstre.kt
│   │   │   └── Main.kt
│   │   └── resources
│   │       └── tables.sql
│   └── test
│       └── kotlin
│           └── dao
│               └── EntraineurDAOTest.kt
└── build.gradle.kts

🚀 Objectifs du sprint

✅ Connexion JDBC fonctionnelle
✅ Base de données correctement structurée
✅ DAO opérationnels (CRUD)
✅ Chargement dynamique des données
✅ Tests unitaires validés

🧠 Auteur

Projet Kotlin Monsters – Sprint 3 : BDD & DAO
Développé dans le cadre d’un module Kotlin / POO / JDBC.

👤 Josue Kialengela-tazi

🌐 https://github.com/Josue4231/kotlin-Monsters

