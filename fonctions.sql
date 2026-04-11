CREATE OR REPLACE FUNCTION nb_patients_service (p_idService IN Service.idService%TYPE)  RETURN NUMBER 
IS
    nb_p NUMBER :=0 ;
    BEGIN
        SELECT count(*) INTO nb_p FROM Hospitalisation WHERE idService=p_idService;
        RETURN nb_p;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
    END;
/
CREATE OR REPLACE FUNCTION total_medicaments_patient (p_idPatient IN Patient.idPatient%TYPE)  RETURN NUMBER 
IS
    nb_med NUMBER :=0 ;
    BEGIN
        SELECT SUM(lp.quantite) INTO nb_med FROM Prescription p INNER JOIN Ligne_Prescription lp on p.idPresc=lp.idPresc WHERE idPatient=p_idPatient;
        RETURN nb_med;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
    END;
/

CREATE OR REPLACE FUNCTION cout_prescription(p_idPresc IN Ligne_Prescription.idPresc%type) RETURN INTEGER
IS
    cout INTEGER;
    BEGIN
        SELECT SUM(m.prix*l.quantite) INTO cout FROM Ligne_Prescription l
        JOIN Medicament m ON l.idMed=m.idMed
        WHERE l.idPresc=p_idPresc;
        RETURN cout;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('La ligne prescription '||p_idPresc||' est introuvable');
            RETURN 0;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur inattendue: '||SQLERRM);
            RETURN 0;
    END;
/