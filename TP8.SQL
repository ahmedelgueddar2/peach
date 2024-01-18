-- Active: 1697646682784@@127.0.0.1@3306@trigger3
CREATE TRIGGER VerifierEffectifMax
BEFORE INSERT ON Inscription
FOR EACH ROW
BEGIN
  DECLARE effectif_actuel INT;
  SELECT COUNT(*) INTO effectif_actuel FROM Inscription WHERE cnom = NEW.cnom;
  IF effectif_actuel >= 30 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Effectif maximum atteint pour ce cours';
  END IF;
END;



CREATE TRIGGER VerifierNombreCours
BEFORE INSERT ON Cours
FOR EACH ROW
BEGIN
  DECLARE nombre_cours INT;
  SELECT COUNT(*) INTO nombre_cours FROM Cours WHERE pid = NEW.pid;
  IF NEW.depid = 33 AND nombre_cours >= 3 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Les enseignants du département 33 ne peuvent pas enseigner plus de trois cours';
  END IF;
END;



CREATE TRIGGER InscriptionInformatiqueTheorique
AFTER INSERT ON Etudiant
FOR EACH ROW
INSERT INTO Inscription (eid, cnom) VALUES (NEW.eid, 'informatique théorique');



CREATE TRIGGER VerifierNombreEnseignants
BEFORE INSERT ON Professeur
FOR EACH ROW
BEGIN
  DECLARE nombre_enseignants INT;
  SELECT COUNT(*) INTO nombre_enseignants FROM Professeur WHERE depid = NEW.depid;
  IF nombre_enseignants >= 10 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Le département a atteint le nombre maximum d\'enseignants';
  END IF;
END;



CREATE TRIGGER VerifierNombreEtudiants
AFTER INSERT ON Inscription
FOR EACH ROW
BEGIN
  DECLARE nombre_etudiants_base_de_donnees INT;
  DECLARE nombre_etudiants_mathematiques INT;
  SELECT COUNT(*) INTO nombre_etudiants_base_de_donnees FROM Inscription WHERE section = 'base de données';
  SELECT COUNT(*) INTO nombre_etudiants_mathematiques FROM Inscription WHERE section = 'Mathématiques';
  IF nombre_etudiants_base_de_donnees <= nombre_etudiants_mathematiques THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Le nombre d\'élèves inscrits en base de données doit être supérieur au nombre d\'élèves en mathématiques';
  END IF;
END;



CREATE TRIGGER VerifierNombreInscriptions
AFTER INSERT ON Inscription
FOR EACH ROW
BEGIN
  DECLARE nombre_inscriptions_departement_33 INT;
  DECLARE nombre_inscriptions_mathematiques INT;
  SELECT COUNT(*) INTO nombre_inscriptions_departement_33 FROM Inscription i JOIN Cours c ON i.cnom = c.cnom WHERE c.pid IN (SELECT pid FROM Professeur WHERE depid = 33);
  SELECT COUNT(*) INTO nombre_inscriptions_mathematiques FROM Inscription WHERE section = 'Mathématiques';
  IF nombre_inscriptions_departement_33 <= nombre_inscriptions_mathematiques THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Le nombre d\'inscriptions aux cours du département 33 doit être supérieur au nombre d\'inscriptions en mathématiques';
  END IF;
END;





-- CREATE TRIGGER VerifierSalleEnseignement
-- BEFORE INSERT ON Cours
-- FOR EACH ROW
-- BEGIN
--   DECLARE salle_occupee INT;
--   SELECT COUNT(*) INTO salle_occupee FROM Cours WHERE salle = NEW.salle AND pid IN (SELECT pid FROM Professeur WHERE depid != NEW.depid);
--   IF salle_occupee > 0 THEN
--     SIGNAL SQLSTATE '45000'
--     SET MESSAGE_TEXT = 'La salle est déjà occupée par un professeur d\'un autre département';
--   END IF;
-- END;

