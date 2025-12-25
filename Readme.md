# 🧩 Kotlin Monsters – Sprint 3 : Base de Données & DAO

## 🎯 Contexte

Le **Sprint 3** vise à connecter le projet *Kotlin Monsters* à une **base de données relationnelle** (MySQL/MariaDB).  
Avant ce sprint, toutes les données (entraîneurs, monstres, espèces) étaient définies dans le code (`Main.kt`).  
L’objectif est maintenant de :

- 💾 Centraliser et stocker les données dans une BDD
- ⚙️ Automatiser les opérations **CRUD** (Create, Read, Update, Delete)
- 🧠 Utiliser un **DAO** (*Data Access Object*) pour simplifier les interactions avec la base
- 🔄 Charger dynamiquement les données dans le jeu

---

## 🧱 Étape 1 — Création de la base de données

1. Connectez-vous à votre serveur MySQL/MariaDB et créez la base :

```sql
CREATE DATABASE db_monsters_monlogin;
USE db_monsters_monlogin;
```
2. Dans IntelliJ IDEA :
Database > New > Data Source > MariaDB
Renseignez les identifiants et testez la connexion.

Créez un fichier resources/tables.sql avec vos tables :
```sql
CREATE TABLE Entraineurs(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255),
    argents INTEGER
);
```
---

## 🧬 Étape 2 — Création des tables principales

Convertissez les classes Kotlin en entités SQL :

EspeceMonstre
IndividuMonstre
Entraineur
Zone

Créez un diagramme ERD (PlantUML) pour visualiser les relations.
Ajoutez les tables correspondantes dans tables.sql.
---

## 🌱 Étape 3 — Insertion de données de base

Exemple d’insertion pour tester la base :
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
---

## ⚙️ Étape 4 — Connexion à la base dans Kotlin

Ajoutez la dépendance JDBC dans build.gradle.kts :
```kotlin
implementation("mysql:mysql-connector-java:8.0.33")
```

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
}

// Test de connexion
val db = BDD()
db.close()
```

## 🧪 Étape 5 — Tests unitaires de la connexion
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
}
```
---

## 🧩 Étape 6 — DAO : Gestion des entraîneurs

Création de EntraineurDAO.kt avec :

findByNom : fun findByNom(nom: String): Entraineur?
save : fun save(entraineur: Entraineur): Int
saveAll : fun saveAll(entraineurs: List<Entraineur>): List<Int>
deleteById : fun deleteById(id: Int): Boolean

---

## 🔄 Étape 7 — DAO des autres entités

Pour chaque entité :

EspeceMonstreDAO
IndividuMonstreDAO
ZoneDAO

Chaque DAO propose :

findAll()
findById(id: Int)
save(entity)
deleteById(id)

---
## 🔗 Étape 8 — Intégration dans Main.kt
```kotlin
fun main() {
    val bdd = BDD()
    val entraineurDAO = EntraineurDAO(bdd)

    val entraineurs = entraineurDAO.findAll()
    entraineurs.forEach { println(it) }

    val nouveau = Entraineur(0, "Dylan", 2000)
    entraineurDAO.save(nouveau)

    bdd.close()
}
```
---
🧪 Étape 9 — Tests unitaires des DAO
@Test
fun testFindAllEntraineurs() {
    val bdd = BDD()
    val dao = EntraineurDAO(bdd)
    val entraineurs = dao.findAll()

    assertTrue(entraineurs.isNotEmpty())
    assertTrue(entraineurs.any { it.nom == "Alice" })

    bdd.close()
}

---

## 📦 Structure finale du Sprint 3

```css
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
```
---

## 🚀 Objectifs atteints

✅ Connexion JDBC fonctionnelle
✅ Base de données correctement structurée
✅ DAO opérationnels (CRUD)
✅ Chargement dynamique des données
✅ Tests unitaires validés

🧠 Auteur

Josue Kialengela-Tazi
Fin
