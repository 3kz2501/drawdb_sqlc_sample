-- name: GetUser :one
SELECT * FROM users
WHERE id = $1 LIMIT 1;

-- name: ListUsers :many
SELECT * FROM users
ORDER BY name;

-- name: CreateUser :one
BEGIN transaction;
WITH new_user AS (
  INSERT INTO users (name, email, created_at)
  VALUES ($1, $2, NOW())
  RETURNING id
)
INSERT INTO profiles (user_id, profile, name, created_at)
SELECT id, $3, $4, NOW() FROM new_user;
COMMIT transaction;

-- name: CreateTodo :one
INSERT INTO todos (title, note, user_id, priority, expired_at, created_at)
VALUES ($1, $2, $3, $4, $5, NOW())
RETURNING *;

-- name: UpdateTodo :one
UPDATE todos SET title=$1, note=$2, priority=$3, expired_at=$4, updated_at=NOW()
WHERE user_id = $5
RETURNING *;

-- name: DeleteUser :one
DELETE FROM users
WHERE id = $1
RETURNING *;

-- name: CreateTeam :one
INSERT INTO teams (name, created_at, organization_id)
VALUEs ($1, NOW(), $2)
RETURNING *;

-- name: RelationTeamUser :one
CREATE OR REPLACE FUNCTION insert_team_user(_user_id uuid, _team_id uuid)
RETURNS VOID AS $$
BEGIN
    -- Check if the user exists
    IF NOT EXISTS (SELECT 1 FROM users WHERE id = _user_id) THEN
        RAISE EXCEPTION 'User with ID % does not exist', _user_id;
    END IF;

    -- Check if the team exists
    IF NOT EXISTS (SELECT 1 FROM teams WHERE id = _team_id) THEN
        RAISE EXCEPTION 'Team with ID % does not exist', _team_id;
    END IF;

    -- Insert into the team_users table
    INSERT INTO team_users (user_id, team_id) 
    VALUES (_user_id, _team_id);
END;
$$ LANGUAGE plpgsql;
