   ALTER USER 'root'@'localhost' IDENTIFIED BY 'votre_mot_de_passe';
   

   CREATE USER 'userT'@'localhost' IDENTIFIED BY 'mot_de_passe';
   CREATE USER 'userclient'@'localhost' IDENTIFIED BY 'mot_de_passe';
   CREATE USER 'usercom'@'localhost' IDENTIFIED BY 'mot_de_passe';
   CREATE USER 'userarticle'@'localhost' IDENTIFIED BY 'mot_de_passe';
   


   ALTER USER 'userT'@'localhost' IDENTIFIED BY 'nouveau_mot_de_passe';
   


   RENAME USER 'usercom'@'localhost' TO 'usercommande'@'localhost';
   
   mysql -u utilisateur -p
   

   CREATE TABLE magasin.test (num INT, nom VARCHAR(20));
   


   GRANT ALL PRIVILEGES ON magasin.* TO 'userT'@'localhost';
   

   GRANT ALL PRIVILEGES ON magasin.client TO 'userclient'@'localhost';
   GRANT SELECT ON magasin.* TO 'userclient'@'localhost';
   


   GRANT ALL PRIVILEGES ON magasin.commande TO 'usercommande'@'localhost';
   GRANT SELECT ON magasin.* TO 'usercommande'@'localhost';
   

2-4) Pour userarticle, droits totaux sur la table article et SELECT sur les autres :
   sql
   GRANT ALL PRIVILEGES ON magasin.article TO 'userarticle'@'localhost';
   GRANT SELECT ON magasin.* TO 'userarticle'@'localhost';
   

2-5) En tant que userT, vous ne pourrez pas donner des droits que vous n'avez pas. Connectez-vous avec un utilisateur ayant les droits nécessaires.

2-6) Pour retirer tous les droits à userarticle :
   sql
   REVOKE ALL PRIVILEGES ON magasin.* FROM 'userarticle'@'localhost';
   

Assurez-vous d'ajuster les commandes en fonction de votre configuration exacte.