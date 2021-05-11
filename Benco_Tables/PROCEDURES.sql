select cikkszam, sum(mennyiseg) from vasarloi_rendeles natural join vasarloi_rendeles_sor where rend_datum = '19-JAN.  -23' 
group by cikkszam; -- adott napon mibõl mennyit kell rendelni a cégnek

SET SERVEROUTPUT ON; 

CREATE OR REPLACE PROCEDURE termekertekesitesi_beszamolo( in_cikkszam IN INTEGER ) IS
    ar termek.a_ar%TYPE;
    CURSOR curs1 IS SELECT cikkszam, megnevezes, vrszam, rend_datum, vkod, nev, mennyiseg,kedvezmeny_kod, a_ar, b_ar, c_ar, d_ar
                            FROM vevo NATURAL JOIN vasarloi_rendeles
                            vasarloi_rendeles NATURAL JOIN vasarloi_rendeles_sor 
                            vasarloi_rendeles_sor NATURAL JOIN termek
                            WHERE cikkszam=in_cikkszam;
    rec curs1%rowtype;
    BEGIN
        OPEN curs1;
        FETCH curs1 INTO rec;
        DBMS_OUTPUT.PUT_LINE('Termekertekesítesi beszamolo');
        DBMS_OUTPUT.PUT_LINE('Cikkszam: ' || rec.cikkszam);
        DBMS_OUTPUT.PUT_LINE('Megnevezes: ' || rec.megnevezes);
        DBMS_OUTPUT.PUT_LINE('V.R.Sz.'|| '  |  ' ||'Datum'|| '  |  ' ||'Vevo SZ.'|| '  |  ' ||'Nev'|| '  |  ' ||'Mennyiseg'|| '  |  ' ||'Ar');
        LOOP
            EXIT WHEN curs1%notfound;
            CASE
                WHEN rec.kedvezmeny_kod = 'A' THEN ar := rec.a_ar;
                WHEN rec.kedvezmeny_kod = 'B' THEN ar := rec.b_ar;
                WHEN rec.kedvezmeny_kod = 'C' THEN ar := rec.c_ar;
                WHEN rec.kedvezmeny_kod = 'D' THEN ar := rec.d_ar;
            END CASE;
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(rec.vrszam|| '  |  ' || rec.rend_datum || '  |  ' || rec.vkod|| '  |  ' ||rec.nev|| '  |  ' || rec.mennyiseg|| '  |  ' || rec.mennyiseg*ar ));
            FETCH curs1 INTO rec;
        END LOOP;
        CLOSE curs1;
    END termekertekesitesi_beszamolo;
/

EXEC termekertekesitesi_beszamolo(1);


CREATE OR REPLACE PROCEDURE ertekesitesi_korzet_beszamolo( in_korzet IN STRING ) IS
    CURSOR cursl IS SELECT vevo.vkod AS vkod, COUNT(vasarloi_rendeles.vkod) AS eddigi_megrendelesek, SUM(DISTINCT utalas.osszeg) AS szamlaegyenleg, SUM(szamla.netto_osszeg) AS megrendelt_ertek FROM 
                        vevo LEFT JOIN vasarloi_rendeles ON vevo.vkod = vasarloi_rendeles.vkod 
                        LEFT JOIN utalas  ON vevo.vkod = utalas.vkod    
                        LEFT JOIN szamla ON vasarloi_rendeles.vrszam = szamla.vrszam
                        WHERE korzet = in_korzet
                        GROUP BY vevo.vkod
                        ORDER BY vevo.vkod;
                        
    rec cursl%rowtype;
    osszes_megrendeles INTEGER := 0;
    osszes_megrendelt_ertek INTEGER := 0;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Ertekesitesi korzet sz.: ' || in_korzet );
        DBMS_OUTPUT.PUT_LINE('Vevo Sz. | Eddigi Megrendelesek | Szamla Egyenleg | Megrend. Erteke');
        OPEN cursl;
        LOOP
            FETCH cursl INTO rec;
            EXIT WHEN cursl%notfound;
            DBMS_OUTPUT.PUT_LINE(rec.vkod || ' | ' || rec.eddigi_megrendelesek || ' | ' || rec.szamlaegyenleg || ' | ' || rec.megrendelt_ertek);
            osszes_megrendeles := osszes_megrendeles + rec.eddigi_megrendelesek;
            IF rec.megrendelt_ertek > 0 THEN
                osszes_megrendelt_ertek := osszes_megrendelt_ertek + rec.megrendelt_ertek;
            END IF;
        END LOOP;
        CLOSE cursl;
        DBMS_OUTPUT.PUT_LINE('Osszes eddigi megrendeles: ' || osszes_megrendeles);
        DBMS_OUTPUT.PUT_LINE('Osszes eddigi megrendeles erteke: ' || osszes_megrendelt_ertek);
    END ertekesitesi_korzet_beszamolo;
/

EXEC ertekesitesi_korzet_beszamolo('Körzet1');


CREATE OR REPLACE PROCEDURE szamla_generalas ( in_vrszam IN INTEGER ) IS
    vevo_kod vasarloi_rendeles.vkod%TYPE;
    vevo_nev vevo.nev%TYPE;
    vevo_cim vevo.cim%TYPE;
    vevo_kedv_kod vevo.kedvezmeny_kod%TYPE;
    szamla_szam INTEGER;
    kedvezmenyes_ar termek.a_ar%TYPE;
    megnevezes termek.megnevezes%TYPE;
    egyseg termek.menny_egyseg%TYPE;
    listaar termek.listaar%TYPE;
    CURSOR cursl IS SELECT cikkszam, mennyiseg FROM vasarloi_rendeles_sor WHERE vrszam = in_vrszam ORDER BY cikkszam;
    
    rec cursl%rowtype;
    
    ar INTEGER := 0;
    netto_osszeg INTEGER := 0;
    afa FLOAT := 0;
    brutto_osszeg FLOAT := 0;
    tetel INTEGER := 1;
    szamla_letezik NUMBER;
    BEGIN
        SELECT vkod INTO vevo_kod FROM vasarloi_rendeles WHERE vrszam = in_vrszam;
        SELECT nev, cim, kedvezmeny_kod INTO vevo_nev, vevo_cim, vevo_kedv_kod FROM vevo WHERE vkod = vevo_kod;
        SELECT ROUND(DBMS_RANDOM.VALUE(4400,5000)) num INTO szamla_szam FROM dual;
        
        DBMS_OUTPUT.PUT_LINE('Datum: ' || TO_CHAR(SYSDATE, 'DD/MM/YY'));
        DBMS_OUTPUT.PUT_LINE('Szamla szam: ' || szamla_szam);
        DBMS_OUTPUT.PUT_LINE('Vevo sz.:' || vevo_kod);
        DBMS_OUTPUT.PUT_LINE('Vevo neve: ' || vevo_nev);
        DBMS_OUTPUT.PUT_LINE('Vevo címe: ' || vevo_cim);
        DBMS_OUTPUT.PUT_LINE('Vasarloi r. sz.: ' || in_vrszam);
        DBMS_OUTPUT.PUT_LINE('Tetel | Cikk Sz. | Megnevezes | Egyseg | Lista Ar | Kedv. Kod | Kedv. Ar | Menny. | Ar');
        OPEN cursl;
        LOOP
            FETCH cursl INTO rec;
            EXIT WHEN cursl%notfound;
            CASE
               WHEN vevo_kedv_kod= 'A' THEN SELECT a_ar INTO kedvezmenyes_ar FROM termek WHERE cikkszam = rec.cikkszam;
               WHEN vevo_kedv_kod = 'B' THEN SELECT b_ar INTO kedvezmenyes_ar FROM termek WHERE cikkszam = rec.cikkszam;
               WHEN vevo_kedv_kod = 'C' THEN SELECT c_ar INTO kedvezmenyes_ar FROM termek WHERE cikkszam = rec.cikkszam;
               WHEN vevo_kedv_kod = 'D' THEN SELECT d_ar INTO kedvezmenyes_ar FROM termek WHERE cikkszam = rec.cikkszam;
            END CASE;
            SELECT megnevezes INTO megnevezes FROM termek WHERE cikkszam = rec.cikkszam;
            SELECT menny_egyseg INTO egyseg FROM termek WHERE cikkszam = rec.cikkszam;
            SELECT listaar INTO listaar FROM termek WHERE cikkszam = rec.cikkszam;
            ar := rec.mennyiseg * kedvezmenyes_ar;
            netto_osszeg := netto_osszeg + ar;
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(tetel || '  |  ' || rec.cikkszam || '  |  ' || megnevezes || ' | ' || egyseg || ' | ' || listaar || ' | ' || vevo_kedv_kod || ' | ' || kedvezmenyes_ar || ' | ' || rec.mennyiseg || ' | ' || ar));
            tetel := tetel + 1;          
        END LOOP;
        CLOSE cursl;
        brutto_osszeg := netto_osszeg * 1.27;
        afa := brutto_osszeg - netto_osszeg;
        DBMS_OUTPUT.PUT_LINE('Netto osszeg: ' || netto_osszeg);
        DBMS_OUTPUT.PUT_LINE('AFA: ' || afa);
        DBMS_OUTPUT.PUT_LINE('Szamla ossz.: ' || brutto_osszeg);
        SELECT COUNT(*) INTO szamla_letezik FROM szamla WHERE vrszam = in_vrszam;
        IF szamla_letezik = 0 THEN
            INSERT INTO szamla VALUES (in_vrszam, szamla_szam, SYSDATE, SYSDATE, netto_osszeg, afa, brutto_osszeg);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Ez a szamla mar letezik!');
        END IF; 
    END szamla_generalas;
/

-- Szállítási jelentés esetén megadunk egy szállítói számot és az kiírja a 
-- cikkszámokat amit tõle vettük - Vásárlói rendelés számokat amik miatt vettük - vevõszámok akiknek kell majd küldeni - mennyiség, hogy neki mennyit
-- és kell a végére egy mennyiség, hogy össze ebbõl ennyit vettünk és akkor a fenti szerint oszlik meg.

-- Szállítói rendelés sor - termek - vasarloi rendeles sor - vasarloi rendelés    kell talán akkor natural joinba

-- cikkszam | vrszam | vkod | mennyiseg, adott vasarloi rendelese    és ennek az össze ami a szallitoi_rendeles_sor ban benne van melyik cikkszamból mennyi a max amit vettünk

-- 1 eseten akkor (szrszam)

-- 1 1 1 10
--   2 2 10
--   3 3 10
-- 	     30
	  
-- 2 1 1 20
--       20
	  
-- 5 2 2 14
--   3 3 14
--       28

-- cikkszam, vrszam, vkod, mennyiseg, rend_datum
select * from szallitoi_rendeles_sor natural join szallitoi_rendeles where szrszam = 1;
select * from vasarloi_rendeles natural join vasarloi_rendeles_sor;

SELECT szallitoi.cikkszam,szallitoi.szkod, rendelesi.vrszam, rendelesi.vkod, szallitoi.rend_datum, rendelesi.mennyiseg, szallitoi.mennyiseg 
AS ossz FROM (SELECT * FROM szallitoi_rendeles_sor NATURAL JOIN szallitoi_rendeles WHERE szrszam = 1) szallitoi, 
(SELECT * FROM vasarloi_rendeles NATURAL JOIN vasarloi_rendeles_sor) rendelesi
wHERE szallitoi.cikkszam = rendelesi.cikkszam AND szallitoi.rend_datum = rendelesi.rend_datum ORDER BY szallitoi.cikkszam;

SET SERVEROUTPUT ON; 

CREATE OR REPLACE PROCEDURE szallitasi_jelentes(in_szrszam IN INTEGER) IS
    CURSOR cursl IS SELECT szallitoi.cikkszam AS cikkszam, szallitoi.szkod as szkod, rendelesi.vrszam AS vrszam, rendelesi.vkod AS vkod, szallitoi.rend_datum 
                AS rend_datum, rendelesi.mennyiseg AS mennyiseg, szallitoi.mennyiseg AS ossz 
                FROM (SELECT * FROM szallitoi_rendeles_sor NATURAL JOIN szallitoi_rendeles WHERE szrszam = in_szrszam) szallitoi, 
                (SELECT * FROM vasarloi_rendeles NATURAL JOIN vasarloi_rendeles_sor) rendelesi
                WHERE szallitoi.cikkszam = rendelesi.cikkszam AND szallitoi.rend_datum = rendelesi.rend_datum 
                ORDER BY cikkszam;
            
    rec cursl%rowtype;
    old_cikkszam INTEGER := 0;
    old_osszeg INTEGER := 0;
    BEGIN
        OPEN cursl;
        FETCH cursl INTO rec;
        DBMS_OUTPUT.PUT_LINE('Szallitasi jelentes');
        DBMS_OUTPUT.PUT_LINE('Szallitoi rendeles szam: ' || in_szrszam);
        DBMS_OUTPUT.PUT_LINE('Datum: ' || rec.rend_datum);
        DBMS_OUTPUT.PUT_LINE('Szallito: ' || rec.szkod);
        DBMS_OUTPUT.PUT_LINE('Vasarloi');
        DBMS_OUTPUT.PUT_LINE('Cikkszam' || ' | ' || 'Rendeles Szam' || ' | ' || 'Vevo Szam' || ' | ' || 'Mennyiseg');
        LOOP
            EXIT WHEN cursl%notfound;
            IF old_osszeg <> 0 AND old_cikkszam <> rec.cikkszam THEN
                DBMS_OUTPUT.PUT_LINE('Termek osszes: ' || old_osszeg); 
            END IF;
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(rec.cikkszam || ' | ' || rec.vrszam || ' | ' || rec.vkod || ' | ' || rec.mennyiseg));
            old_cikkszam := rec.cikkszam;
            old_osszeg := rec.ossz;
            FETCH cursl INTO rec;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Termek osszes: ' || old_osszeg);
        CLOSE cursl;
    END szallitasi_jelentes;
/

EXEC szallitasi_jelentes(4);


-- 3. vevõre pl legyen úgy, hogy felsorolja mit vesz. -> ami kb. a számlás ahogy nézem
-- lekerdezem a rendeleseit majd a szamlas kodot használom atalakitva a rendeleseire


select vrszam from vasarloi_rendeles where vkod = (select vkod from vevo where nev = 'Vevõ3');

CREATE OR REPLACE PROCEDURE mit_vett_seged ( in_vrszam IN INTEGER ) IS
    vevo_kod vasarloi_rendeles.vkod%TYPE;
    vevo_kedv_kod vevo.kedvezmeny_kod%TYPE;
    kedvezmenyes_ar termek.a_ar%TYPE;
    megnevezes termek.megnevezes%TYPE;
    egyseg termek.menny_egyseg%TYPE;
    listaar termek.listaar%TYPE;
    CURSOR cursl IS SELECT cikkszam, mennyiseg FROM vasarloi_rendeles_sor WHERE vrszam = in_vrszam ORDER BY cikkszam;
    
    rec cursl%rowtype;
    
    ar INTEGER := 0;
    netto_osszeg INTEGER := 0;
    tetel INTEGER := 1;
    BEGIN
        SELECT vkod INTO vevo_kod FROM vasarloi_rendeles WHERE vrszam = in_vrszam;
        SELECT kedvezmeny_kod INTO vevo_kedv_kod FROM vevo WHERE vkod = vevo_kod;
        
        DBMS_OUTPUT.PUT_LINE('Vevo sz.:' || vevo_kod);
        DBMS_OUTPUT.PUT_LINE('Vasarloi r. sz.: ' || in_vrszam);
        DBMS_OUTPUT.PUT_LINE('Tetel | Cikk Sz. | Megnevezes | Egyseg | Lista Ar | Kedv. Kod | Kedv. Ar | Menny. | Ar');
        OPEN cursl;
        LOOP
            FETCH cursl INTO rec;
            EXIT WHEN cursl%notfound;
            CASE
               WHEN vevo_kedv_kod= 'A' THEN SELECT a_ar INTO kedvezmenyes_ar FROM termek WHERE cikkszam = rec.cikkszam;
               WHEN vevo_kedv_kod = 'B' THEN SELECT b_ar INTO kedvezmenyes_ar FROM termek WHERE cikkszam = rec.cikkszam;
               WHEN vevo_kedv_kod = 'C' THEN SELECT c_ar INTO kedvezmenyes_ar FROM termek WHERE cikkszam = rec.cikkszam;
               WHEN vevo_kedv_kod = 'D' THEN SELECT d_ar INTO kedvezmenyes_ar FROM termek WHERE cikkszam = rec.cikkszam;
            END CASE;
            SELECT megnevezes INTO megnevezes FROM termek WHERE cikkszam = rec.cikkszam;
            SELECT menny_egyseg INTO egyseg FROM termek WHERE cikkszam = rec.cikkszam;
            SELECT listaar INTO listaar FROM termek WHERE cikkszam = rec.cikkszam;
            ar := rec.mennyiseg * kedvezmenyes_ar;
            netto_osszeg := netto_osszeg + ar;
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(tetel || '  |  ' || rec.cikkszam || '  |  ' || megnevezes || ' | ' || egyseg || ' | ' || listaar || ' | ' || vevo_kedv_kod || ' | ' || kedvezmenyes_ar || ' | ' || rec.mennyiseg || ' | ' || ar));
            tetel := tetel + 1;          
        END LOOP;
        CLOSE cursl;
        DBMS_OUTPUT.PUT_LINE('Netto osszeg: ' || netto_osszeg);
    END mit_vett_seged;
/

CREATE OR REPLACE PROCEDURE vevo_miket_vett ( in_vevo_nev IN STRING ) IS
    CURSOR cursl IS SELECT vrszam from vasarloi_rendeles where vkod = (select vkod from vevo where nev = in_vevo_nev);
    
    rec cursl%rowtype;
    vevo_kod vasarloi_rendeles.vkod%TYPE;
    vevo_nev vevo.nev%TYPE;
    vevo_cim vevo.cim%TYPE;
    vevo_kedv_kod vevo.kedvezmeny_kod%TYPE;
    
    BEGIN
    SELECT vkod INTO vevo_kod FROM vevo WHERE nev = in_vevo_nev;
    SELECT nev, cim, kedvezmeny_kod INTO vevo_nev, vevo_cim, vevo_kedv_kod FROM vevo WHERE vkod = vevo_kod;
    OPEN cursl;
    LOOP
            FETCH cursl INTO rec;
            EXIT WHEN cursl%notfound;
            mit_vett_seged(rec.vrszam);
    END LOOP;
    CLOSE cursl;
    END vevo_miket_vett;
/

SET SERVEROUTPUT ON; 
EXEC vevo_miket_vett('Vevõ3');


-- a termekek hol a legolcsóbbak ahonnan veheti a cég
CREATE OR REPLACE PROCEDURE legolcsobb_beszerzesi_hely IS
    CURSOR curs1 IS SELECT termek.cikkszam, termek.megnevezes, termekjegyzek.szkod, szallito.nev, termekjegyzek.ar as szallitoi_ar, termek.listaar
                            FROM termek JOIN termekjegyzek ON termek.cikkszam = termekjegyzek.cikkszam
                            JOIN szallito ON termekjegyzek.szkod = szallito.szkod ORDER BY termek.cikkszam;
    rec curs1%rowtype;
    legolcsobb_adott_termek_ar INTEGER := 0;
    kiiras_ar INTEGER := 0;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Cikkszam | Megnevezes | Szkod | Nev | Szallitoi Ar | Listaar');
        OPEN curs1;
        LOOP
            FETCH curs1 INTO rec;
            EXIT WHEN curs1%notfound;
            
            SELECT min(szallitoi_ar) INTO legolcsobb_adott_termek_ar FROM (SELECT termek.cikkszam, termek.megnevezes, termekjegyzek.szkod, szallito.nev, termekjegyzek.ar as szallitoi_ar, termek.listaar
            FROM termek JOIN termekjegyzek ON termek.cikkszam = termekjegyzek.cikkszam
            JOIN szallito ON termekjegyzek.szkod = szallito.szkod) WHERE cikkszam = rec.cikkszam;
            
            IF legolcsobb_adott_termek_ar = rec.szallitoi_ar THEN
                kiiras_ar := legolcsobb_adott_termek_ar;
            END IF;
            
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(rec.cikkszam|| '  |  ' || rec.megnevezes || '  |  ' || rec.szkod|| '  |  ' ||rec.nev|| '  |  ' || kiiras_ar || '  |  ' || rec.listaar ));
            FETCH curs1 INTO rec;
        END LOOP;
        CLOSE curs1;
    END legolcsobb_beszerzesi_hely;
/

EXEC legolcsobb_beszerzesi_hely;


  