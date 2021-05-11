SELECT tanfolyam_kod, 
count(CASE WHEN statusz = 'Megerositett' THEN 1 ELSE NULL END) AS megerositett,
count(CASE WHEN statusz = 'Megerositett + Készenlét' THEN 1 ELSE NULL END) AS keszenl,
count(CASE WHEN statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ideigl,
count(CASE WHEN statusz = 'Megerositett' OR statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ossz
FROM foglalas GROUP BY tanfolyam_kod;

SELECT tanfolyam.tanfolyam_kod, tanfolyam_tipus.max_letszam FROM tanfolyam_tipus, tanfolyam WHERE tanfolyam_tipus.tipus_kod = tanfolyam.tipus_kod;


SELECT tanfolyam.kezdo_datum, tanfolyam.vege_datum, tanfolyam.tanfolyam_kod, tanfolyam_tipus.oktato_kod as felelos, helyszin.nev as hely, oktato.oktato_kod as oktato,
tanfolyam_tipus.max_letszam as max, foglalas.ideigl as ideigl, foglalas.megerositett as megerositett, foglalas.ossz as ossz, foglalas.keszenl as keszenl
FROM tanfolyam JOIN tanfolyam_tipus ON tanfolyam.tipus_kod = tanfolyam_tipus.tipus_kod
JOIN helyszin ON tanfolyam.helyszin_kod = helyszin.helyszin_kod
JOIN oktato_kijeloles ON oktato_kijeloles.tanfolyam_kod = tanfolyam.tanfolyam_kod
JOIN oktato ON oktato_kijeloles.oktato_kod = oktato.oktato_kod
JOIN (
SELECT tanfolyam_kod, 
count(CASE WHEN statusz = 'Megerositett' THEN 1 ELSE NULL END) AS megerositett,
count(CASE WHEN statusz = 'Megerositett + Készenlét' THEN 1 ELSE NULL END) AS keszenl,
count(CASE WHEN statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ideigl,
count(CASE WHEN statusz = 'Megerositett' OR statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ossz
FROM foglalas GROUP BY tanfolyam_kod) foglalas ON foglalas.tanfolyam_kod = tanfolyam.tanfolyam_kod
ORDER BY tanfolyam.tanfolyam_kod;


CREATE OR REPLACE PROCEDURE tanfolyam_utemterv IS
    CURSOR cursl IS SELECT tanfolyam.kezdo_datum, tanfolyam.vege_datum, tanfolyam.tanfolyam_kod, tanfolyam_tipus.oktato_kod as felelos, helyszin.nev as hely, oktato.oktato_kod as oktato,
        tanfolyam_tipus.max_letszam as max, foglalas.ideigl as ideigl, foglalas.megerositett as megerositett, foglalas.ossz as ossz, foglalas.keszenl as keszenl
        FROM tanfolyam JOIN tanfolyam_tipus ON tanfolyam.tipus_kod = tanfolyam_tipus.tipus_kod
        JOIN helyszin ON tanfolyam.helyszin_kod = helyszin.helyszin_kod
        JOIN oktato_kijeloles ON oktato_kijeloles.tanfolyam_kod = tanfolyam.tanfolyam_kod
        JOIN oktato ON oktato_kijeloles.oktato_kod = oktato.oktato_kod
        JOIN (
        SELECT tanfolyam_kod, 
        count(CASE WHEN statusz = 'Megerositett' THEN 1 ELSE NULL END) AS megerositett,
        count(CASE WHEN statusz = 'Megerositett + Készenlét' THEN 1 ELSE NULL END) AS keszenl,
        count(CASE WHEN statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ideigl,
        count(CASE WHEN statusz = 'Megerositett' OR statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ossz
        FROM foglalas GROUP BY tanfolyam_kod) foglalas ON foglalas.tanfolyam_kod = tanfolyam.tanfolyam_kod
        ORDER BY tanfolyam.kezdo_datum, tanfolyam.vege_datum, tanfolyam.tanfolyam_kod;
        
    rec cursl%rowtype;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Datum | Tanf.kod | Felelos | Hely | Oktato | Max. | Ideigl. | Megerositett | Ossz. | Keszenl.');
        OPEN cursl;
        LOOP
           FETCH cursl INTO rec;
           EXIT WHEN cursl%notfound;
           DBMS_OUTPUT.PUT_LINE(TO_CHAR(rec.kezdo_datum || ' - ' || rec.vege_datum || ' | ' || rec.tanfolyam_kod || ' | ' || rec.felelos || ' | ' || rec.hely
           || ' | ' || rec.oktato || ' | ' || rec.max || ' | ' || rec.ideigl || ' | ' || rec.megerositett || ' | ' || rec.ossz || ' | ' || rec.keszenl));
        END LOOP;
        CLOSE cursl;   
    END tanfolyam_utemterv;
/

SET SERVEROUTPUT ON; 
EXEC tanfolyam_utemterv;


select * from tanfolyam_tipus_arvaltozas;

SELECT COUNT(*) as reszrvevo_szam FROM foglalas WHERE ugyfel_nev = 'Ugyfel2' AND tanfolyam_kod = 'KZSFEB1' AND statusz <> 'Ideiglenes';

SELECT ar, nev FROM tanfolyam_tipus WHERE tipus_kod = (SELECT tipus_kod FROM tanfolyam WHERE tanfolyam_kod = 'KZSFEB1');
SELECT kezdo_datum, vege_datum FROM tanfolyam WHERE tanfolyam_kod = 'KZSFEB1'; 
SELECT kezdo_datum, ar FROM tanfolyam_tipus_arvaltozas WHERE tipus_kod = (SELECT tipus_kod FROM tanfolyam WHERE tanfolyam_kod = 'KZSFEB1');
SELECT COUNT(*) as reszrvevo_szam FROM foglalas WHERE ugyfel_nev = 'Ugyfel2' AND tanfolyam_kod = 'KZSFEB1' AND statusz <> 'Ideiglenes';
SELECT resztvevo_nev FROM foglalas WHERE ugyfel_nev = 'Ugyfel2' AND tanfolyam_kod = 'KZSFEB1' AND statusz <> 'Ideiglenes';


CREATE OR REPLACE PROCEDURE szamla_generalas ( in_ugyfel_nev IN STRING, in_tanf_kod IN STRING  ) IS
    tanfolyam_ar        INTEGER;
    tanfolyam_nev       VARCHAR2(50);
    tanfolyam_kezdet    DATE;
    tanfolyam_vege      DATE;
    
    valtozott_tanfolyam_ar  INTEGER := 0;
    valtozott_ar_datum      DATE;
    
    l_seed       BINARY_INTEGER;
    szamla_szam         INTEGER;
    ossz_ar             INTEGER;
    brutto_ar           INTEGER;
    afa                 FLOAT;
    resztvevok_szama    INTEGER;
        
    BEGIN
        l_seed := TO_NUMBER(TO_CHAR(SYSDATE,'YYYYDDMMSS'));
        DBMS_RANDOM.initialize (val => l_seed);
        szamla_szam := TRUNC(DBMS_RANDOM.value(low => 10000, high => 99999));
        DBMS_RANDOM.terminate;
        
        SELECT ar, nev INTO tanfolyam_ar, tanfolyam_nev FROM tanfolyam_tipus WHERE tipus_kod = (SELECT tipus_kod FROM tanfolyam WHERE tanfolyam_kod = in_tanf_kod);
        SELECT kezdo_datum, vege_datum INTO tanfolyam_kezdet, tanfolyam_vege FROM tanfolyam WHERE tanfolyam_kod = in_tanf_kod; 
        BEGIN
        SELECT kezdo_datum, ar INTO valtozott_ar_datum, valtozott_tanfolyam_ar FROM tanfolyam_tipus_arvaltozas WHERE tipus_kod = (SELECT tipus_kod FROM tanfolyam WHERE tanfolyam_kod = in_tanf_kod);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                valtozott_tanfolyam_ar := 0;
        END;
        SELECT COUNT(*) as reszrvevo_szam INTO resztvevok_szama FROM foglalas WHERE ugyfel_nev = in_ugyfel_nev AND tanfolyam_kod = in_tanf_kod AND statusz <> 'Ideiglenes';
        
        IF valtozott_tanfolyam_ar <> 0 THEN
            IF valtozott_ar_datum < SYSDATE THEN
                tanfolyam_ar := valtozott_tanfolyam_ar;
            END IF;
        END IF;
        
        ossz_ar := resztvevok_szama * tanfolyam_ar;
        brutto_ar := ossz_ar * 1.27;
        afa := brutto_ar - ossz_ar;
        
       DBMS_OUTPUT.PUT_LINE('Szamlaszam: ' || szamla_szam);
       DBMS_OUTPUT.PUT_LINE('Ugyfel: ' || in_ugyfel_nev); 
       DBMS_OUTPUT.PUT_LINE('Kiallitas Datuma: ' || TO_CHAR(SYSDATE, 'YYYY.MM.DD'));
       DBMS_OUTPUT.PUT_LINE('============================================================');
       DBMS_OUTPUT.PUT_LINE('Tanfolyam kod: ' || in_tanf_kod);
       DBMS_OUTPUT.PUT_LINE('Tanfolyam neve: ' || tanfolyam_nev);
       DBMS_OUTPUT.PUT_LINE('Tanfolyam kezdete: ' || tanfolyam_kezdet);
       DBMS_OUTPUT.PUT_LINE('Tanfolyam vege: ' || tanfolyam_vege);
       DBMS_OUTPUT.PUT_LINE('============================================================');
       FOR i IN (SELECT resztvevo_nev FROM foglalas WHERE ugyfel_nev = in_ugyfel_nev AND tanfolyam_kod = in_tanf_kod AND statusz <> 'Ideiglenes') LOOP
            DBMS_OUTPUT.PUT_LINE(' - ' || i.resztvevo_nev);
        END LOOP;
       DBMS_OUTPUT.PUT_LINE('Ar egy szemelyre: ' || tanfolyam_ar);
       DBMS_OUTPUT.PUT_LINE('============================================================');
       DBMS_OUTPUT.PUT_LINE('Ossz netto ar: ' || ossz_ar);
       DBMS_OUTPUT.PUT_LINE('Afa 27%: ' || afa);
       DBMS_OUTPUT.PUT_LINE('Ossz brutto ar: ' || brutto_ar);   
    END szamla_generalas;
/

EXEC szamla_generalas('Ugyfel1', 'STSFEB1');

EXEC szamla_generalas('Ugyfel2', 'KZSFEB1');


-- Összesített kimutatás egy oktató által tartandó/tartott tanfolyamokról


select oktato.nev as oktato, tanfolyam.tanfolyam_kod, tanfolyam.kezdo_datum, helyszin.nev as helyszin, foglalas.ossz as ossz
from tanfolyam join oktato_kijeloles on tanfolyam.tanfolyam_kod = oktato_kijeloles.tanfolyam_kod
join oktato on  oktato_kijeloles.oktato_kod = oktato.oktato_kod
join helyszin on tanfolyam.helyszin_kod = helyszin.helyszin_kod
join (
SELECT tanfolyam_kod, 
count(CASE WHEN statusz = 'Megerositett' THEN 1 ELSE NULL END) AS megerositett,
count(CASE WHEN statusz = 'Megerositett + Készenlét' THEN 1 ELSE NULL END) AS keszenl,
count(CASE WHEN statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ideigl,
count(CASE WHEN statusz = 'Megerositett' OR statusz = 'Megerositett + Készenlét' THEN 1 ELSE NULL END) AS ossz
FROM foglalas GROUP BY tanfolyam_kod ) foglalas on foglalas.tanfolyam_kod = tanfolyam.tanfolyam_kod
where oktato.nev = 'Nagy Béla';

CREATE OR REPLACE PROCEDURE oktato_teszt( in_oktatonev IN STRING ) IS
    CURSOR curs1 IS select oktato.nev as oktato, tanfolyam.tanfolyam_kod, tanfolyam.kezdo_datum, helyszin.nev as helyszin, foglalas.ossz as ossz
                from tanfolyam join oktato_kijeloles on tanfolyam.tanfolyam_kod = oktato_kijeloles.tanfolyam_kod
                join oktato on  oktato_kijeloles.oktato_kod = oktato.oktato_kod
                join helyszin on tanfolyam.helyszin_kod = helyszin.helyszin_kod
                join (
                SELECT tanfolyam_kod, 
                count(CASE WHEN statusz = 'Megerositett' THEN 1 ELSE NULL END) AS megerositett,
                count(CASE WHEN statusz = 'Megerositett + Készenlét' THEN 1 ELSE NULL END) AS keszenl,
                count(CASE WHEN statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ideigl,
                count(CASE WHEN statusz = 'Megerositett' OR statusz = 'Megerositett + Készenlét' THEN 1 ELSE NULL END) AS ossz
                FROM foglalas GROUP BY tanfolyam_kod ) foglalas on foglalas.tanfolyam_kod = tanfolyam.tanfolyam_kod
                where oktato.nev = in_oktatonev;
                
    rec curs1%rowtype;
    
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Oktato | Tanf.kod | Kezdo Datum | Hely | Ossz');
        OPEN curs1;
        LOOP
            FETCH curs1 INTO rec;
            EXIT WHEN curs1%notfound;
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(rec.oktato || ' | ' || rec.tanfolyam_kod || ' | ' || rec.kezdo_datum || ' | ' || rec.helyszin || ' | ' || rec.ossz));
        END LOOP;
        CLOSE curs1;
    END oktato_teszt;
/

SET SERVEROUTPUT ON; 
EXEC oktato_teszt('Nagy Béla');


-- Összesített kimutatás egy tanfolyamfelelõshöz tartozó tanfolyamokról
SELECT tanfolyam_tipus.oktato_kod as felelos, tanfolyam_tipus.tipus_kod as tipuskod, tanfolyam_tipus.ar as ar, tanfolyam.tanfolyam_kod,
tanfolyam.kezdo_datum, helyszin.nev as helyszin, oktato.nev as oktato, 
tanfolyam_tipus.max_letszam as max, foglalas.ideigl as ideigl, foglalas.megerositett as megerositett, foglalas.ossz as ossz, foglalas.keszenl as keszenl
FROM tanfolyam_tipus JOIN tanfolyam ON tanfolyam_tipus.tipus_kod = tanfolyam.tipus_kod
JOIN oktato_kijeloles ON tanfolyam.tanfolyam_kod = oktato_kijeloles.tanfolyam_kod
JOIN oktato ON oktato_kijeloles.oktato_kod = oktato.oktato_kod
JOIN helyszin ON tanfolyam.helyszin_kod = helyszin.helyszin_kod
JOIN (
SELECT tanfolyam_kod, 
count(CASE WHEN statusz = 'Megerositett' THEN 1 ELSE NULL END) AS megerositett,
count(CASE WHEN statusz = 'Megerositett + Készenlét' THEN 1 ELSE NULL END) AS keszenl,
count(CASE WHEN statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ideigl,
count(CASE WHEN statusz = 'Megerositett' OR statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ossz
FROM foglalas GROUP BY tanfolyam_kod ) foglalas on foglalas.tanfolyam_kod = tanfolyam.tanfolyam_kod
WHERE tanfolyam_tipus.oktato_kod = (SELECT oktato_kod FROM oktato WHERE tanf_felelos = 'I' AND nev = 'Gipsz Jakab');


CREATE OR REPLACE PROCEDURE tanfolyamfelelos_teszt( in_tanfolyamfelelos_nev IN STRING ) IS
    CURSOR curs1 IS SELECT tanfolyam_tipus.oktato_kod as felelos, tanfolyam_tipus.tipus_kod as tipuskod, tanfolyam_tipus.ar as ar, tanfolyam.tanfolyam_kod,
                            tanfolyam.kezdo_datum, helyszin.nev as helyszin, oktato.nev as oktato, 
                            tanfolyam_tipus.max_letszam as max, foglalas.ideigl as ideigl, foglalas.megerositett as megerositett, foglalas.ossz as ossz, foglalas.keszenl as keszenl
                            FROM tanfolyam_tipus JOIN tanfolyam ON tanfolyam_tipus.tipus_kod = tanfolyam.tipus_kod
                            JOIN oktato_kijeloles ON tanfolyam.tanfolyam_kod = oktato_kijeloles.tanfolyam_kod
                            JOIN oktato ON oktato_kijeloles.oktato_kod = oktato.oktato_kod
                            JOIN helyszin ON tanfolyam.helyszin_kod = helyszin.helyszin_kod
                            JOIN (
                            SELECT tanfolyam_kod, 
                            count(CASE WHEN statusz = 'Megerositett' THEN 1 ELSE NULL END) AS megerositett,
                            count(CASE WHEN statusz = 'Megerositett + Készenlét' THEN 1 ELSE NULL END) AS keszenl,
                            count(CASE WHEN statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ideigl,
                            count(CASE WHEN statusz = 'Megerositett' OR statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ossz
                            FROM foglalas GROUP BY tanfolyam_kod ) foglalas on foglalas.tanfolyam_kod = tanfolyam.tanfolyam_kod
                            WHERE tanfolyam_tipus.oktato_kod = (SELECT oktato_kod FROM oktato WHERE tanf_felelos = 'I' AND nev = in_tanfolyamfelelos_nev);
                
    rec curs1%rowtype;
    valtozott_tanfolyam_ar  INTEGER := 0;
    valtozott_ar_datum      DATE;
    tanfolyam_ar            INTEGER;
    
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Felelos | Tanfolyam Tipus | Ar | Tanfolyam Kod | Kezdo Datum | Hely | Oktato | Max. | Ideigl. | Megerositett | Ossz. | Keszenl.');
        OPEN curs1;
        LOOP
            FETCH curs1 INTO rec;
            EXIT WHEN curs1%notfound;
            
            tanfolyam_ar := rec.ar;
            BEGIN
                SELECT kezdo_datum, ar INTO valtozott_ar_datum, valtozott_tanfolyam_ar FROM tanfolyam_tipus_arvaltozas WHERE tipus_kod = rec.tipuskod;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                valtozott_tanfolyam_ar := 0;
            END;
            
            IF valtozott_tanfolyam_ar <> 0 THEN
                IF rec.kezdo_datum > valtozott_ar_datum  AND valtozott_ar_datum < SYSDATE THEN
                    tanfolyam_ar := valtozott_tanfolyam_ar;
                END IF;
            END IF;
            
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(rec.felelos || ' | ' || rec.tipuskod || ' | ' || tanfolyam_ar || ' | ' || rec.tanfolyam_kod || ' | ' || rec.kezdo_datum || ' | ' || rec.helyszin || ' | ' || rec. oktato
            || ' | ' || rec.max || ' | ' || rec.ideigl || ' | ' || rec.megerositett || ' | ' || rec.ossz || ' | ' || rec.keszenl));
        END LOOP;
        CLOSE curs1;
    END tanfolyamfelelos_teszt;
/

EXEC tanfolyamfelelos_teszt('Gipsz Jakab');

EXEC tanfolyamfelelos_teszt('Vad Dalma');

select * from tanfolyam_tipus_arvaltozas;

select * from tanfolyam join tanfolyam_tipus on tanfolyam.tipus_kod = tanfolyam_tipus.tipus_kod;


-- Kimutatás egy adott helyszínen tartandó/tartott tanfolyamok résztvevõirõl

SELECT helyszin.nev as helyszin, tanfolyam_tipus.oktato_kod as felelos, tanfolyam_tipus.tipus_kod as tipuskod, tanfolyam_tipus.ar as ar, tanfolyam.tanfolyam_kod,
tanfolyam.kezdo_datum, oktato.nev as oktato, 
tanfolyam_tipus.max_letszam as max, foglalas.ideigl as ideigl, foglalas.megerositett as megerositett, foglalas.ossz as ossz, foglalas.keszenl as keszenl
FROM tanfolyam_tipus JOIN tanfolyam ON tanfolyam_tipus.tipus_kod = tanfolyam.tipus_kod
JOIN oktato_kijeloles ON tanfolyam.tanfolyam_kod = oktato_kijeloles.tanfolyam_kod
JOIN oktato ON oktato_kijeloles.oktato_kod = oktato.oktato_kod
JOIN helyszin ON tanfolyam.helyszin_kod = helyszin.helyszin_kod
JOIN (
SELECT tanfolyam_kod, 
count(CASE WHEN statusz = 'Megerositett' THEN 1 ELSE NULL END) AS megerositett,
count(CASE WHEN statusz = 'Megerositett + Készenlét' THEN 1 ELSE NULL END) AS keszenl,
count(CASE WHEN statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ideigl,
count(CASE WHEN statusz = 'Megerositett' OR statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ossz
FROM foglalas GROUP BY tanfolyam_kod ) foglalas on foglalas.tanfolyam_kod = tanfolyam.tanfolyam_kod
WHERE helyszin.nev = 'Fehér ház';

CREATE OR REPLACE PROCEDURE helyszin_teszt_resztvevok( in_tanf_kod IN STRING ) IS
    BEGIN
        FOR i IN (SELECT resztvevo_nev, ugyfel_nev FROM foglalas WHERE tanfolyam_kod = in_tanf_kod AND statusz <> 'Ideiglenes') LOOP
                DBMS_OUTPUT.PUT_LINE(' - ' || i.resztvevo_nev || ' | ' ||  'Innen:' || ' - ' || i.ugyfel_nev );
            END LOOP;  
    END helyszin_teszt_resztvevok;
/

CREATE OR REPLACE PROCEDURE helyszin_teszt( in_helyszin_nev IN STRING ) IS
    CURSOR curs1 IS SELECT helyszin.nev as helyszin, tanfolyam_tipus.oktato_kod as felelos, tanfolyam_tipus.tipus_kod as tipuskod, tanfolyam_tipus.ar as ar, tanfolyam.tanfolyam_kod,
                            tanfolyam.kezdo_datum, oktato.nev as oktato, 
                            tanfolyam_tipus.max_letszam as max, foglalas.ideigl as ideigl, foglalas.megerositett as megerositett, foglalas.ossz as ossz, foglalas.keszenl as keszenl
                            FROM tanfolyam_tipus JOIN tanfolyam ON tanfolyam_tipus.tipus_kod = tanfolyam.tipus_kod
                            JOIN oktato_kijeloles ON tanfolyam.tanfolyam_kod = oktato_kijeloles.tanfolyam_kod
                            JOIN oktato ON oktato_kijeloles.oktato_kod = oktato.oktato_kod
                            JOIN helyszin ON tanfolyam.helyszin_kod = helyszin.helyszin_kod
                            JOIN (
                            SELECT tanfolyam_kod, 
                            count(CASE WHEN statusz = 'Megerositett' THEN 1 ELSE NULL END) AS megerositett,
                            count(CASE WHEN statusz = 'Megerositett + Készenlét' THEN 1 ELSE NULL END) AS keszenl,
                            count(CASE WHEN statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ideigl,
                            count(CASE WHEN statusz = 'Megerositett' OR statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ossz
                            FROM foglalas GROUP BY tanfolyam_kod ) foglalas on foglalas.tanfolyam_kod = tanfolyam.tanfolyam_kod
                            WHERE helyszin.nev = in_helyszin_nev;
                
    rec curs1%rowtype;
    valtozott_tanfolyam_ar  INTEGER := 0;
    valtozott_ar_datum      DATE;
    tanfolyam_ar            INTEGER;
    
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Hely | Felelos | Tanfolyam Tipus | Ar | Tanfolyam Kod | Kezdo Datum  | Oktato | Max. | Ideigl. | Megerositett | Ossz. | Keszenl.');
        OPEN curs1;
        LOOP
            FETCH curs1 INTO rec;
            EXIT WHEN curs1%notfound;
            
            tanfolyam_ar := rec.ar;
            BEGIN
                SELECT kezdo_datum, ar INTO valtozott_ar_datum, valtozott_tanfolyam_ar FROM tanfolyam_tipus_arvaltozas WHERE tipus_kod = rec.tipuskod;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                valtozott_tanfolyam_ar := 0;
            END;
            
            IF valtozott_tanfolyam_ar <> 0 THEN
                IF rec.kezdo_datum > valtozott_ar_datum  AND valtozott_ar_datum < SYSDATE THEN
                    tanfolyam_ar := valtozott_tanfolyam_ar;
                END IF;
            END IF;
            
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(rec.helyszin || ' | ' || rec.felelos || ' | ' || rec.tipuskod || ' | ' || tanfolyam_ar || ' | ' || rec.tanfolyam_kod || ' | ' || rec.kezdo_datum || ' | ' || rec. oktato
            || ' | ' || rec.max || ' | ' || rec.ideigl || ' | ' || rec.megerositett || ' | ' || rec.ossz || ' | ' || rec.keszenl));
            DBMS_OUTPUT.PUT_LINE('Megerõsítettek: ');
            helyszin_teszt_resztvevok(rec.tanfolyam_kod);
        END LOOP;
        CLOSE curs1;
    END helyszin_teszt;
/

SET SERVEROUTPUT ON; 
EXEC helyszin_teszt('Fehér ház');


-- Kimutatás egy adott tanfolyam értékeléseirõl (témakörönként összesítve a válaszadók száma és a válaszok átlaga)

select * from tanfolyam_ertekeles;

-- tanfolyam értekelesek egyeb tanfolyam adatokkal
SELECT helyszin.nev as helyszin, tanfolyam_tipus.oktato_kod as felelos, tanfolyam_tipus.tipus_kod as tipuskod, tanfolyam_tipus.ar as ar, tanfolyam.tanfolyam_kod,
tanfolyam.kezdo_datum, oktato.nev as oktato, 
tanfolyam_tipus.max_letszam as max, foglalas.ideigl as ideigl, foglalas.megerositett as megerositett, foglalas.ossz as ossz, foglalas.keszenl as keszenl,
tanfolyam_ertekeles.temakor, tanfolyam_ertekeles.darab, tanfolyam_ertekeles.atlag
FROM tanfolyam_tipus JOIN tanfolyam ON tanfolyam_tipus.tipus_kod = tanfolyam.tipus_kod
JOIN oktato_kijeloles ON tanfolyam.tanfolyam_kod = oktato_kijeloles.tanfolyam_kod
JOIN oktato ON oktato_kijeloles.oktato_kod = oktato.oktato_kod
JOIN helyszin ON tanfolyam.helyszin_kod = helyszin.helyszin_kod
JOIN tanfolyam_ertekeles ON tanfolyam.tanfolyam_kod = tanfolyam_ertekeles.tanfolyam_kod
JOIN (
SELECT tanfolyam_kod, 
count(CASE WHEN statusz = 'Megerositett' THEN 1 ELSE NULL END) AS megerositett,
count(CASE WHEN statusz = 'Megerositett + Készenlét' THEN 1 ELSE NULL END) AS keszenl,
count(CASE WHEN statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ideigl,
count(CASE WHEN statusz = 'Megerositett' OR statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ossz
FROM foglalas GROUP BY tanfolyam_kod ) foglalas on foglalas.tanfolyam_kod = tanfolyam.tanfolyam_kod
WHERE tanfolyam.tanfolyam_kod = 'CSTJAN1';

-- Kimutatás a jóváírásról egy adott ügyfél részére (már kiszámlázott tanfolyam estén, ha utóbb a tanfolyamot vagy egy résztvevõt töröltek)

-- adott ugyfelnek hol vannak kuldottjei és mennyi ember
SELECT tanfolyam_tipus.oktato_kod as felelos, tanfolyam_tipus.tipus_kod as tipuskod, tanfolyam_tipus.ar as ar, tanfolyam.tanfolyam_kod, helyszin.nev as helyszin,
tanfolyam.kezdo_datum, oktato.nev as oktato, 
tanfolyam_tipus.max_letszam as max, foglalas.ideigl as ideigl, foglalas.megerositett as megerositett, foglalas.ossz as ossz, foglalas.keszenl as keszenl, foglalas.ugyfel_nev
FROM tanfolyam_tipus JOIN tanfolyam ON tanfolyam_tipus.tipus_kod = tanfolyam.tipus_kod
JOIN oktato_kijeloles ON tanfolyam.tanfolyam_kod = oktato_kijeloles.tanfolyam_kod
JOIN oktato ON oktato_kijeloles.oktato_kod = oktato.oktato_kod
JOIN helyszin ON tanfolyam.helyszin_kod = helyszin.helyszin_kod
JOIN (
SELECT ugyfel_nev, tanfolyam_kod, 
count(CASE WHEN statusz = 'Megerositett' THEN 1 ELSE NULL END) AS megerositett,
count(CASE WHEN statusz = 'Megerositett + Készenlét' THEN 1 ELSE NULL END) AS keszenl,
count(CASE WHEN statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ideigl,
count(CASE WHEN statusz = 'Megerositett' OR statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ossz
FROM foglalas GROUP BY tanfolyam_kod, ugyfel_nev ) foglalas on foglalas.tanfolyam_kod = tanfolyam.tanfolyam_kod
WHERE foglalas.ugyfel_nev = 'Ugyfel2';

CREATE OR REPLACE PROCEDURE hol_vannak_kuldottei_ugyfelnek( in_ugyfel_nev IN STRING ) IS
    CURSOR curs1 IS SELECT tanfolyam_tipus.oktato_kod as felelos, tanfolyam_tipus.tipus_kod as tipuskod, tanfolyam_tipus.ar as ar, tanfolyam.tanfolyam_kod, helyszin.nev as helyszin,
                            tanfolyam.kezdo_datum, oktato.nev as oktato, 
                            tanfolyam_tipus.max_letszam as max, foglalas.ideigl as ideigl, foglalas.megerositett as megerositett, foglalas.ossz as ossz, foglalas.keszenl as keszenl, foglalas.ugyfel_nev
                            FROM tanfolyam_tipus JOIN tanfolyam ON tanfolyam_tipus.tipus_kod = tanfolyam.tipus_kod
                            JOIN oktato_kijeloles ON tanfolyam.tanfolyam_kod = oktato_kijeloles.tanfolyam_kod
                            JOIN oktato ON oktato_kijeloles.oktato_kod = oktato.oktato_kod
                            JOIN helyszin ON tanfolyam.helyszin_kod = helyszin.helyszin_kod
                            JOIN (
                            SELECT ugyfel_nev, tanfolyam_kod, 
                            count(CASE WHEN statusz = 'Megerositett' THEN 1 ELSE NULL END) AS megerositett,
                            count(CASE WHEN statusz = 'Megerositett + Készenlét' THEN 1 ELSE NULL END) AS keszenl,
                            count(CASE WHEN statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ideigl,
                            count(CASE WHEN statusz = 'Megerositett' OR statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ossz
                            FROM foglalas GROUP BY tanfolyam_kod, ugyfel_nev ) foglalas on foglalas.tanfolyam_kod = tanfolyam.tanfolyam_kod
                            WHERE foglalas.ugyfel_nev = in_ugyfel_nev;
                
    rec curs1%rowtype;
    valtozott_tanfolyam_ar  INTEGER := 0;
    valtozott_ar_datum      DATE;
    tanfolyam_ar            INTEGER;
    
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Felelos | Tanfolyam Tipus | Ar | Tanfolyam Kod | Helyszin | Kezdo Datum  | Oktato | Max. | Ideigl. | Megerositett | Ossz. | Keszenl. | Ugyfel Nev');
        OPEN curs1;
        LOOP
            FETCH curs1 INTO rec;
            EXIT WHEN curs1%notfound;

            tanfolyam_ar := rec.ar;
            BEGIN
                SELECT kezdo_datum, ar INTO valtozott_ar_datum, valtozott_tanfolyam_ar FROM tanfolyam_tipus_arvaltozas WHERE tipus_kod = rec.tipuskod;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                valtozott_tanfolyam_ar := 0;
            END;
            
            IF valtozott_tanfolyam_ar <> 0 THEN
                IF rec.kezdo_datum > valtozott_ar_datum  AND valtozott_ar_datum < SYSDATE THEN
                    tanfolyam_ar := valtozott_tanfolyam_ar;
                END IF;
            END IF;
            
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(rec.felelos || ' | ' || rec.tipuskod || ' | ' || tanfolyam_ar || ' | ' || rec.tanfolyam_kod || ' | ' || rec.helyszin || ' | ' ||  rec.kezdo_datum || ' | ' || rec. oktato
            || ' | ' || rec.max || ' | ' || rec.ideigl || ' | ' || rec.megerositett || ' | ' || rec.ossz || ' | ' || rec.keszenl || ' | ' || rec.ugyfel_nev));
        END LOOP;
        CLOSE curs1;
    END hol_vannak_kuldottei_ugyfelnek;
/

SET SERVEROUTPUT ON; 
EXEC hol_vannak_kuldottei_ugyfelnek('Ugyfel2');


-- Tanfolyam árváltozásai (input: tanfolyam típus)

select * from tanfolyam_tipus_arvaltozas;

SELECT helyszin.nev as helyszin, tanfolyam_tipus.oktato_kod as felelos, tanfolyam_tipus.tipus_kod as tipuskod, tanfolyam_tipus.ar as ar, tanfolyam_tipus_arvaltozas.ar as februartol_valtozott_ar, tanfolyam.tanfolyam_kod,
tanfolyam.kezdo_datum, oktato.nev as oktato, 
tanfolyam_tipus.max_letszam as max, foglalas.ideigl as ideigl, foglalas.megerositett as megerositett, foglalas.ossz as ossz, foglalas.keszenl as keszenl
FROM tanfolyam_tipus JOIN tanfolyam ON tanfolyam_tipus.tipus_kod = tanfolyam.tipus_kod
JOIN oktato_kijeloles ON tanfolyam.tanfolyam_kod = oktato_kijeloles.tanfolyam_kod
JOIN oktato ON oktato_kijeloles.oktato_kod = oktato.oktato_kod
JOIN helyszin ON tanfolyam.helyszin_kod = helyszin.helyszin_kod
JOIN tanfolyam_tipus_arvaltozas ON tanfolyam_tipus.tipus_kod = tanfolyam_tipus_arvaltozas.tipus_kod
JOIN (
SELECT tanfolyam_kod, 
count(CASE WHEN statusz = 'Megerositett' THEN 1 ELSE NULL END) AS megerositett,
count(CASE WHEN statusz = 'Megerositett + Készenlét' THEN 1 ELSE NULL END) AS keszenl,
count(CASE WHEN statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ideigl,
count(CASE WHEN statusz = 'Megerositett' OR statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ossz
FROM foglalas GROUP BY tanfolyam_kod ) foglalas on foglalas.tanfolyam_kod = tanfolyam.tanfolyam_kod
WHERE tanfolyam_tipus.tipus_kod = 'CST';


CREATE OR REPLACE PROCEDURE tanfolyam_arvaltozas_teszt( in_tanfolyam_tipus_kod IN tanfolyam.tipus_kod%TYPE ) IS
    CURSOR curs1 IS SELECT helyszin.nev as helyszin, tanfolyam_tipus.oktato_kod as felelos, tanfolyam_tipus.tipus_kod as tipuskod, tanfolyam_tipus.ar as ar, tanfolyam.tanfolyam_kod,
                            tanfolyam.kezdo_datum, oktato.nev as oktato, 
                            tanfolyam_tipus.max_letszam as max, foglalas.ideigl as ideigl, foglalas.megerositett as megerositett, foglalas.ossz as ossz, foglalas.keszenl as keszenl
                            FROM tanfolyam_tipus JOIN tanfolyam ON tanfolyam_tipus.tipus_kod = tanfolyam.tipus_kod
                            JOIN oktato_kijeloles ON tanfolyam.tanfolyam_kod = oktato_kijeloles.tanfolyam_kod
                            JOIN oktato ON oktato_kijeloles.oktato_kod = oktato.oktato_kod
                            JOIN helyszin ON tanfolyam.helyszin_kod = helyszin.helyszin_kod
                            JOIN (
                            SELECT tanfolyam_kod, 
                            count(CASE WHEN statusz = 'Megerositett' THEN 1 ELSE NULL END) AS megerositett,
                            count(CASE WHEN statusz = 'Megerositett + Készenlét' THEN 1 ELSE NULL END) AS keszenl,
                            count(CASE WHEN statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ideigl,
                            count(CASE WHEN statusz = 'Megerositett' OR statusz = 'Ideiglenes' THEN 1 ELSE NULL END) AS ossz
                            FROM foglalas GROUP BY tanfolyam_kod ) foglalas on foglalas.tanfolyam_kod = tanfolyam.tanfolyam_kod
                            WHERE tanfolyam_tipus.tipus_kod = in_tanfolyam_tipus_kod ORDER BY tanfolyam.kezdo_datum;
                
    rec curs1%rowtype;
    valtozott_tanfolyam_ar  INTEGER := 0;
    valtozott_ar_datum      DATE;
    tanfolyam_ar            INTEGER;
    
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Hely | Felelos | Tanfolyam Tipus | Ar | Tanfolyam Kod | Kezdo Datum  | Oktato | Max. | Ideigl. | Megerositett | Ossz. | Keszenl.');
        OPEN curs1;
        LOOP
            FETCH curs1 INTO rec;
            EXIT WHEN curs1%notfound;

            tanfolyam_ar := rec.ar;
            BEGIN
                SELECT kezdo_datum, ar INTO valtozott_ar_datum, valtozott_tanfolyam_ar FROM tanfolyam_tipus_arvaltozas WHERE tipus_kod = rec.tipuskod;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                valtozott_tanfolyam_ar := 0;
            END;
            
            IF valtozott_tanfolyam_ar <> 0 THEN
                IF rec.kezdo_datum > valtozott_ar_datum  AND valtozott_ar_datum < SYSDATE THEN
                    tanfolyam_ar := valtozott_tanfolyam_ar;
                END IF;
            END IF;
            
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(rec.helyszin || ' | ' || rec.felelos || ' | ' || rec.tipuskod || ' | ' || tanfolyam_ar || ' | ' || rec.tanfolyam_kod || ' | ' || rec.kezdo_datum || ' | ' || rec. oktato
            || ' | ' || rec.max || ' | ' || rec.ideigl || ' | ' || rec.megerositett || ' | ' || rec.ossz || ' | ' || rec.keszenl));
        END LOOP;
        CLOSE curs1;
    END tanfolyam_arvaltozas_teszt;
/

EXEC tanfolyam_arvaltozas_teszt('CST');

    