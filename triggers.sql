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
/


CREATE OR REPLACE TRIGGER trg_before_insert_rdv
BEFORE INSERT ON RendezVous
FOR EACH ROW
DECLARE
    nb_conflit NUMBER;
BEGIN
    SELECT COUNT(*) INTO nb_conflit
    FROM RendezVous
    WHERE idMedecin = :NEW.idMedecin
    AND dateRdv = :NEW.dateRdv
    AND statut != 'annule';

    IF nb_conflit > 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Conflit : Le medecin '||:NEW.idMedecin||' a deja un rendez-vous a cette date.');
    END IF;
END;
/
