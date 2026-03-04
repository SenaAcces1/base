CREATE DATABASE IF NOT EXISTS sena_access;
USE sena_access;

-- 1. Tabla de Roles (Catálogo)
-- Un usuario tendrá asignado el ID de esta tabla.
CREATE TABLE rol (
    id_rol INT(11) PRIMARY KEY AUTO_INCREMENT,
    rol_name VARCHAR(20) NOT NULL
);

-- 2. Tabla de Usuarios (Núcleo)
-- Aquí centralizamos la relación: un id_rol por cada fila de usuario.
CREATE TABLE users (
    id_user INT(11) PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(50) NOT NULL,
    user_secondname VARCHAR(50),
    user_lastname VARCHAR(50) NOT NULL,
    user_secondlastname VARCHAR(50),
    user_coursenumber INT(11),
    user_program VARCHAR(50),
    user_email VARCHAR(50) UNIQUE,
    user_password VARCHAR(255) NOT NULL, -- Longitud adecuada para Hash (Bcrypt/Argon2)
    id_rol INT(11),
    CONSTRAINT fk_user_rol FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
);

-- 3. Tabla de Huellas
CREATE TABLE fingerprints_users (
    id_fingerprints INT(11) PRIMARY KEY AUTO_INCREMENT,
    r_fingerprint MEDIUMBLOB,
    l_fingerprint MEDIUMBLOB,
    id_user INT(11),
    CONSTRAINT fk_fingerprint_user FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE CASCADE
);

-- 4. Recuperación de Contraseñas
CREATE TABLE token_recovery (
    id_token INT(11) PRIMARY KEY AUTO_INCREMENT,
    id_user INT(11),
    token_code INT(10),
    token_exp DATETIME,
    token_used TINYINT(1) DEFAULT 0,
    CONSTRAINT fk_token_user FOREIGN KEY (id_user) REFERENCES users(id_user)
);

-- 5. Control de Ingresos
-- Eliminamos tabla intermedia: id_user va directo aquí.
CREATE TABLE reporte_ingresos (
    id_ingreso INT(11) PRIMARY KEY AUTO_INCREMENT,
    ingreso_datetime DATETIME DEFAULT CURRENT_TIMESTAMP,
    ingreso_place VARCHAR(50),
    id_user INT(11),
    CONSTRAINT fk_ingreso_user FOREIGN KEY (id_user) REFERENCES users(id_user)
);

-- 6. Reportes de Instructor
CREATE TABLE reportes_instructor (
    id_reporte_instructor INT(11) PRIMARY KEY AUTO_INCREMENT,
    reporte_instructor_head VARCHAR(50),
    reporte_instructor_body VARCHAR(150),
    reporte_instructor_datetime DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_user INT(11),
    CONSTRAINT fk_reporte_instr_user FOREIGN KEY (id_user) REFERENCES users(id_user)
);

-- 7. Reporte de Novedades
CREATE TABLE reporte_novedades (
    id_novedad INT(11) PRIMARY KEY AUTO_INCREMENT,
    novedad_title VARCHAR(50),
    novedad_body VARCHAR(100),
    novedad_fechayhora DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_user INT(11),
    CONSTRAINT fk_novedad_user FOREIGN KEY (id_user) REFERENCES users(id_user)
);

CREATE TABLE ingresos_user (
  id_user INT(11) NOT NULL,
  id_ingresos INT(11) NOT NULL,
  PRIMARY KEY (id_user, id_ingresos),
  CONSTRAINT fk_ingresos_user__users_id_user FOREIGN KEY (id_user) REFERENCES users(id_user),
  CONSTRAINT fk_ingresos_user__reporte_ingresos_id_ingreso FOREIGN KEY (id_ingresos) REFERENCES reporte_ingresos(id_ingreso)
);
CREATE TABLE reportes_user_instructor (
    id_reporte_instructor INT(11),
    id_user INT(11),
    PRIMARY KEY (id_reporte_instructor, id_user),
    CONSTRAINT fk_reporte_instructor FOREIGN KEY (id_reporte_instructor) REFERENCES reportes_instructor(id_reporte_instructor),
    CONSTRAINT fk_reporte_user FOREIGN KEY (id_user) REFERENCES users(id_user)
);
CREATE TABLE novedades_user (
  id_novedad INT(11) NOT NULL,
  id_user INT(11) NOT NULL,
  PRIMARY KEY (id_novedad, id_user),
  CONSTRAINT fk_novedades_user__reporte_novedades_id_novedad FOREIGN KEY (id_novedad) REFERENCES reporte_novedades(id_novedad),
  CONSTRAINT fk_novedades_user__users_id_user FOREIGN KEY (id_user) REFERENCES users(id_user)
);