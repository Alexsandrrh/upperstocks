CREATE SCHEMA "accounting";

CREATE SCHEMA "crypto";

CREATE SCHEMA "auth";

CREATE TYPE "accounting"."accountType" AS ENUM (
  'master'
);

CREATE TYPE "accounting"."transactionState" AS ENUM (
  'pending',
  'processing',
  'completed',
  'canceled',
  'failed'
);

CREATE TABLE "accounting"."account" (
  "id" uuid PRIMARY KEY,
  "type" accounting.accountType,
  "userId" uuid
);

CREATE TABLE "accounting"."accountCoin" (
  "coinId" varchar(255),
  "accountId" uuid,
  "balance" integer DEFAULT 0
);

CREATE TABLE "accounting"."transaction" (
  "id" uuid PRIMARY KEY,
  "state" accounting.transactionState DEFAULT 'pending',
  "amount" integer DEFAULT 0,
  "incomeAccountId" uuid,
  "incomeWalletId" uuid,
  "outcomeAccountId" uuid,
  "outcomeWalletId" uuid,
  "coinId" varchar,
  "createdAt" datetime NOT NULL,
  "updatedAt" datetime NOT NULL
);

CREATE TABLE "crypto"."contract" (
  "address" varchar,
  "networkId" varchar,
  "coinId" varchar,
  PRIMARY KEY ("networkId", "coinId")
);

CREATE TABLE "crypto"."coin" (
  "id" varchar(255) PRIMARY KEY,
  "name" varchar(255),
  "symbol" varchar(255),
  "image" varchar
);

CREATE TABLE "crypto"."network" (
  "id" varchar PRIMARY KEY,
  "name" varchar,
  "shortName" varchar
);

CREATE TABLE "crypto"."wallet" (
  "id" uuid PRIMARY KEY,
  "address" varchar,
  "encryptedPrivateKey" varchar,
  "balance" integer DEFAULT 0,
  "coinId" varchar,
  "networkId" varchar,
  "userId" uuid,
  "createdAt" datetime NOT NULL,
  "updatedAt" datetime NOT NULL
);

CREATE TABLE "auth"."user" (
  "id" uuid PRIMARY KEY,
  "userName" varchar(255) UNIQUE NOT NULL,
  "familyName" varchar(255) NOT NULL,
  "givenName" varchar(255) NOT NULL,
  "middleName" varchar(255),
  "email" varchar(255) UNIQUE NOT NULL,
  "emailIsVerified" bool DEFAULT false,
  "encryptedPassword" varchar(255) NOT NULL,
  "registredAt" datetime NOT NULL,
  "updatedAt" datetime NOT NULL
);

CREATE UNIQUE INDEX ON "crypto"."wallet" ("address", "coinId", "networkId");

COMMENT ON TABLE "crypto"."contract" IS 'Контракт';

COMMENT ON COLUMN "crypto"."contract"."address" IS 'Адрес';

COMMENT ON COLUMN "crypto"."contract"."networkId" IS 'Идентификатор сети';

COMMENT ON COLUMN "crypto"."contract"."coinId" IS 'Идентификатор монеты';

COMMENT ON TABLE "crypto"."coin" IS 'Монета';

COMMENT ON COLUMN "crypto"."coin"."id" IS 'Идентификатор';

COMMENT ON COLUMN "crypto"."coin"."name" IS 'Наименование';

COMMENT ON COLUMN "crypto"."coin"."symbol" IS 'Символ';

COMMENT ON COLUMN "crypto"."coin"."image" IS 'Изображение';

COMMENT ON TABLE "crypto"."network" IS 'Сеть';

COMMENT ON COLUMN "crypto"."network"."id" IS 'Идентификатор';

COMMENT ON COLUMN "crypto"."network"."name" IS 'Наименование';

COMMENT ON COLUMN "crypto"."network"."shortName" IS 'Сокращенное наименование';

COMMENT ON TABLE "crypto"."wallet" IS 'Кошелек';

COMMENT ON COLUMN "crypto"."wallet"."id" IS 'Идентфикатор';

COMMENT ON COLUMN "crypto"."wallet"."encryptedPrivateKey" IS 'Зашифрованный приватный ключ от кошелька';

COMMENT ON COLUMN "auth"."user"."emailIsVerified" IS 'Флаг подтвержденной электронной почты';

COMMENT ON COLUMN "auth"."user"."encryptedPassword" IS 'Зашифрованный пароль';

ALTER TABLE "crypto"."contract" ADD FOREIGN KEY ("networkId") REFERENCES "crypto"."network" ("id");

ALTER TABLE "crypto"."contract" ADD FOREIGN KEY ("coinId") REFERENCES "crypto"."coin" ("id");

ALTER TABLE "crypto"."wallet" ADD FOREIGN KEY ("coinId") REFERENCES "crypto"."coin" ("id");

ALTER TABLE "crypto"."wallet" ADD FOREIGN KEY ("networkId") REFERENCES "crypto"."network" ("id");

ALTER TABLE "crypto"."wallet" ADD FOREIGN KEY ("userId") REFERENCES "auth"."user" ("id");

ALTER TABLE "accounting"."account" ADD FOREIGN KEY ("userId") REFERENCES "auth"."user" ("id");

ALTER TABLE "accounting"."accountCoin" ADD FOREIGN KEY ("coinId") REFERENCES "crypto"."coin" ("id");

ALTER TABLE "accounting"."accountCoin" ADD FOREIGN KEY ("accountId") REFERENCES "accounting"."account" ("id");

ALTER TABLE "accounting"."transaction" ADD FOREIGN KEY ("incomeAccountId") REFERENCES "accounting"."account" ("id");

ALTER TABLE "accounting"."transaction" ADD FOREIGN KEY ("incomeWalletId") REFERENCES "crypto"."wallet" ("id");

ALTER TABLE "accounting"."transaction" ADD FOREIGN KEY ("outcomeAccountId") REFERENCES "accounting"."account" ("id");

ALTER TABLE "accounting"."transaction" ADD FOREIGN KEY ("outcomeWalletId") REFERENCES "crypto"."wallet" ("id");

ALTER TABLE "accounting"."transaction" ADD FOREIGN KEY ("coinId") REFERENCES "crypto"."coin" ("id");
