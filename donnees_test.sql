DELETE FROM Ligne_Prescription;
DELETE FROM Prescription;
DELETE FROM Hospitalisation;
DELETE FROM RendezVous;
DELETE FROM Medecin;
DELETE FROM Service;
DELETE FROM Patient;
DELETE FROM Medicament;
COMMIT;


INSERT INTO Service VALUES (1, 'Cardiologie', 50);
INSERT INTO Service VALUES (2, 'Neurologie', 30);

INSERT INTO Medecin VALUES (1, 'Dr House', 'Generaliste', 5000, 1);
INSERT INTO Medecin VALUES (2, 'Dr Karim', 'Cardiologue', 3000, 1);

INSERT INTO Patient VALUES (1, 'Ben Ali', 'Mohamed', DATE '1990-05-15', 'Tunis', '22334455');
INSERT INTO Patient VALUES (2, 'Trabelsi', 'Sana', DATE '1985-03-22', 'Sfax', '55667788');

INSERT INTO Medicament VALUES (1, 'Doliprane', 100, 5);
INSERT INTO Medicament VALUES (2, 'Aspirine', 50, 3);
INSERT INTO Hospitalisation VALUES (1, 1, 1, SYSDATE-5, SYSDATE);
INSERT INTO Hospitalisation VALUES (2, 2, 1, SYSDATE-3, SYSDATE);
INSERT INTO Hospitalisation VALUES (3, 1, 2, SYSDATE-2, SYSDATE);
INSERT INTO Prescription VALUES (1, 1, 1, SYSDATE);
INSERT INTO Ligne_Prescription VALUES (1, 1, 2);

INSERT INTO Hospitalisation VALUES (1, 1, 1, DATE '2026-04-01', DATE '2026-04-08');
INSERT INTO Hospitalisation VALUES (2, 2, 2, DATE '2026-04-05', NULL);

COMMIT;