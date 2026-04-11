CREATE OR REPLACE PROCEDURE liste_hospitalisations
IS
    CURSOR cur IS SELECT 
    p.nom, p.prenom, s.nomService,(ROUND(NVL(h.dateSortie,SYSDATE)-h.dateEntree)) AS duree
    FROM Hospitalisation h
    INNER JOIN Patient p ON p.idPatient=h.idPatient
    INNER JOIN Service s ON s.idService=h.idService;
    compteur INTEGER :=0;
    trouve BOOLEAN := FALSE;
    ex_hosp_vide EXCEPTION;

BEGIN
    FOR rec IN cur LOOP
        trouve:=TRUE;
        compteur:=compteur+1;
        DBMS_OUTPUT.PUT_LINE('============Hospitalisation '||compteur||'============');
        DBMS_OUTPUT.PUT_LINE('Nom patient: '||rec.nom);
        DBMS_OUTPUT.PUT_LINE('Prenom patient: '||rec.prenom);
        DBMS_OUTPUT.PUT_LINE('Nom service: '||rec.nomService);
        DBMS_OUTPUT.PUT_LINE('Duree de sejour: '||rec.duree||' jours');
    END LOOP;
    IF NOT trouve THEN
        RAISE ex_hosp_vide;
    END IF;
EXCEPTION
    WHEN ex_hosp_vide THEN
        DBMS_OUTPUT.PUT_LINE('Aucune hospitalisation trouvee');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur inattendue: '||SQLERRM);
END;
/
