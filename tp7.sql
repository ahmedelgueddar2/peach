-- Active: 1700816573311@@127.0.0.1@3306@tp7
CREATE DATABASE tp7;
USE tp7;
CREATE TABLE agences (
    Num_Agence INT PRIMARY KEY,
    Nom_Agence VARCHAR(255),
    Ville_Agence VARCHAR(255),
    Actif_Agence BOOLEAN,
    taux_Actif DECIMAL(10, 2),
    total_Actif DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE clients (
    Num_Client INT PRIMARY KEY,
    Nom_Client VARCHAR(255),
    Prenom_Client VARCHAR(255),
    sexe CHAR(1),
    Ville_Client VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE comptes (
    Num_Compte INT PRIMARY KEY,
    Solde_Compte DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    Num_Client INT,
    Num_Agence INT,
    FOREIGN KEY (Num_Client) REFERENCES clients(Num_Client),
    FOREIGN KEY (Num_Agence) REFERENCES agences(Num_Agence)
);
CREATE TABLE emprunts (
    Num_Emprunt INT PRIMARY KEY,
    Montant_Emprunt DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    Num_Client INT,
    Num_Agence INT,
    FOREIGN KEY (Num_Client) REFERENCES clients(Num_Client),
    FOREIGN KEY (Num_Agence) REFERENCES agences(Num_Agence)
);
CREATE TABLE emprunts_supprimees (
    Num_Emprunt INT,
    Montant_Emprunt DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    Num_Client INT,
    Num_Agence INT,
    FOREIGN KEY (Num_Client) REFERENCES clients(Num_Client),
    FOREIGN KEY (Num_Agence) REFERENCES agences(Num_Agence)
);
DELIMITER;
CREATE TRIGGER emprunts_supprimees_trigger
AFTER DELETE ON emprunts
FOR EACH ROW
BEGIN
    INSERT INTO emprunts_supprimees (Num_Emprunt, Montant_Emprunt, created_at, updated_at, Num_Client, Num_Agence)
    VALUES (OLD.Num_Emprunt, OLD.Montant_Emprunt, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, OLD.Num_Client, OLD.Num_Agence);
END;
CREATE TABLE audit_comptes (
    Id INT ,
    date_op DATE,
    nb_insert INT,
    nb_update INT,
    nb_delete INT
);
DELIMITER;
CREATE TABLE emprunts_supprimees (
    Num_Emprunt INT PRIMARY KEY,
    Montant_Emprunt DECIMAL(10, 2));

CREATE TRIGGER emprunts_supprimees_trigger
AFTER DELETE ON emprunts
FOR EACH ROW
INSERT INTO emprunts_supprimees (Num_Emprunt, Montant_Emprunt)
VALUES (OLD.Num_Emprunt, OLD.Montant_Emprunt);

INSERT INTO agences (Num_Agence, Nom_Agence, Ville_Agence, Actif_Agence, taux_Actif, total_Actif) VALUES
(1, 'Agence Casablanca', 'Casablanca', true, 0.05, 120000),
(2, 'Agence Rabat', 'Rabat', true, 0.03, 90000),
(3, 'Agence Marrakech', 'Marrakech', false, 0.01, 60000),
(4, 'Agence Fès', 'Fès', true, 0.04, 75000),
(5, 'Agence Tanger', 'Tanger', true, 0.02, 85000);

INSERT INTO clients (Num_Client, Nom_Client, Prenom_Client, sexe, Ville_Client) VALUES
(1, 'El Amrani', 'Ahmed', 'M', 'Casablanca'),
(2, 'Bouhaddi', 'Fatima', 'F', 'Rabat'),
(3, 'Ouazzani', 'Karim', 'M', 'Marrakech'),
(4, 'Zerhouni', 'Sara', 'F', 'Fès'),
(5, 'Benali', 'Youssef', 'M', 'Tanger');

INSERT INTO comptes (Num_Compte, Solde_Compte, Num_Client, Num_Agence) VALUES
(101, 8000, 1, 1),
(102, 12000, 2, 2),
(103, 15000, 3, 3),
(104, 6000, 4, 4),
(105, 9000, 5, 5);


INSERT INTO emprunts (Num_Emprunt, Montant_Emprunt, Num_Client, Num_Agence) VALUES
(201, 10000, 1, 1),
(202, 5000, 2, 2),
(203, 15000, 3, 3),
(204, 8000, 4, 4),
(205, 12000, 5, 5);

DROP TABLE audit_comptes

CREATE TABLE audit_comptes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    operation_type VARCHAR(10) , 
    table_name VARCHAR(255) ,
    operation_date DATE 
);


CREATE TRIGGER comptes_inserees_trigger
AFTER INSERT ON emprunts
FOR EACH ROW
INSERT INTO audit_comptes (operation_type, table_name, operation_date)
VALUES ('INSERT', 'emprunts', CURDATE());


CREATE TRIGGER comptes_supprimees_trigger
AFTER DELETE ON emprunts
FOR EACH ROW
INSERT INTO audit_comptes (operation_type, table_name, operation_date)
VALUES ('DELETE', 'emprunts', CURDATE());


CREATE TRIGGER comptes_modifiees_trigger
AFTER UPDATE ON emprunts
FOR EACH ROW
INSERT INTO audit_comptes (operation_type, table_name, operation_date)
VALUES ('UPDATE', 'emprunts', CURDATE());

C

