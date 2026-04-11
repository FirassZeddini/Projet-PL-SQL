CREATE OR REPLACE PROCEDURE medicaments_rupture  IS
    TYPE tab IS TABLE OF Medicament.nom%TYPE INDEX BY BINARY_INTEGER;
    med_rup tab; 
    i NUMBER:=0;
BEGIN
    FOR r IN (SELECT nom FROM Medicament WHERE stock = 0) LOOP
        i := i + 1;
        med_rup(i) := r.nom;
    END LOOP;
    IF i = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Aucun medicament en rupture de stock');
        RETURN;
    END IF;
    DBMS_OUTPUT.PUT_LINE('--- Medicament en rupture ---');
    FOR j IN 1 .. i LOOP
        DBMS_OUTPUT.PUT_LINE('Nom medicament : '||med_rup(j) );
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/