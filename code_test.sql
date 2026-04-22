-- ============================================================
--   SCRIPT DE TESTS COMPLET - Systeme de Gestion Hopital
-- ============================================================
SET SERVEROUTPUT ON SIZE UNLIMITED;

DELETE FROM Ligne_Prescription;
DELETE FROM Prescription;
DELETE FROM Hospitalisation;
DELETE FROM RendezVous;
DELETE FROM Medecin;
DELETE FROM Service;
DELETE FROM Patient;
DELETE FROM Medicament;
COMMIT;

-- ============================================================
-- PARTIE 0 : DONNEES DE BASE
-- ============================================================

INSERT INTO Service VALUES (1, 'Cardiologie', 3);
INSERT INTO Service VALUES (2, 'Pediatrie', 2);
INSERT INTO Service VALUES (3, 'Urgences', 5);
INSERT INTO Service VALUES (4, 'Neurologie', 1);

INSERT INTO Medecin VALUES (1, 'Dr. Ben Ali',  'Cardiologue', 8000, 1);
INSERT INTO Medecin VALUES (2, 'Dr. Maaloul',  'Pediatre',    6500, 2);
INSERT INTO Medecin VALUES (3, 'Dr. Trabelsi', 'Neurologue',  7000, 4);

INSERT INTO Patient VALUES (1, 'Hamdi',   'Sami',  DATE '1990-05-10', 'Tunis',   '22334455');
INSERT INTO Patient VALUES (2, 'Gharbi',  'Leila', DATE '1985-03-22', 'Sfax',    '33445566');
INSERT INTO Patient VALUES (3, 'Jebali',  'Omar',  DATE '2000-11-01', 'Sousse',  '44556677');
INSERT INTO Patient VALUES (4, 'Mansour', 'Ines',  DATE '1978-07-15', 'Bizerte', '55667788');

INSERT INTO Medicament VALUES (1, 'Paracetamol',  50, 2.5);
INSERT INTO Medicament VALUES (2, 'Ibuprofene',   30, 4.0);
INSERT INTO Medicament VALUES (3, 'Amoxicilline',  0, 6.0);
INSERT INTO Medicament VALUES (4, 'Doliprane',    20, 3.0);

INSERT INTO Hospitalisation VALUES (1, 1, 1, DATE '2026-01-01', DATE '2026-01-10');
INSERT INTO Hospitalisation VALUES (2, 2, 2, DATE '2026-02-01', NULL);

COMMIT;


-- ============================================================
-- PARTIE 1 : TESTS CRUD PATIENT
-- ============================================================

PROMPT ==========================================
PROMPT TESTS PATIENT
PROMPT ==========================================

PROMPT [1] Ajout valide
EXEC pkg_hopital.ajouter_patient(5, 'Ayari', 'Rim', DATE '1995-06-20', 'Nabeul', '66778899');

PROMPT [2] Ajout patient deja existant
EXEC pkg_hopital.ajouter_patient(1, 'Test', 'Test', DATE '1990-01-01', 'Tunis', '11223344');

PROMPT [3] Telephone trop court
EXEC pkg_hopital.ajouter_patient(6, 'Zouari', 'Ali', DATE '1992-01-01', 'Tunis', '1234');

PROMPT [4] Nom null
EXEC pkg_hopital.ajouter_patient(6, NULL, 'Ali', DATE '1992-01-01', 'Tunis', '12345678');

PROMPT [5] Prenom null
EXEC pkg_hopital.ajouter_patient(6, 'Zouari', NULL, DATE '1992-01-01', 'Tunis', '12345678');

PROMPT [6] Date de naissance future
EXEC pkg_hopital.ajouter_patient(6, 'Zouari', 'Ali', DATE '2030-01-01', 'Tunis', '12345678');

PROMPT [7] Affichage patient valide
EXEC pkg_hopital.afficher_patient(1);

PROMPT [8] Affichage patient inexistant
EXEC pkg_hopital.afficher_patient(999);

PROMPT [9] Modification valide
EXEC pkg_hopital.modifier_patient(5, 'Ayari', 'Rim', DATE '1995-06-20', 'Bizerte', '99887766');

PROMPT [10] Modification patient inexistant
EXEC pkg_hopital.modifier_patient(999, 'X', 'Y', DATE '1990-01-01', 'Tunis', '12345678');

PROMPT [11] Suppression patient hospitalise - trigger doit bloquer
EXEC pkg_hopital.supprimer_patient(1);

PROMPT [12] Suppression patient non hospitalise
EXEC pkg_hopital.supprimer_patient(5);

PROMPT [13] Suppression patient inexistant
EXEC pkg_hopital.supprimer_patient(999);


-- ============================================================
-- PARTIE 2 : TESTS CRUD MEDECIN
-- ============================================================

PROMPT ==========================================
PROMPT TESTS MEDECIN
PROMPT ==========================================

PROMPT [1] Ajout valide
EXEC pkg_hopital.ajouter_medecin(10, 'Dr. Sassi', 'Chirurgien', 9000, 3);

PROMPT [2] Medecin deja existant
EXEC pkg_hopital.ajouter_medecin(1, 'Dr. Test', 'Test', 5000, 1);

PROMPT [3] Service inexistant
EXEC pkg_hopital.ajouter_medecin(11, 'Dr. X', 'Generaliste', 5000, 99);

PROMPT [4] Salaire invalide
EXEC pkg_hopital.ajouter_medecin(11, 'Dr. X', 'Generaliste', -100, 1);

PROMPT [5] Nom null
EXEC pkg_hopital.ajouter_medecin(11, NULL, 'Generaliste', 5000, 1);

PROMPT [6] Affichage medecin valide
EXEC pkg_hopital.afficher_medecin(1);

PROMPT [7] Affichage medecin inexistant
EXEC pkg_hopital.afficher_medecin(999);

PROMPT [8] Modification valide
EXEC pkg_hopital.modifier_medecin(10, 'Dr. Sassi', 'Chirurgien', 9500, 3);

PROMPT [9] Modification medecin inexistant
EXEC pkg_hopital.modifier_medecin(999, 'X', 'Y', 5000, 1);

PROMPT [10] Suppression valide
EXEC pkg_hopital.supprimer_medecin(10);

PROMPT [11] Suppression medecin inexistant
EXEC pkg_hopital.supprimer_medecin(999);


-- ============================================================
-- PARTIE 3 : TESTS CRUD MEDICAMENT
-- ============================================================

PROMPT ==========================================
PROMPT TESTS MEDICAMENT
PROMPT ==========================================

PROMPT [1] Ajout valide
EXEC pkg_hopital.ajouter_medicament(10, 'Aspirine', 100, 1.5);

PROMPT [2] ID deja existant
EXEC pkg_hopital.ajouter_medicament(1, 'Paracetamol', 50, 2.5);

PROMPT [3] Stock negatif
EXEC pkg_hopital.ajouter_medicament(11, 'TestMed', -5, 2.0);

PROMPT [4] Prix invalide
EXEC pkg_hopital.ajouter_medicament(11, 'TestMed', 10, -1.0);

PROMPT [5] Nom null
EXEC pkg_hopital.ajouter_medicament(11, NULL, 10, 2.0);

PROMPT [6] Affichage medicament valide
EXEC pkg_hopital.afficher_medicament(1);

PROMPT [7] Affichage medicament inexistant
EXEC pkg_hopital.afficher_medicament(999);

PROMPT [8] Modification valide
EXEC pkg_hopital.modifier_medicament(10, 'Aspirine', 80, 1.8);

PROMPT [9] Modification medicament inexistant
EXEC pkg_hopital.modifier_medicament(999, 'X', 10, 2.0);

PROMPT [10] Suppression valide
EXEC pkg_hopital.supprimer_medicament(10);

PROMPT [11] Suppression medicament inexistant
EXEC pkg_hopital.supprimer_medicament(999);


-- ============================================================
-- PARTIE 4 : TESTS CRUD RENDEZ-VOUS
-- ============================================================

PROMPT ==========================================
PROMPT TESTS RENDEZ-VOUS
PROMPT ==========================================

PROMPT [1] Ajout RDV valide
EXEC pkg_hopital.ajouter_rendezVous(1, 1, 1, SYSDATE + 2, 'planifie');

PROMPT [2] RDV deja existant
EXEC pkg_hopital.ajouter_rendezVous(1, 1, 1, SYSDATE + 3, 'planifie');

PROMPT [3] Patient inexistant
EXEC pkg_hopital.ajouter_rendezVous(2, 999, 1, SYSDATE + 3, 'planifie');

PROMPT [4] Medecin inexistant
EXEC pkg_hopital.ajouter_rendezVous(2, 1, 999, SYSDATE + 3, 'planifie');

PROMPT [5] Date passee
EXEC pkg_hopital.ajouter_rendezVous(2, 1, 1, DATE '2020-01-01', 'planifie');

PROMPT [6] Statut invalide
EXEC pkg_hopital.ajouter_rendezVous(2, 1, 1, SYSDATE + 3, 'invalide');

PROMPT [7] Conflit RDV - trigger doit bloquer
EXEC pkg_hopital.ajouter_rendezVous(2, 2, 1, SYSDATE + 2, 'planifie');

PROMPT [8] Affichage RDV valide
EXEC pkg_hopital.afficher_rendezVous(1);

PROMPT [9] Affichage RDV inexistant
EXEC pkg_hopital.afficher_rendezVous(999);

PROMPT [10] Modification RDV valide
EXEC pkg_hopital.modifier_rendezVous(1, 1, 1, SYSDATE + 5, 'planifie');

PROMPT [11] Modification RDV inexistant
EXEC pkg_hopital.modifier_rendezVous(999, 1, 1, SYSDATE + 5, 'planifie');

PROMPT [12] Suppression RDV valide
EXEC pkg_hopital.supprimer_rendezVous(1);

PROMPT [13] Suppression RDV inexistant
EXEC pkg_hopital.supprimer_rendezVous(999);


-- ============================================================
-- PARTIE 5 : CURSEUR PARAMETRE
-- ============================================================

PROMPT ==========================================
PROMPT TESTS CURSEUR PARAMETRE
PROMPT ==========================================

EXEC pkg_hopital.ajouter_rendezVous(10, 1, 1, SYSDATE + 1, 'planifie');
EXEC pkg_hopital.ajouter_rendezVous(11, 2, 1, SYSDATE + 2, 'planifie');

PROMPT [1] Medecin avec rendez-vous
EXEC pkg_hopital.afficher_rdv_medecin(1);

PROMPT [2] Medecin sans rendez-vous - doit afficher message Aucun
EXEC pkg_hopital.afficher_rdv_medecin(3);

EXEC pkg_hopital.supprimer_rendezVous(10);
EXEC pkg_hopital.supprimer_rendezVous(11);


-- ============================================================
-- PARTIE 6 : TESTS FONCTIONS
-- ============================================================

PROMPT ==========================================
PROMPT TESTS FONCTIONS
PROMPT ==========================================

PROMPT [1] nb_patients_service - service avec patients

DECLARE
    v_nb NUMBER;
BEGIN
    v_nb := pkg_hopital.nb_patients_service(1);
    DBMS_OUTPUT.PUT_LINE('Resultat nb_patients_service(1) = ' || v_nb);
END;
/

PROMPT [2] nb_patients_service - service sans patients

DECLARE
    v_nb NUMBER;
BEGIN
    v_nb := pkg_hopital.nb_patients_service(3);
    DBMS_OUTPUT.PUT_LINE('Resultat nb_patients_service(3) = ' || v_nb);
END;
/

PROMPT [3] nb_patients_service - service inexistant

DECLARE
    v_nb NUMBER;
BEGIN
    v_nb := pkg_hopital.nb_patients_service(999);
    DBMS_OUTPUT.PUT_LINE('Resultat nb_patients_service(999) = ' || NVL(TO_CHAR(v_nb), 'NULL'));
END;
/


PROMPT [5] total_medicaments_patient - patient sans prescription

DECLARE
    v_tot NUMBER;
BEGIN
    v_tot := pkg_hopital.total_medicaments_patient(1);
    DBMS_OUTPUT.PUT_LINE('Resultat total_medicaments_patient(1) = ' || v_tot);
END;
/

PROMPT [6] total_medicaments_patient - patient inexistant

DECLARE
    v_tot NUMBER;
BEGIN
    v_tot := pkg_hopital.total_medicaments_patient(999);
    DBMS_OUTPUT.PUT_LINE('Resultat total_medicaments_patient(999) = ' || NVL(TO_CHAR(v_tot), 'NULL'));
END;
/

PROMPT [7] cout_prescription - prescription inexistante

DECLARE
    v_cout NUMBER;
BEGIN
    v_cout := pkg_hopital.cout_prescription(999);
    DBMS_OUTPUT.PUT_LINE('Resultat cout_prescription(999) = ' || NVL(TO_CHAR(v_cout), 'NULL'));
END;
/


-- ============================================================
-- PARTIE 7 : TESTS PRESCRIRE MEDICAMENT
-- ============================================================

PROMPT ==========================================
PROMPT TESTS PRESCRIRE MEDICAMENT
PROMPT ==========================================

PROMPT [1] Prescription valide - Paracetamol x5 Ibuprofene x3

DECLARE
    v_meds tab_meds;
BEGIN
    v_meds := tab_meds(rec_med(1, 5), rec_med(2, 3));
    pkg_hopital.prescrire_medicament(1, 1, 1, v_meds);
END;
/

PROMPT [2] Stock insuffisant - Amoxicilline stock=0

DECLARE
    v_meds tab_meds;
BEGIN
    v_meds := tab_meds(rec_med(3, 10));
    pkg_hopital.prescrire_medicament(2, 1, 1, v_meds);
END;
/

PROMPT [3] Medecin inexistant

DECLARE
    v_meds tab_meds;
BEGIN
    v_meds := tab_meds(rec_med(1, 2));
    pkg_hopital.prescrire_medicament(3, 1, 999, v_meds);
END;
/

PROMPT [4] Patient inexistant

DECLARE
    v_meds tab_meds;
BEGIN
    v_meds := tab_meds(rec_med(1, 2));
    pkg_hopital.prescrire_medicament(3, 999, 1, v_meds);
END;
/

PROMPT [5] Collection vide

DECLARE
    v_meds tab_meds;
BEGIN
    v_meds := tab_meds();
    pkg_hopital.prescrire_medicament(3, 1, 1, v_meds);
END;
/

PROMPT [6] Verification cout_prescription - attendu 24.5

DECLARE
    v_cout NUMBER;
BEGIN
    v_cout := pkg_hopital.cout_prescription(1);
    DBMS_OUTPUT.PUT_LINE('cout_prescription(1) = ' || v_cout || '  (attendu: 24.5)');
END;
/

PROMPT [7] Verification total_medicaments_patient - attendu 8

DECLARE
    v_tot NUMBER;
BEGIN
    v_tot := pkg_hopital.total_medicaments_patient(1);
    DBMS_OUTPUT.PUT_LINE('total_medicaments_patient(1) = ' || v_tot || '  (attendu: 8)');
END;
/


-- ============================================================
-- PARTIE 8 : LISTE HOSPITALISATIONS
-- ============================================================

PROMPT ==========================================
PROMPT TESTS LISTE HOSPITALISATIONS
PROMPT ==========================================

PROMPT [1] Liste avec hospitalisations existantes
EXEC pkg_hopital.liste_hospitalisations;


-- ============================================================
-- PARTIE 9 : MEDICAMENTS RUPTURE
-- ============================================================

PROMPT ==========================================
PROMPT TESTS MEDICAMENTS RUPTURE
PROMPT ==========================================

PROMPT [1] Affiche Amoxicilline en rupture stock=0
EXEC pkg_hopital.medicaments_rupture;

PROMPT [2] Cas aucune rupture - tous les stocks > 0

UPDATE Medicament SET stock = 1 WHERE stock = 0;
COMMIT;

EXEC pkg_hopital.medicaments_rupture;

UPDATE Medicament SET stock = 0 WHERE idMed = 3;
COMMIT;


-- ============================================================
-- PARTIE 10 : TESTS TRIGGERS
-- ============================================================

PROMPT ==========================================
PROMPT TESTS TRIGGERS
PROMPT ==========================================

PROMPT [1] trg_patient_del - suppression patient hospitalise doit echouer

BEGIN
    DELETE FROM Patient WHERE idPatient = 1;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('TRIGGER OK - Suppression bloquee: ' || SQLERRM);
END;
/

PROMPT [2] trg_before_insert_rdv - insertion RDV de reference

INSERT INTO RendezVous VALUES (20, 1, 2, SYSDATE + 10, 'planifie');
COMMIT;

PROMPT [3] trg_before_insert_rdv - conflit doit etre bloque

BEGIN
    INSERT INTO RendezVous VALUES (21, 2, 2, SYSDATE + 10, 'planifie');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('TRIGGER OK - Conflit RDV bloque: ' || SQLERRM);
END;
/

PROMPT [4] trg_before_insert_rdv - RDV a plus de 30 min doit passer

BEGIN
    INSERT INTO RendezVous VALUES (22, 3, 2, SYSDATE + 11, 'planifie');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('TRIGGER OK - RDV sans conflit insere avec succes');
END;
/

DELETE FROM RendezVous WHERE idRdv IN (20, 22);
COMMIT;

PROMPT [5] trg_before_insert_hosp - depassement capacite service 4

BEGIN
    INSERT INTO Hospitalisation VALUES (10, 3, 4, SYSDATE - 5, NULL);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('TRIGGER OK - Capacite depassee bloquee: ' || SQLERRM);
END;
/

PROMPT [6] trg_before_insert_hosp - double hospitalisation meme patient

BEGIN
    INSERT INTO Hospitalisation VALUES (11, 2, 3, DATE '2026-02-05', NULL);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('TRIGGER OK - Double hospitalisation bloquee: ' || SQLERRM);
END;
/

PROMPT [7] trg_before_insert_hosp - service inexistant

BEGIN
    INSERT INTO Hospitalisation VALUES (12, 3, 999, SYSDATE, NULL);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('TRIGGER OK - Service inexistant bloque: ' || SQLERRM);
END;
/

PROMPT [8] trg_ddl - CREATE et DROP declenchent le trigger DDL

CREATE TABLE test_ddl_trigger (id NUMBER);
DROP TABLE test_ddl_trigger;


-- ============================================================
-- PARTIE 11 : VERIFICATION STOCKS
-- ============================================================

PROMPT ==========================================
PROMPT VERIFICATION STOCKS APRES PRESCRIPTION
PROMPT Paracetamol attendu 45 - Ibuprofene attendu 27
PROMPT ==========================================

SELECT idMed, nom, stock FROM Medicament ORDER BY idMed;

PROMPT ==========================================
PROMPT FIN DES TESTS
PROMPT ==========================================