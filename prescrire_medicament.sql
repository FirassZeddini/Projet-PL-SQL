CREATE OR REPLACE TYPE rec_med AS OBJECT(
        idMed Medicament.idMed%type,
        qte Ligne_Prescription.quantite%type
);
/
CREATE OR REPLACE TYPE tab_meds AS TABLE OF rec_med;
/

CREATE OR REPLACE PROCEDURE prescrire_medicament (
    id_presc IN Prescription.idPresc%type,
    id_patient IN Patient.idPatient%type,
    id_medecin IN Medecin.idMedecin%type,
    meds IN tab_meds
) IS
    stock_actuel NUMBER;
    nb_patient NUMBER;
    nb_medecin NUMBER;
    nb_presc NUMBER;
    id_medic Medicament.idMed%type;
    CURSOR cur_stock(p_idMed NUMBER) IS
        SELECT stock FROM Medicament WHERE idMed = p_idMed FOR UPDATE;
    ex_stock_insuffisant EXCEPTION;
    ex_patient_introuvable EXCEPTION;
    ex_medecin_introuvable EXCEPTION;
    ex_presc_existe EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO nb_medecin FROM Medecin WHERE idMedecin=id_medecin;
    IF nb_medecin=0 THEN
        RAISE ex_medecin_introuvable;
    END IF;

    SELECT COUNT(*) INTO nb_patient FROM Patient WHERE idPatient=id_patient;
    IF nb_patient=0 THEN
        RAISE ex_patient_introuvable;
    END IF;


    INSERT INTO Prescription VALUES (id_presc, id_patient, id_medecin, SYSDATE);
    FOR i IN 1..meds.COUNT LOOP
        id_medic:=meds(i).idMed;
        OPEN cur_stock(meds(i).idMed);
        FETCH cur_stock INTO stock_actuel;
        CLOSE cur_stock;

        IF stock_actuel<meds(i).qte THEN
            RAISE ex_stock_insuffisant;
        END IF;
    
        INSERT INTO Ligne_Prescription VALUES (id_presc, meds(i).idMed, meds(i).qte);

        UPDATE Medicament
        SET stock=stock-meds(i).qte WHERE idMed=meds(i).idMed;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Prescription N°'||id_presc||' enregistree avec succes');
    
EXCEPTION
    WHEN ex_stock_insuffisant THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Stock insuffisant pour medicament '||id_medic);
    WHEN ex_medecin_introuvable THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Médecin ID '||id_medecin||' introuvable.');
    WHEN ex_patient_introuvable THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Patient ID '||id_patient||' introuvable.');
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('L''ID Prescription '||id_presc||' et l''ID medicament '||id_medic||' existe deja.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erreur inattendue: '||SQLERRM);
END prescrire_medicament;
/
