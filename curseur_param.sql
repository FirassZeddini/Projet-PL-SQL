CREATE OR REPLACE PROCEDURE afficher_rdv_medecin (
    p_idMedecin Medecin.idMedecin%TYPE
    ) IS
        CURSOR cur_rdv (p_idMedecin Medecin.idMedecin%TYPE) IS 
            SELECT r.dateRdv,r.statut,p.nom FROM RendezVous r INNER JOIN Patient p ON r.idPatient=p.idPatient  WHERE r.idMedecin=p_idMedecin;
        rdv cur_rdv%ROWTYPE;
        r_count NUMBER :=0;
    BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Rendez-vous du médecin ID: ' || p_idMedecin || ' ---');
    OPEN cur_rdv (p_idMedecin);
    LOOP
        FETCH cur_rdv INTO rdv;
        EXIT WHEN cur_rdv%NOTFOUND;
        r_count:=r_count+1;
        DBMS_OUTPUT.PUT_LINE('Date: '||TO_CHAR(rdv.dateRdv,'DD/MM/YYYY HH24:MI')||' - Nom Patient: '||rdv.nom||' - Statut: '||rdv.statut);
    END LOOP;
    CLOSE cur_rdv;
    IF r_count=0 THEN
        DBMS_OUTPUT.PUT_LINE('Aucun rendez-vous trouvé pour ce médecin.');
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Erreur Inattendu');
    END;