BEGIN TRANSACTION;

create table categories (
    id INTEGER,
    category_name text UNIQUE NOT NULL,
    description text NOT NULL,
    PRIMARY KEY (id)
);

create table packages (
    id INTEGER,
    category_id INTEGER NOT NULL,
    package_name text NOT NULL,
    description text NOT NULL,
    homepage text NOT NULL,
    CONSTRAINT idx1_unq UNIQUE (category_id, package_name),
    FOREIGN KEY (category_id) REFERENCES categories(id),
    PRIMARY KEY (id)
);

create table persons (
    id INTEGER,
    name text,
    email text UNIQUE NOT NULL,
    nickname text UNIQUE,
    CONSTRAINT idx1_unq UNIQUE (name, email, nickname),
    PRIMARY KEY (id)
);

create table roles (
    id INTEGER,
    role text UNIQUE NOT NULL,
    PRIMARY KEY (id)
);

create table persons2roles (
    id INTEGER,
    person_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    FOREIGN KEY (person_id) REFERENCES persons(id),
    FOREIGN KEY (role_id) REFERENCES roles(id),
    CONSTRAINT idx1_unq UNIQUE (person_id, role_id),
    PRIMARY KEY (id)
);

create table person_roles2packages (
    id INTEGER,
    package_id INTEGER NOT NULL,
    persons_role_id INTEGER NOT NULL,
    FOREIGN KEY (persons_role_id) REFERENCES persons2roles(id),
    FOREIGN KEY (package_id) REFERENCES packages(id),
    CONSTRAINT idx1_unq UNIQUE (package_id, persons_role_id),
    PRIMARY KEY (id)
);

create table ebuilds (
    id INTEGER,
    package_id INTEGER NOT NULL,
    version text NOT NULL,
    license text NOT NULL,
    mtime text NOT NULL,
    mauthor text NOT NULL,
    eapi_id INTEGER NOT NULL,
    slot text NOT NULL,
    FOREIGN KEY (package_id) REFERENCES packages(id),
    FOREIGN KEY (eapi_id) REFERENCES eapis(id),
    -- keyword_id text NOT NULL,
    -- architecture text NOT NULL,
    -- flags?
    -- enabled flags?
    -- depend
    -- rdepend
    -- overlay?
    -- inherit
    PRIMARY KEY (id)
    -- sha1/md5 INTEGER NOT NULL
    -- size of dwonloads?
    -- data blob /*NOT NULL*/,
);
CREATE UNIQUE INDEX idx1_unq
ON ebuilds(package_id, version);

create table eapis (
    id INTEGER,
    eapi_version INTEGER UNIQUE NOT NULL,
    PRIMARY KEY (id)
);

create table all_use_flags (
    id INTEGER,
    flag_name text UNIQUE NOT NULL,
    flag_description text UNIQUE NOT NULL,
    PRIMARY KEY (id)
);

create table use_flags_states (
    id INTEGER,
    flag_state text UNIQUE NOT NULL,
    PRIMARY KEY (id)
);

create table profile_use_flags (
    id INTEGER,
    use_flag_id INTEGER NOT NULL,
    flag_state_id INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (use_flag_id) REFERENCES all_use_flags(id),
    FOREIGN KEY (flag_state_id) REFERENCES use_flags_states(id),
    CONSTRAINT idx1_unq UNIQUE (use_flag_id, flag_state_id),
    PRIMARY KEY (id)
);

create table system_use_flags (
    id INTEGER,
    use_flag_id INTEGER NOT NULL,
    flag_state_id INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (use_flag_id) REFERENCES all_use_flags(id),
    FOREIGN KEY (flag_state_id) REFERENCES use_flags_states(id),
    CONSTRAINT idx1_unq UNIQUE (use_flag_id, flag_state_id),
    PRIMARY KEY (id)
);

create table users_use_flags2packages (
    id INTEGER,
    use_flag_id INTEGER NOT NULL,
    package_id INTEGER NOT NULL,
    flag_state_id INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (package_id) REFERENCES packages(id),
    FOREIGN KEY (use_flag_id) REFERENCES all_use_flags(id),
    FOREIGN KEY (flag_state_id) REFERENCES use_flags_states(id),
    CONSTRAINT idx1_unq UNIQUE (use_flag_id, flag_state_id, package_id),
    PRIMARY KEY (id)
);

create table users_use_flags2ebuilds (
    id INTEGER,
    use_flag_id INTEGER NOT NULL,
    ebuild_id INTEGER NOT NULL,
    flag_state_id INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (ebuild_id) REFERENCES ebuilds(id),
    FOREIGN KEY (use_flag_id) REFERENCES all_use_flags(id),
    FOREIGN KEY (flag_state_id) REFERENCES use_flags_states(id),
    CONSTRAINT idx1_unq UNIQUE (use_flag_id, flag_state_id, ebuild_id),
    PRIMARY KEY (id)
);

create table architectures (
    id INTEGER PRIMARY KEY,
    architecture text UNIQUE NOT NULL
    -- smth else?
);

create table ebuilds2architectures (
    id INTEGER PRIMARY KEY,
    ebuild_id INTEGER NOT NULL,
    architecture_id INTEGER NOT NULL
);

create table keywords (
    id INTEGER PRIMARY KEY,
    keyword text UNIQUE NOT NULL/*,
    keyword_description text NOT NULL*/
);

create table keywords2architectures (
    id INTEGER PRIMARY KEY,
    ebuild_architecture_id INTEGER NOT NULL,
    keyword_id INTEGER NOT NULL
);

create table licences (
    id INTEGER PRIMARY KEY,
    license_name text NOT NULL
    -- url text ?,
    -- content blob /*zipped data*/ ?
);

create table licences2packages (
    id INTEGER PRIMARY KEY,
    license_id INTEGER NOT NULL,
    package_id INTEGER NOT NULL
);

create table licences2ebuilds (
    id INTEGER PRIMARY KEY,
    license_id INTEGER NOT NULL,
    ebuild_id INTEGER NOT NULL
);

create table sets (
    id INTEGER PRIMARY KEY,
    set_name text NOT NULL
);

create table sets_content (
    id INTEGER PRIMARY KEY,
    set_id text INTEGER NOT NULL,
    package_id text INTEGER NOT NULL
);

COMMIT;
