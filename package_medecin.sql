CREATE OR REPLACE PACKAGE pkg_medecin AS
    ex_ser EXCEPTION;
    ex_sal EXCEPTION;
    ex_n EXCEPTION;
    ex_existe EXCEPTION;
    ex_null EXCEPTION;
    ex_introuvable EXCEPTION;
    PROCEDURE ajouter_medecin(
        idM IN Medecin.idMedecin%TYPE,
        nomM IN Medecin.nom%TYPE,
        Specialite IN Medecin.specialite%TYPE,
        salaire IN Medecin.Salaire%TYPE,
        idS IN Medecin.idService%TYPE
    );
    PROCEDURE modifier_medecin(
        idM IN Medecin.idMedecin%TYPE,
        nomM IN Medecin.nom%TYPE,
        Specialite IN Medecin.specialite%TYPE,
        salaire IN Medecin.Salaire%TYPE,
        idS IN Medecin.idService%TYPE
    );
    PROCEDURE supprimer_medecin (idM IN Medecin.idMedecin%TYPE);
    
    PROCEDURE afficher_medecin (idM IN  Medecin.idMedecin%TYPE);

    PROCEDURE afficher_rdv_medecin (p_idMedecin IN Medecin.idMedecin%TYPE);
END pkg_medecin;
/

CREATE OR REPLACE PACKAGE BODY pkg_medecin AS
    PROCEDURE ajouter_medecin (
        idM IN Medecin.idMedecin%TYPE,
        nomM IN Medecin.nom%TYPE,
        Specialite IN Medecin.specialite%TYPE,
        salaire IN Medecin.Salaire%TYPE,
        idS IN Medecin.idService%TYPE
        ) IS
        nb_s NUMBER;
        BEGIN
            SELECT COUNT(*) INTO nb_s FROM Service WHERE idService=idS;
            IF nb_s = 0 THEN 
                RAISE ex_ser;
            END IF;
            IF salaire <= 0 THEN
                RAISE ex_sal;
            END IF;
            IF nomM IS NULL THEN
                RAISE ex_null;
            END IF;
            IF Specialite IS NULL THEN
                RAISE ex_null;
            END IF;

            INSERT INTO Medecin VALUES (idM,nomM,Specialite,salaire,idS);
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Medecin ajoute');

        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('ID deja existant');
            WHEN ex_ser THEN
                DBMS_OUTPUT.PUT_LINE('Service inexistant');
            WHEN ex_sal THEN
                DBMS_OUTPUT.PUT_LINE('Salaire invalide');
            WHEN ex_null THEN
                DBMS_OUTPUT.PUT_LINE('tous les champs sont obligatoires');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erreur inattendu: '||SQLERRM);
                ROLLBACK;
        END ajouter_medecin;

    PROCEDURE modifier_medecin (
        idM IN Medecin.idMedecin%TYPE,
        nomM IN Medecin.nom%TYPE,
        Specialite IN Medecin.specialite%TYPE,
        salaire IN Medecin.Salaire%TYPE,
        idS IN Medecin.idService%TYPE) IS
        nb_s NUMBER;
        nb_m NUMBER;
        BEGIN
            SELECT COUNT(*) INTO nb_m FROM Medecin WHERE idMedecin=idM;
            IF nb_m = 0 THEN
                RAISE ex_introuvable;
            END IF;
            SELECT COUNT(*) INTO nb_s FROM Service WHERE idService=idS;
            IF nb_s = 0 THEN 
                RAISE ex_ser;
            END IF;
            IF salaire <= 0 THEN
                RAISE ex_sal;
            END IF;
            IF nomM IS NULL THEN
                RAISE ex_null;
            END IF;
            IF Specialite IS NULL THEN
                RAISE ex_null;
            END IF;

            UPDATE Medecin 
            SET nom=nomM,
                specialite=Specialite,
                Salaire=salaire,
                idService=idS
                WHERE idMedecin=idM;
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Medecin modifie');

        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('ID deja existant');
            WHEN ex_introuvable THEN
                DBMS_OUTPUT.PUT_LINE('ID introuvable');
            WHEN ex_ser THEN
                DBMS_OUTPUT.PUT_LINE('Service inexistant');
            WHEN ex_sal THEN
                DBMS_OUTPUT.PUT_LINE('Salaire invalide');
            WHEN ex_null THEN
                DBMS_OUTPUT.PUT_LINE('tous les champs sont obligatoires');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erreur inattendu');
                ROLLBACK;
        END modifier_medecin;

    PROCEDURE supprimer_medecin (idM IN Medecin.idMedecin%TYPE) IS
        nb_m NUMBER;
    BEGIN
        SELECT COUNT(*) INTO nb_m FROM Medecin WHERE idMedecin=idM;
        IF nb_m = 0 THEN
            RAISE ex_introuvable;
        END IF;
        DELETE from Medecin WHERE idMedecin=idM;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Le Medecin est supprime avec succes');
    EXCEPTION
        WHEN ex_introuvable THEN
            DBMS_OUTPUT.PUT_LINE('ID introuvable');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur inattendu');
            ROLLBACK;
    END supprimer_medecin;

    PROCEDURE afficher_medecin (idM IN Medecin.idMedecin%TYPE ) IS
        m Medecin%ROWTYPE;
    BEGIN
        SELECT * INTO m FROM Medecin WHERE idMedecin=idM;
        DBMS_OUTPUT.PUT_LINE('Nom de Medecin: '||m.nom||' - Specialite: '||m.specialite||' - Salaire: '||m.salaire);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Medecin inexistant');
    END afficher_medecin;
--- CURSEUR PARAMETRE---
    PROCEDURE afficher_rdv_medecin (
    p_idMedecin Medecin.idMedecin%TYPE
    ) IS
        CURSOR cur_rdv (p_idMedecin Medecin.idMedecin%TYPE) IS 
            SELECT r.dateRdv,r.statut,p.nom FROM RendezVous r INNER JOIN Patient p ON r.idPatient=p.idPatient  WHERE r.idMedecin=p_idMedecin ORDER BY r.dateRdv;
        rdv cur_rdv%ROWTYPE;
        r_count NUMBER :=0;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Rendez-vous du medecin ID: ' || p_idMedecin || ' ---');
        OPEN cur_rdv (p_idMedecin);
        LOOP
            FETCH cur_rdv INTO rdv;
            EXIT WHEN cur_rdv%NOTFOUND;
            r_count:=r_count+1;
            DBMS_OUTPUT.PUT_LINE('Date: '||TO_CHAR(rdv.dateRdv,'DD/MM/YYYY HH24:MI')||' - Nom Patient: '||rdv.nom||' - Statut: '||rdv.statut);
        END LOOP;
        CLOSE cur_rdv;
        IF r_count=0 THEN
            DBMS_OUTPUT.PUT_LINE('Aucun rendez-vous trouve pour ce médecin.');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Erreur Inattendu');
    END afficher_rdv_medecin;

END pkg_medecin;
/