CREATE TABLE Entraineurs(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255),
    argents INTEGER
);

CREATE TABLE EspeceMonstre (
     id INTEGER PRIMARY KEY AUTO_INCREMENT,
     nom VARCHAR(100) ,
     type VARCHAR(100),
     baseAttaque INT  ,
     baseDefense INT  ,
     baseVitesse INT  ,
     baseAttaqueSpe INT  ,
     baseDefenseSpe INT  ,
     basePv INT  ,
     modAttaque DOUBLE  ,
     modDefense DOUBLE  ,
     modVitesse DOUBLE ,
     modAttaqueSpe DOUBLE  ,
     modDefenseSpe DOUBLE  ,
     modPv DOUBLE  ,
     description TEXT ,
     particularites TEXT ,
     caracteres TEXT
);

CREATE TABLE IndividuMonstre (
                                 id INT PRIMARY KEY AUTO_INCREMENT,
                                 nom VARCHAR(255) NOT NULL,
                                 niveau INT,
                                 attaque INT,
                                 defense INT,
                                 vitesse INT,
                                 attaqueSpe INT,
                                 defenseSpe INT,
                                 pvMax INT,
                                 potentiel DOUBLE,
                                 exp DOUBLE,
                                 pv INT,
                                 espece_id INT,
                                 entraineur_equipe_id INT,
                                 entraineur_boite_id INT,
                                 FOREIGN KEY (espece_id) REFERENCES EspeceMonstre(id),
                                 FOREIGN KEY (entraineur_equipe_id) REFERENCES Entraineurs(id),
                                 FOREIGN KEY (entraineur_boite_id) REFERENCES Entraineurs(id)

);

INSERT INTO EspeceMonstre
(id, nom, type, baseAttaque, baseDefense, baseVitesse, baseAttaqueSpe, baseDefenseSpe, basePv,
 modAttaque, modDefense, modVitesse, modAttaqueSpe, modDefenseSpe, modPv,
 description, particularites, caracteres)
VALUES
    (1, 'springleaf', 'Graine', 9, 11, 10, 12, 14, 60,
     6.5, 9.0, 8.0, 7.0, 10.0, 14.0,
     'Un petit monstre espiègle au corps rond comme une graine. Il aime se cacher dans l’herbe haute et se dorer au soleil.',
     'Sa feuille sur la tête s’incline pour indiquer son humeur.',
     'Curieux, amical, un peu timide.'),

    (4, 'flamkip', 'Animal', 12, 8, 13, 16, 7, 50,
     10.0, 5.5, 9.5, 9.5, 6.5, 12.0,
     'Ce petit animal est toujours entouré d’une flamme dansante. Il déteste le froid et s’énerve facilement quand on tente d’éteindre son feu.',
     'Sa flamme change d’intensité selon son niveau d’énergie.',
     'Impulsif, joueur, loyal.'),

    (5, 'pyrokip', 'Animal', 18, 12, 15, 22, 11, 70,
     12.0, 8.0, 11.0, 12.5, 8.0, 15.0,
     'Pyrokip, l’évolution de Flamkip. Son feu est devenu intense et ses flammes sont capables de fondre la pierre. Fier et courageux, il protège son dresseur à tout prix.',
     'Ses flammes changent de couleur selon son humeur : rouge vif en colère, dorées quand il est calme.',
     'Fier, protecteur, explosif.'),

    (7, 'aquamy', 'Meteo', 10, 11, 9, 14, 14, 55,
     9.0, 10.0, 7.5, 12.0, 12.0, 13.5,
     'Une créature vaporeuse qui ressemble à un petit nuage. Les gouttes qui tombent de son corps sont pures et rafraîchissantes.',
     'Fait légèrement baisser la température autour de lui quand il s’endort.',
     'Calme, rêveur, mystérieux.'),

    (8, 'laoumi', 'Animal', 11, 10, 9, 8, 11, 58,
     11.0, 8.0, 7.0, 6.0, 11.5, 14.0,
     'Un petit ourson au pelage soyeux. Il adore se tenir debout et brandir ses petites pattes comme s’il dansait.',
     'Son grognement est plus mignon qu’effrayant, mais il devient redoutable pour défendre ses amis.',
     'Affectueux, protecteur, gourmand.'),

    (10, 'bugsyface', 'Insecte', 10, 13, 8, 7, 13, 45,
     7.0, 11.0, 6.5, 8.0, 11.5, 10.0,
     'Un insecte à la carapace luisante qui se déplace par petits bonds. Il communique en faisant vibrer ses antennes.',
     'Sa carapace devient plus dure après chaque mue, augmentant sa défense.',
     'Travailleur, sociable, infatigable.'),

    (13, 'galum', 'Mineral', 12, 15, 6, 8, 12, 55,
     9.0, 13.0, 4.0, 6.5, 10.5, 13.0,
     'Un golem ancien sculpté dans la pierre. Ses yeux s’illuminent d’une lueur mystérieuse quand il se met en garde.',
     'Peut rester immobile pendant des heures, le faisant passer pour une statue.',
     'Sérieux, stoïque, fiable.'
    );
-- Un springleaf pour Alice
INSERT INTO  IndividuMonstre
(nom, niveau, attaque, defense, vitesse, attaqueSpe, defenseSpe, pvMax, potentiel, exp, pv, espece_id, entraineur_equipe_id, entraineur_boite_id)
VALUES
    ('sprintleft',4,12,8,13,16,7,50,10.0,5.5,
     9.5,1,NULL,NULL);
-- Un aquamy pour Bob
INSERT INTO IndividuMonstre
(nom, niveau, attaque, defense, vitesse, attaqueSpe, defenseSpe, pvMax, potentiel, exp, pv, espece_id, entraineur_equipe_id, entraineur_boite_id)
VALUES
    ('aqualy',4,10,11,9,14,14,55,9.0,10.0,
     7.5,7,NULL,NULL);
--  bugsyface pour Bob
INSERT INTO IndividuMonstre
(nom, niveau, attaque, defense, vitesse, attaqueSpe, defenseSpe, pvMax, potentiel, exp, pv, espece_id, entraineur_equipe_id, entraineur_boite_id)
VALUES
    ('buggy',4,10,13,8,7,13,45,7.0,11.0,
      6.5,10,NULL,NULL);
-- flakip pour Clara

INSERT INTO IndividuMonstre
(nom, niveau, attaque, defense, vitesse, attaqueSpe, defenseSpe, pvMax, potentiel, exp, pv, espece_id, entraineur_equipe_id, entraineur_boite_id)
VALUES
    ('loki',4,12,8,13,16,7,50,10.0,5.5,
      9.5,4,NULL,NULL);

--  galum pour Clara
INSERT INTO IndividuMonstre
(nom, niveau, attaque, defense, vitesse, attaqueSpe, defenseSpe, pvMax, potentiel, exp, pv, espece_id, entraineur_equipe_id, entraineur_boite_id)
VALUES
    ('golom',4,12,8,13,16,7,50,10.0,5.5,
     9.5,13,NULL,NULL);

-- Entraineurs Bob Alice Clara
INSERT INTO Entraineurs
( nom, argents)
VALUES
    ('Bob', 1000),
    ('Clara', 1500),
    ('Alice', 3000);



