CREATE OR REPLACE PACKAGE pkg_rdv AS
    ex_rdv_existe EXCEPTION;
    ex_rdv_introuvable EXCEPTION;
    ex_patient_introuvable EXCEPTION;
    ex_medecin_introuvable EXCEPTION;
    ex_date_invalide EXCEPTION;

    PROCEDURE ajouter_rendezVous(
        id_rdv IN rendezVous.idRdv%type,
        id_patient IN rendezVous.idPatient%type,
        id_medecin IN rendezVous.idMedecin%type,
        date_rdv IN rendezVous.dateRdv%type,
        statut_rdv IN rendezVous.statut%type
        );
    
    PROCEDURE modifier_rendezVous(
        id_rdv IN rendezVous.idRdv%type,
        id_patient IN rendezVous.idPatient%type,
        id_medecin IN rendezVous.idMedecin%type,
        date_rdv IN rendezVous.dateRdv%type,
        statut_rdv IN rendezVous.statut%type
        );

    PROCEDURE supprimer_rendezVous(
        id_rdv IN rendezVous.idRdv%type
    );

    PROCEDURE afficher_rendezVous(
        id_rdv IN rendezVous.idRdv%type
    );
    

END pkg_rdv;
/

CREATE OR REPLACE PACKAGE BODY pkg_rdv AS
    PROCEDURE ajouter_rendezVous(
        id_rdv IN rendezVous.idRdv%type,
        id_patient IN rendezVous.idPatient%type,
        id_medecin IN rendezVous.idMedecin%type,
        date_rdv IN rendezVous.dateRdv%type,
        statut_rdv IN rendezVous.statut%type
        ) IS
        nb_rdv INTEGER;
        nb_patient INTEGER;
        nb_medecin INTEGER;
        BEGIN
            SELECT COUNT(*) INTO nb_rdv FROM rendezVous WHERE idRdv=id_rdv;
            IF nb_rdv>0 THEN
                RAISE ex_rdv_existe;
            END IF;
            
            SELECT COUNT(*) INTO nb_patient FROM Patient WHERE idPatient=id_patient;
            IF nb_patient=0 THEN
                RAISE ex_patient_introuvable;
            END IF;
            
            SELECT COUNT(*) INTO nb_medecin FROM Medecin WHERE idMedecin=id_medecin;
            IF nb_medecin=0 THEN
                RAISE ex_medecin_introuvable;
            END IF;
            
            IF date_rdv<SYSDATE OR date_rdv IS NULL THEN
                RAISE ex_date_invalide;
            END IF;
            
            INSERT INTO rendezVous VALUES (id_rdv, id_patient, id_medecin, date_rdv, statut_rdv);
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Rendez-Vous ajoute avec succcees');
        EXCEPTION
            WHEN ex_rdv_existe THEN
                DBMS_OUTPUT.PUT_LINE('Le rendez_vous '||id_rdv||' deja existant');
            WHEN ex_patient_introuvable THEN
                DBMS_OUTPUT.PUT_LINE('Le patient '||id_patient||' est introuvable');
            WHEN ex_medecin_introuvable THEN
                DBMS_OUTPUT.PUT_LINE('Le medecin '||id_medecin||' est introuvable');
            WHEN ex_date_invalide THEN
                DBMS_OUTPUT.PUT_LINE('Date invalide');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erreur inattendue: '||SQLERRM);
                ROLLBACK;
        END ajouter_rendezVous;

PROCEDURE modifier_rendezVous(
        id_rdv IN rendezVous.idRdv%type,
        id_patient IN rendezVous.idPatient%type,
        id_medecin IN rendezVous.idMedecin%type,
        date_rdv IN rendezVous.dateRdv%type,
        statut_rdv IN rendezVous.statut%type
        ) IS
        nb_rdv INTEGER;
        nb_patient INTEGER;
        nb_medecin INTEGER;
        BEGIN
            SELECT COUNT(*) INTO nb_rdv FROM rendezVous WHERE idRdv=id_rdv;
            IF nb_rdv=0 THEN
                RAISE ex_rdv_introuvable;
            END IF;
            
            SELECT COUNT(*) INTO nb_patient FROM Patient WHERE idPatient=id_patient;
            IF nb_patient=0 THEN
                RAISE ex_patient_introuvable;
            END IF;
            
            SELECT COUNT(*) INTO nb_medecin FROM Medecin WHERE idMedecin=id_medecin;
            IF nb_medecin=0 THEN
                RAISE ex_medecin_introuvable;
            END IF;
            
            IF date_rdv<SYSDATE OR date_rdv IS NULL THEN
                RAISE ex_date_invalide;
            END IF;
            
            UPDATE rendezVous SET idPatient=id_patient,
                                  idMedecin=id_medecin,
                                  dateRdv=date_rdv,
                                  statut=statut_rdv
            WHERE idRdv=id_rdv;
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Rendez-Vous modifie avec succes');

        EXCEPTION
            WHEN ex_rdv_introuvable THEN
                DBMS_OUTPUT.PUT_LINE('Le rendez-vous '||id_rdv||' est introuvable');
            WHEN ex_patient_introuvable THEN
                DBMS_OUTPUT.PUT_LINE('Le patient '||id_patient||' est introuvable');
            WHEN ex_medecin_introuvable THEN
                DBMS_OUTPUT.PUT_LINE('Le medecin '||id_medecin||' est introuvable');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erreur inattendue: '||SQLERRM);
                ROLLBACK;
        END  modifier_rendezVous;

        PROCEDURE supprimer_rendezVous(
            id_rdv IN rendezVous.idRdv%type
    ) IS
    nb_rdv INTEGER;
    BEGIN
        SELECT COUNT(*) INTO nb_rdv FROM rendezVous WHERE idRdv=id_rdv;
        IF nb_rdv=0 THEN
            RAISE ex_rdv_introuvable;
        END IF;
        
        DELETE FROM rendezVous WHERE idRdv=id_rdv;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Rendez-Vous supprime avec succes');
    EXCEPTION
        WHEN ex_rdv_introuvable THEN
            DBMS_OUTPUT.PUT_LINE('Le rendez-vous '||id_rdv||' est introuvable');
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Erreur inattendue '||SQLERRM);
            ROLLBACK;
    END supprimer_rendezVous;

PROCEDURE afficher_rendezVous(
    id_rdv IN rendezVous.idRdv%type
) IS
    TYPE rec_type IS RECORD (
        nom_p Patient.nom%type,
        prenom_p Patient.prenom%type,
        nom_m Medecin.nom%type,
        date_rdv rendezVous.dateRdv%type,
        statut_rdv rendezVous.statut%type
    );
    rec rec_type;
    BEGIN
        SELECT 
        p.nom, p.prenom, m.nom, r.dateRdv, r.Statut
        INTO rec.nom_p, rec.prenom_p, rec.nom_m, rec.date_rdv, rec.statut_rdv
        FROM rendezVous r
        INNER JOIN Patient p ON r.idPatient=p.idPatient
        INNER JOIN Medecin m ON r.idMedecin=m.idMedecin
        WHERE r.idRdv=id_rdv;

        DBMS_OUTPUT.PUT_LINE('Rendez-Vous: '||id_rdv);
        DBMS_OUTPUT.PUT_LINE('Nom patient: '||rec.nom_p);
        DBMS_OUTPUT.PUT_LINE('Prenom patient: '||rec.prenom_p);
        DBMS_OUTPUT.PUT_LINE('Nom medecin: '||rec.nom_m);
        DBMS_OUTPUT.PUT_LINE('Date rendez-vous: '||rec.date_rdv);
        DBMS_OUTPUT.PUT_LINE('Statut: '||rec.statut_rdv);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Le rendez-vous '||id_rdv||' est introuvable');
        WHEN OTHERs THEN
            DBMS_OUTPUT.PUT_LINE('Erreur inattendue: '||SQLERRM);
        
    END afficher_rendezVous;
END pkg_rdv;
/

    
            