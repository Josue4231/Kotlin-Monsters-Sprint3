# 🧩 Kotlin Monsters – Sprint 3 : Base de Données & DAO

## 🎯 Contexte

Ce troisième sprint a pour objectif d’introduire une connexion entre le projet *Kotlin Monsters* et une base de données relationnelle MySQL/MariaDB.

Jusqu’à présent, les données (entraîneurs, monstres, espèces…) étaient créées directement dans le code (`Main.kt`).  
Le but de ce module est de :  
- Centraliser et stocker les données dans une base de données (BDD) ;
- Automatiser la création, la lecture, la mise à jour et la suppression (CRUD) de ces données via des objets Kotlin ;
- Utiliser un DAO (Data Access Object) pour simplifier les interactions entre le code et la BDD.

En fin de sprint, le projet sera capable de charger automatiquement les entraîneurs, espèces et monstres depuis la base de données, sans avoir à les recréer dans le code.

---

## 🧱 Étape 1 — Création de la base de données et des tables

1. Connectez-vous au serveur de base de données via votre terminal et créez la base :

```sql
CREATE DATABASE db_monsters_monlogin;

    Dans IntelliJ IDEA, configurez une connexion à la BDD :

        Database > New > Data Source > MariaDB

        Renseignez vos identifiants (IP, port, utilisateur, mot de passe).

        Téléchargez le driver si nécessaire et testez la connexion.

        Validez avec Apply > OK.

    Ouvrez une Query Console reliée à votre base.

    Créez un fichier tables.sql dans le dossier resources et copiez-y vos requêtes SQL de création/insertion.

    Exemple de création de table Entraineurs :

CREATE TABLE Entraineurs(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255),
    argents INTEGER
);

    ⚠️ Pensez à toujours commencer par créer les tables primaires (sans clés étrangères).

🧬 Étape 2 — Création des tables principales

    Transformez les classes Kotlin (EspeceMonstre, IndividuMonstre, Entraineur, Zone) en entités relationnelles.

    Représentez-les dans un diagramme ERD avec PlantUML.

    Complétez et ajoutez ce diagramme à votre projet et compte rendu.

    Créez les tables EspecesMonstre et IndividusMonstre en SQL.

    Ajoutez leurs requêtes dans tables.sql.

🌱 Étape 3 — Insertion des données de base

    Vérifiez que les tables existent bien dans la BDD.

    Insérez des données tests :

Exemple insertion entraîneurs :

INSERT INTO Entraineurs (nom, argents) VALUES ('Bob', 1000), ('Alice', 1200), ('Clara', 1500);

Exemple insertion espèces (extrait) :

INSERT INTO EspecesMonstre (id, nom, type, baseAttaque, baseDefense, baseVitesse, baseAttaqueSpe, baseDefenseSpe, basePv,
    modAttaque, modDefense, modVitesse, modAttaqueSpe, modDefenseSpe, modPv,
    description, particularites, caracteres) VALUES
(1, 'springleaf', 'Graine', 9, 11, 10, 12, 14, 60, 6.5, 9.0, 8.0, 7.0, 10.0, 14.0,
'Un petit monstre espiègle...', 'Sa feuille sur la tête...', 'Curieux, amical, un peu timide.'),
-- autres espèces...
;

    Ajoutez également des individusMonstre associés.

⚙️ Étape 4 — Connexion et gestion de la BDD dans Kotlin

    Ajoutez la dépendance JDBC MySQL dans build.gradle.kts via Maven Central.

    Créez une classe BDD dans le package jdbc :

class BDD(
    var url: String = "jdbc:mysql://localhost:3306/db_Monsters_monLogin",
    var user: String = "root",
    var password: String = ""
) {
    var connectionBDD: Connection? = null

    init {
        try {
            this.connectionBDD = getConnection()
        } catch (erreur: SQLException) {
            println("Erreur lors de la connexion à la base de données : ${erreur.message}")
        }
    }

    fun getConnection(): Connection? {
        Class.forName("com.mysql.cj.jdbc.Driver")
        return DriverManager.getConnection(url, user, password)
    }

    fun executePreparedStatement(preparedStatement: PreparedStatement): ResultSet? {
        return try {
            preparedStatement.executeQuery()
        } catch (erreur: SQLException) {
            println("Erreur lors de l'exécution de la requête : ${erreur.message}")
            null
        }
    }

    fun close() {
        this.connectionBDD?.close()
    }
}

    Testez la connexion dans Main.kt :

val db = BDD()
// Avant la fin du main()
db.close()

🧪 Étape 5 — Tests unitaires de la connexion

Exemple de test unitaire de la méthode executePreparedStatement :

@Test
fun executePreparedStatement() {
    val bdd = BDD()
    val sql = bdd.connectionBDD!!.prepareStatement("SELECT * FROM Entraineurs")
    val resultRequete = bdd.executePreparedStatement(sql)!!

    val dresseurs = mutableListOf<Entraineur>()
    while (resultRequete.next()) {
        val id = resultRequete.getInt("id")
        val nom = resultRequete.getString("nom")
        val argents = resultRequete.getInt("argents")
        dresseurs.add(Entraineur(id, nom, argents))
    }

    assertEquals(3, dresseurs.size)
}

🧠 Étape 6 — Création du DAO (Data Access Object)

Créez un package DAO puis une classe EntraineurDAO :

class EntraineurDAO(val bdd: BDD = db) {
    
    fun findAll(): MutableList<Entraineur> {
        val result = mutableListOf<Entraineur>()
        val sql = "SELECT * FROM Entraineurs"
        val requetePreparer = bdd.connectionBDD!!.prepareStatement(sql)
        val resultatRequete = bdd.executePreparedStatement(requetePreparer)

        if (resultatRequete != null) {
            while (resultatRequete.next()) {
                val id = resultatRequete.getInt("id")
                val nom = resultatRequete.getString("nom")
                val argents = resultatRequete.getInt("argents")
                result.add(Entraineur(id, nom, argents))
            }
        }
        requetePreparer.close()
        return result
    }

    fun findById(id: Int): Entraineur? {
        var result: Entraineur? = null
        val sql = "SELECT * FROM Entraineurs WHERE id = ?"
        val requetePreparer = bdd.connectionBDD!!.prepareStatement(sql)
        requetePreparer.setInt(1, id)
        val resultatRequete = bdd.executePreparedStatement(requetePreparer)

        if (resultatRequete != null && resultatRequete.next()) {
            val nom = resultatRequete.getString("nom")
            val argents = resultatRequete.getInt("argents")
            result = Entraineur(id, nom, argents)
        }
        requetePreparer.close()
        return result
    }

    // Autres méthodes CRUD : findByNom, save, saveAll, deleteById...
}
