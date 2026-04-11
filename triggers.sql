CREATE OR REPLACE TRIGGER  trg_patient_del 
BEFORE DELETE ON Patient
FOR EACH ROW 
    DECLARE
        nb NUMBER;
    BEGIN
    SELECT COUNT(*) INTO nb FROM Hospitalisation WHERE idPatient=:OLD.idPatient;
    IF nb>0 THEN
        RAISE_APPLICATION_ERROR(-20010,'Patient hospitalise, suppression interdite');
    END IF;
    END;