CREATE OR REPLACE PACKAGE pkg_medic AS
    ex_pr EXCEPTION;
    ex_stk EXCEPTION;
    ex_null EXCEPTION;
    ex_introuvable EXCEPTION;
    PROCEDURE ajouter_medicament(
        idM IN Medicament.idMed%TYPE,
        nomM IN Medicament.nom%TYPE,
        Stock IN Medicament.stock%TYPE,
        Prix IN Medicament.prix%TYPE
    );
    PROCEDURE modifier_medicament(
        idM IN Medicament.idMed%TYPE,
        nomM IN Medicament.nom%TYPE,
        Stock IN Medicament.stock%TYPE,
        Prix IN Medicament.prix%TYPE
    );
    PROCEDURE supprimer_medicament (idM IN Medicament.idMed%TYPE);
    
    PROCEDURE afficher_medicament (idM IN  Medicament.idMed%TYPE);
END pkg_medic;
/

CREATE OR REPLACE PACKAGE BODY pkg_medic AS
    PROCEDURE ajouter_medicament (
        idM IN Medicament.idMed%TYPE,
        nomM IN Medicament.nom%TYPE,
        Stock IN Medicament.stock%TYPE,
        Prix IN Medicament.prix%TYPE
        ) IS
        BEGIN
            IF Stock <= 0 THEN
                RAISE ex_stk;
            END IF;
            IF nomM IS NULL THEN
                RAISE ex_null;
            END IF;
            IF Prix <= 0 THEN
                RAISE ex_pr;
            END IF;

            INSERT INTO Medicament VALUES (idM,nomM,Stock,Prix);
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Medicament ajoute');

        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('ID deja existant');
            WHEN ex_stk THEN
                DBMS_OUTPUT.PUT_LINE('stock doit etre positive');
            WHEN ex_pr THEN
                DBMS_OUTPUT.PUT_LINE('prix doit etre positive');
            WHEN ex_null THEN
                DBMS_OUTPUT.PUT_LINE('tous les champs sont obligatoires');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erreur inattendu: '||SQLERRM);
                ROLLBACK;
        END ajouter_medicament;

    PROCEDURE modifier_medicament (
        idM IN Medicament.idMed%TYPE,
        nomM IN Medicament.nom%TYPE,
        Stock IN Medicament.stock%TYPE,
        Prix IN Medicament.prix%TYPE
        ) IS
        nb_m NUMBER;
        BEGIN
            SELECT COUNT(*) INTO nb_m FROM Medicament WHERE idMed=idM;
            IF nb_m = 0 THEN
                RAISE ex_introuvable;
            END IF;
            IF Stock <= 0 THEN
                RAISE ex_stk;
            END IF;
            IF nomM IS NULL THEN
                RAISE ex_null;
            END IF;
            IF Prix <= 0 THEN
                RAISE ex_pr;
            END IF;

            UPDATE Medicament 
            SET nom=nomM,
                stock=Stock,
                prix=Prix
                WHERE idMed=idM;
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Medicament modifie');

        EXCEPTION
            WHEN ex_introuvable THEN
                DBMS_OUTPUT.PUT_LINE('Medicament inexistant');
            WHEN ex_stk THEN
                DBMS_OUTPUT.PUT_LINE('stock doit etre positive');
            WHEN ex_pr THEN
                DBMS_OUTPUT.PUT_LINE('prix doit etre positive');
            WHEN ex_null THEN
                DBMS_OUTPUT.PUT_LINE('tous les champs sont obligatoires');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erreur inattendu');
                ROLLBACK;
        END modifier_medicament;

    PROCEDURE supprimer_medicament (idM IN Medicament.idMed%TYPE) IS
        nb_m NUMBER;
    BEGIN
        SELECT COUNT(*) INTO nb_m FROM Medicament WHERE idMed=idM;
        IF nb_m = 0 THEN
            RAISE ex_introuvable;
        END IF;
        DELETE from Medicament WHERE idMed=idM;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Medicament supprime avec succes');
    EXCEPTION
        WHEN ex_introuvable THEN
            DBMS_OUTPUT.PUT_LINE('ID introuvable');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur inattendu');
            ROLLBACK;
    END supprimer_medicament;

    PROCEDURE afficher_medicament (idM IN Medicament.idMed%TYPE ) IS
        m Medicament%ROWTYPE;
    BEGIN
        SELECT * INTO m FROM Medicament WHERE idMed=idM;
        DBMS_OUTPUT.PUT_LINE('Nom de Medicament: '||m.nom||' - Stock: '||m.stock||' - Prix: '||m.prix);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Medicament inexistant');
    END afficher_medicament;

END pkg_medic;
/