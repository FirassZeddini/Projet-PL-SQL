CREATE OR REPLACE PACKAGE pkg_patient AS
    ex_patient_existe EXCEPTION;
    ex_patient_introuvable EXCEPTION;
    ex_long_tel EXCEPTION;
    ex_nom_null EXCEPTION;
    ex_prenom_null EXCEPTION;
    ex_date EXCEPTION;
    PROCEDURE ajouter_patient(id IN patient.idPatient%type,
        nom_p IN patient.nom%type, 
        prenom_p IN patient.prenom%type, 
        dateNais_p IN patient.dateNaissance%type, 
        adresse_p IN patient.adresse%type, 
        tel_p IN patient.telephone%type);

    PROCEDURE modifier_patient(id_p IN patient.idPatient%type,
        nom_p IN patient.nom%type, 
        prenom_p IN patient.prenom%type, 
        dateNais_p IN patient.dateNaissance%type, 
        adresse_p IN patient.adresse%type, 
        tel_p IN patient.telephone%type);

    PROCEDURE supprimer_patient(id_p IN patient.idPatient%type);

    PROCEDURE afficher_patient(id_p IN patient.idPatient%type);
END pkg_patient;
/

CREATE OR REPLACE PACKAGE BODY pkg_patient AS
    PROCEDURE ajouter_patient(id IN patient.idPatient%type,
        nom_p IN patient.nom%type, 
        prenom_p IN patient.prenom%type, 
        dateNais_p IN patient.dateNaissance%type, 
        adresse_p IN patient.adresse%type, 
        tel_p IN patient.telephone%type) IS
        nb_p INTEGER;
        BEGIN
            SELECT COUNT(*) INTO nb_p FROM Patient WHERE idPatient=id;
            IF nb_p>0 THEN
                RAISE ex_patient_existe;
            END IF;

            IF LENGTH(tel_p)<>8 THEN
                RAISE ex_long_tel;
            END IF;

            IF nom_p IS NULL THEN
                RAISE ex_nom_null;
            END IF;
            IF prenom_p IS NULL THEN
                RAISE ex_prenom_null;
            END IF;

            IF dateNais_p >= SYSDATE THEN
                RAISE ex_date;
            END IF;
            INSERT INTO Patient VALUES (id, nom_p, prenom_p, dateNais_p, adresse_p, tel_p);
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('La patient a ete ajoute avec succes');
        EXCEPTION
            WHEN ex_date THEN
                DBMS_OUTPUT.PUT_LINE('Date de naissance invalide');
            WHEN ex_patient_existe THEN
                DBMS_OUTPUT.PUT_LINE('Le Patient '||id||' deja existant');
            WHEN ex_long_tel THEN
                DBMS_OUTPUT.PUT_LINE('Le longueur du numero de telephone doit etre 8');
            WHEN ex_nom_null THEN
                DBMS_OUTPUT.PUT_LINE('Le nom est obligatoire');
            WHEN ex_prenom_null THEN
                DBMS_OUTPUT.PUT_LINE('Le prenom est obligatoire');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erreur inattendu');
                ROLLBACK;
        END ajouter_patient;

PROCEDURE modifier_patient(id_p IN patient.idPatient%type,
        nom_p IN patient.nom%type, 
        prenom_p IN patient.prenom%type, 
        dateNais_p IN patient.dateNaissance%type, 
        adresse_p IN patient.adresse%type, 
        tel_p IN patient.telephone%type) IS
        nb_p INTEGER;
        BEGIN
            SELECT COUNT(*) INTO nb_p FROM patient WHERE idPatient=id_p;
            IF nb_p=0 THEN
                RAISE ex_patient_introuvable;
            END IF;

            IF LENGTH(tel_p)<>8 THEN
                RAISE ex_long_tel;
            END IF;

            IF nom_p IS NULL THEN
                RAISE ex_nom_null;
            END IF;
            IF prenom_p IS NULL THEN
                RAISE ex_prenom_null;
            END IF;

            UPDATE Patient SET nom=nom_p,
                               prenom=prenom_p,
                               telephone=tel_p,
                               adresse=adresse_p,
                               dateNaissance=dateNais_p
            WHERE idPatient=id_p;
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Le patient '||id_p||' a ete modifie avec succes');
        EXCEPTION
            WHEN ex_patient_introuvable THEN
                DBMS_OUTPUT.PUT_LINE('Le Patient '||id_p||' n''existe pas');
            WHEN ex_long_tel THEN
                DBMS_OUTPUT.PUT_LINE('Le longueur du numero de telephone doit etre 8');
            WHEN ex_nom_null THEN
                DBMS_OUTPUT.PUT_LINE('Le nom est obligatoire');
            WHEN ex_prenom_null THEN
                DBMS_OUTPUT.PUT_LINE('Le prenom est obligatoire');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erreur inattendu');
                ROLLBACK;
        END modifier_patient;

PROCEDURE supprimer_patient(id_p IN patient.idPatient%type) IS
    nb_p INTEGER;
    BEGIN
        SELECT COUNT(*) INTO nb_p FROM Patient WHERE idPatient=id_p;
        IF nb_p=0 THEN
            RAISE ex_patient_introuvable;
        END IF;
        DELETE FROM Patient WHERE idPatient=id_p;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Le patient '||id_p||' est supprime avec succes');
    EXCEPTION
        WHEN ex_patient_introuvable THEN
            DBMS_OUTPUT.PUT_LINE('Patient '||id_p||' n''existe pas');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            ROLLBACK;
    END supprimer_patient;

PROCEDURE afficher_patient(id_p IN patient.idPatient%type) IS
    rec Patient%rowtype;
    BEGIN
        SELECT * INTO rec FROM Patient WHERE idPatient=id_p;
        DBMS_OUTPUT.PUT_LINE('Patient: '||rec.idPatient);
        DBMS_OUTPUT.PUT_LINE('Nom: '||rec.nom);
        DBMS_OUTPUT.PUT_LINE('Prenom: '||rec.prenom);
        DBMS_OUTPUT.PUT_LINE('Date de naissance: '||rec.dateNaissance);
        DBMS_OUTPUT.PUT_LINE('Adresse: '||rec.adresse);
        DBMS_OUTPUT.PUT_LINE('Numero de telephone: '||rec.telephone);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Le patient '||id_p||' n''existe pas');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur inattendu');
            ROLLBACK;
    END afficher_patient;

END pkg_patient;
/

            




