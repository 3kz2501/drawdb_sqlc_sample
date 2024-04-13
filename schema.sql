CREATE TABLE "users" (
	"id" uuid NOT NULL,
	"name" varchar(255) NOT NULL,
	"email" varchar(255) NOT NULL CHECK("email" ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$'),
	"created_at" TIMESTAMPTZ NOT NULL,
	"updated_at" TIMESTAMPTZ,
	PRIMARY KEY("id")
);

CREATE TABLE "profiles" (
	"id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"profile" text(65535),
	"name" varchar(255) NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL,
	"updated_at" TIMESTAMPTZ,
	PRIMARY KEY("id")
);

CREATE INDEX "user_id_name_index"
ON "profiles" ("user_id", "name");
CREATE TABLE "todos" (
	"id" uuid NOT NULL,
	"title" varchar(255) NOT NULL,
	"note" text(65535),
	"user_id" uuid NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL,
	"updated_at" TIMESTAMPTZ,
	"parent_id" uuid,
	"expired_at" TIMESTAMPTZ,
	"priority" smallint,
	PRIMARY KEY("id")
);

CREATE INDEX "user_id_index"
ON "todos" ("user_id");
CREATE TABLE "slack_collaborations" (
	"id" uuid NOT NULL,
	"slack_user_id" varchar(255) NOT NULL,
	"slack_team_id" varchar(255) NOT NULL,
	"refresh_token" varchar(255) NOT NULL,
	"user_id" uuid NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL,
	"updated_at" TIMESTAMPTZ,
	PRIMARY KEY("id")
);

CREATE INDEX "user_id_slack_user_id_index"
ON "slack_collaborations" ("user_id", "slack_user_id");
CREATE TABLE "google_calender_collaborations" (
	"id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"google_usre_id" varchar(255) NOT NULL,
	"refresh_token" varchar(255) NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL,
	"updated_at" TIMESTAMPTZ,
	PRIMARY KEY("id")
);

CREATE INDEX "user_id_index"
ON "google_calender_collaborations" ("user_id");
CREATE TABLE "teams" (
	"id" uuid NOT NULL,
	"name" varchar(255) NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL,
	"updated_at" TIMESTAMPTZ,
	"organization_id" uuid NOT NULL,
	PRIMARY KEY("id")
);

CREATE INDEX "organization_id_index"
ON "teams" ("organization_id");
CREATE TABLE "organizations" (
	"id" uuid NOT NULL,
	"name" varchar(255) NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL,
	"updated_at" TIMESTAMPTZ,
	PRIMARY KEY("id")
);

CREATE TABLE "team_users" (
	"id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"team_id" uuid NOT NULL,
	PRIMARY KEY("id"),
    UNIQUE("user_id", "team_id")
);

ALTER TABLE "users"
ADD FOREIGN KEY("id") REFERENCES "profiles"("user_id")
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "users"
ADD FOREIGN KEY("id") REFERENCES "todos"("user_id")
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "users"
ADD FOREIGN KEY("id") REFERENCES "slack_collaborations"("user_id")
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "users"
ADD FOREIGN KEY("id") REFERENCES "google_calender_collaborations"("user_id")
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "organizations"
ADD FOREIGN KEY("id") REFERENCES "teams"("organization_id")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "team_users"
ADD FOREIGN KEY("team_id") REFERENCES "teams"("id")
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "users"
ADD FOREIGN KEY("id") REFERENCES "team_users"("user_id")
ON UPDATE CASCADE ON DELETE CASCADE;
