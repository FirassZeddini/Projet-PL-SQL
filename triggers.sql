CREATE OR REPLACE TRIGGER  trg_patient_del 
BEFORE DELETE ON patient
FOR EACH ROW 
    DECLARE
        nb NUMBER;
    BEGIN
    SELECT COUNT(*) INTO nb FROM Hospitalisation WHERE idPatient=old.idPatient;
    IF nb>0 THEN
        RAISE_APPLICATION_ERROR(-20010,'Patient hospitalisé, suppression interdite');
    END IF;
    END;