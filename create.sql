-- Remove conflicting tables
DROP TABLE IF EXISTS administrator CASCADE;
DROP TABLE IF EXISTS cena CASCADE;
DROP TABLE IF EXISTS hra CASCADE;
DROP TABLE IF EXISTS kupec CASCADE;
DROP TABLE IF EXISTS platebni_karta CASCADE;
DROP TABLE IF EXISTS pozice CASCADE;
DROP TABLE IF EXISTS prodej CASCADE;
DROP TABLE IF EXISTS superuzivatel CASCADE;
DROP TABLE IF EXISTS uzivatel CASCADE;
DROP TABLE IF EXISTS vydavatel CASCADE;
DROP TABLE IF EXISTS vyvojar CASCADE;
DROP TABLE IF EXISTS zanr CASCADE;
DROP TABLE IF EXISTS platebni_karta_kupec CASCADE;
-- End of removing

CREATE TABLE administrator (
    id_uzivatel VARCHAR(30) NOT NULL,
    datum_nastupu_prace DATE NOT NULL
);
ALTER TABLE administrator ADD CONSTRAINT pk_administrator PRIMARY KEY (id_uzivatel);

CREATE TABLE cena (
    id_hra VARCHAR(30) NOT NULL,
    czk REAL NOT NULL,
    eur REAL NOT NULL,
    usd REAL NOT NULL,
    rub REAL NOT NULL,
    uah REAL NOT NULL
);
ALTER TABLE cena ADD CONSTRAINT pk_cena PRIMARY KEY (id_hra);

CREATE TABLE hra (
    id_hra VARCHAR(30) NOT NULL,
    id_uzivatel VARCHAR(30) NOT NULL,
    id_vydavatel VARCHAR(30) NOT NULL,
    vyvojar_id_uzivatel VARCHAR(30),
    id_zanr VARCHAR(30) NOT NULL,
    nazev_hra VARCHAR(20) NOT NULL,
    popis_hra TEXT NOT NULL
);
ALTER TABLE hra ADD CONSTRAINT pk_hra PRIMARY KEY (id_hra);

CREATE TABLE kupec (
    id_uzivatel VARCHAR(30) NOT NULL,
    id_kupec SERIAL NOT NULL
);
ALTER TABLE kupec ADD CONSTRAINT pk_kupec PRIMARY KEY (id_uzivatel);

CREATE TABLE platebni_karta (
    id_prodej BIGINT NOT NULL,
    cislo_karty INTEGER NOT NULL,
    datum_expirace VARCHAR(5) NOT NULL,
    majitel VARCHAR(40) NOT NULL
);
ALTER TABLE platebni_karta ADD CONSTRAINT pk_platebni_karta PRIMARY KEY (id_prodej);

CREATE TABLE pozice (
    id_uzivatel VARCHAR(30) NOT NULL,
    id_pozice VARCHAR(20) NOT NULL,
    nazev VARCHAR(50) NOT NULL,
    plat INTEGER NOT NULL
);
ALTER TABLE pozice ADD CONSTRAINT pk_pozice PRIMARY KEY (id_uzivatel);

CREATE TABLE prodej (
    id_prodej BIGINT NOT NULL,
    id_hra VARCHAR(30),
    id_uzivatel VARCHAR(30),
    datum_prodeje DATE NOT NULL,
    zpusob_platby VARCHAR(20) NOT NULL
);
ALTER TABLE prodej ADD CONSTRAINT pk_prodej PRIMARY KEY (id_prodej);

CREATE TABLE superuzivatel (
    id_uzivatel VARCHAR(30) NOT NULL,
    datum_narozeni DATE NOT NULL
);
ALTER TABLE superuzivatel ADD CONSTRAINT pk_superuzivatel PRIMARY KEY (id_uzivatel);

CREATE TABLE uzivatel (
    id_uzivatel VARCHAR(30) NOT NULL,
    login VARCHAR(16) NOT NULL,
    jmeno VARCHAR(20) NOT NULL,
    prijmeni VARCHAR(20) NOT NULL,
    datum_registrace DATE NOT NULL,
    role VARCHAR(20)
);
ALTER TABLE uzivatel ADD CONSTRAINT pk_uzivatel PRIMARY KEY (id_uzivatel);
ALTER TABLE uzivatel ADD CONSTRAINT uc_uzivatel_login UNIQUE (login);

CREATE TABLE vydavatel (
    id_vydavatel VARCHAR(30) NOT NULL,
    nazev_vydavatel VARCHAR(50) NOT NULL,
    ico INTEGER NOT NULL,
    sidlo VARCHAR(256) NOT NULL,
    popis_vydavatel TEXT NOT NULL,
    web_vydavatel VARCHAR(256) NOT NULL
);
ALTER TABLE vydavatel ADD CONSTRAINT pk_vydavatel PRIMARY KEY (id_vydavatel);

CREATE TABLE vyvojar (
    id_uzivatel VARCHAR(30) NOT NULL,
    popis_vyvojar VARCHAR(256) NOT NULL,
    web_vyvojar VARCHAR(256) NOT NULL
);
ALTER TABLE vyvojar ADD CONSTRAINT pk_vyvojar PRIMARY KEY (id_uzivatel);

CREATE TABLE zanr (
    id_zanr VARCHAR(30) NOT NULL,
    nazev_zanr VARCHAR(50) NOT NULL,
    popis_zanr TEXT NOT NULL,
    datum_pridani DATE NOT NULL,
    preference VARCHAR(256) NOT NULL
);
ALTER TABLE zanr ADD CONSTRAINT pk_zanr PRIMARY KEY (id_zanr);

CREATE TABLE platebni_karta_kupec (
    id_prodej BIGINT NOT NULL,
    id_uzivatel VARCHAR(30) NOT NULL
);
ALTER TABLE platebni_karta_kupec ADD CONSTRAINT pk_platebni_karta_kupec PRIMARY KEY (id_prodej, id_uzivatel);

ALTER TABLE administrator ADD CONSTRAINT fk_administrator_superuzivatel FOREIGN KEY (id_uzivatel) REFERENCES superuzivatel (id_uzivatel) ON DELETE CASCADE;

ALTER TABLE cena ADD CONSTRAINT fk_cena_hra FOREIGN KEY (id_hra) REFERENCES hra (id_hra) ON DELETE CASCADE;

ALTER TABLE hra ADD CONSTRAINT fk_hra_superuzivatel FOREIGN KEY (id_uzivatel) REFERENCES superuzivatel (id_uzivatel) ON DELETE CASCADE;
ALTER TABLE hra ADD CONSTRAINT fk_hra_vydavatel FOREIGN KEY (id_vydavatel) REFERENCES vydavatel (id_vydavatel) ON DELETE CASCADE;
ALTER TABLE hra ADD CONSTRAINT fk_hra_vyvojar FOREIGN KEY (vyvojar_id_uzivatel) REFERENCES vyvojar (id_uzivatel) ON DELETE CASCADE;
ALTER TABLE hra ADD CONSTRAINT fk_hra_zanr FOREIGN KEY (id_zanr) REFERENCES zanr (id_zanr) ON DELETE CASCADE;

ALTER TABLE kupec ADD CONSTRAINT fk_kupec_uzivatel FOREIGN KEY (id_uzivatel) REFERENCES uzivatel (id_uzivatel) ON DELETE CASCADE;

ALTER TABLE platebni_karta ADD CONSTRAINT fk_platebni_karta_prodej FOREIGN KEY (id_prodej) REFERENCES prodej (id_prodej) ON DELETE CASCADE;

ALTER TABLE pozice ADD CONSTRAINT fk_pozice_administrator FOREIGN KEY (id_uzivatel) REFERENCES administrator (id_uzivatel) ON DELETE CASCADE;

ALTER TABLE prodej ADD CONSTRAINT fk_prodej_hra FOREIGN KEY (id_hra) REFERENCES hra (id_hra) ON DELETE CASCADE;
ALTER TABLE prodej ADD CONSTRAINT fk_prodej_kupec FOREIGN KEY (id_uzivatel) REFERENCES kupec (id_uzivatel) ON DELETE CASCADE;

ALTER TABLE superuzivatel ADD CONSTRAINT fk_superuzivatel_uzivatel FOREIGN KEY (id_uzivatel) REFERENCES uzivatel (id_uzivatel) ON DELETE CASCADE;

ALTER TABLE vyvojar ADD CONSTRAINT fk_vyvojar_superuzivatel FOREIGN KEY (id_uzivatel) REFERENCES superuzivatel (id_uzivatel) ON DELETE CASCADE;

ALTER TABLE platebni_karta_kupec ADD CONSTRAINT fk_platebni_karta_kupec_platebn FOREIGN KEY (id_prodej) REFERENCES platebni_karta (id_prodej) ON DELETE CASCADE;
ALTER TABLE platebni_karta_kupec ADD CONSTRAINT fk_platebni_karta_kupec_kupec FOREIGN KEY (id_uzivatel) REFERENCES kupec (id_uzivatel) ON DELETE CASCADE;

