package jdbc

import dresseur.Entraineur
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.Test

class BDDTest {
    @Test
    fun executePreparedStatement() {
        val bdd = BDD()

        // 2️⃣ Prépare une requête SQL pour récupérer toutes les lignes de la table "entraineurs"
        val sql = bdd.connectionBDD!!.prepareStatement("SELECT * FROM Entraineurs")

        // 3️⃣ Exécute la requête préparée via la méthode de la classe BDD
        val resultRequete = bdd.executePreparedStatement(sql)!!

        // 4️⃣ Liste temporaire pour stocker les résultats sous forme d'objets Entraineur
        val dresseurs = mutableListOf<Entraineur>()

        // 5️⃣ Parcourt le résultat ligne par ligne
        while (resultRequete.next()) {
            // Récupération des colonnes du résultat
            val id = resultRequete.getInt("id")
            val nom = resultRequete.getString("nom")
            val argents = resultRequete.getInt("argents")

            // Création d'un objet Entraineur à partir de la ligne et ajout à la liste
            dresseurs.add(Entraineur(id, nom, argents))
        }

        // 6️⃣ Vérifie qu’on a bien récupéré les 3 entraîneurs attendus dans la base
        assertEquals(3, dresseurs.size)

    }

}