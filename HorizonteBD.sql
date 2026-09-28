-- ============================================================
-- BASE DE DATOS: inmobiliaria_horizonte
-- ============================================================

DROP DATABASE IF EXISTS inmobiliaria_horizonte;

CREATE DATABASE inmobiliaria_horizonte;

USE inmobiliaria_horizonte;


-- ============================================================
-- TABLA: USUARIO
-- ============================================================

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE
);


-- ============================================================
-- TABLA: ADMINISTRADOR
-- ============================================================

CREATE TABLE administrador (
    id_usuario INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    DNI VARCHAR(20) NOT NULL,
    telefono VARCHAR(30),

    CONSTRAINT fk_administrador_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
);


-- ============================================================
-- TABLA: VENDEDOR
-- ============================================================

CREATE TABLE vendedor (
    id_usuario INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    DNI VARCHAR(20) NOT NULL,
    telefono VARCHAR(30),

    CONSTRAINT fk_vendedor_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
);


-- ============================================================
-- TABLA: PROPIETARIO
-- ============================================================

CREATE TABLE propietario (
    id_propietario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    DNI VARCHAR(20) NOT NULL,
    telefono VARCHAR(30),
    domicilio VARCHAR(30),
    ciudad VARCHAR(30)
);


-- ============================================================
-- TABLA: CLIENTE
-- ============================================================

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    DNI VARCHAR(20) NOT NULL,
    telefono VARCHAR(30),
    tipo_propiedad_buscada VARCHAR(50),
    tipo_operacion VARCHAR(100),
    ubicacion_buscada VARCHAR(50),
    presupuesto DECIMAL(12,2),

    id_vendedor INT,

    CONSTRAINT fk_cliente_vendedor
        FOREIGN KEY (id_vendedor)
        REFERENCES vendedor(id_usuario)
);


-- ============================================================
-- TABLA: PROPIEDAD
-- ============================================================

CREATE TABLE propiedad (
    id_propiedad INT AUTO_INCREMENT PRIMARY KEY,
    direccion VARCHAR(150) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    zona VARCHAR(100) NOT NULL,
    tipo_propiedad VARCHAR(30) NOT NULL,
    precio DECIMAL(12,2) NOT NULL,
    estado_propiedad VARCHAR(30) NOT NULL DEFAULT 'Disponible',
    habitaciones INT,
    baños INT,
    superficie DECIMAL(10,2),
    patio BOOLEAN DEFAULT FALSE,
    cochera BOOLEAN DEFAULT FALSE,

    id_propietario INT NOT NULL,
    id_vendedor INT,

    CONSTRAINT fk_propiedad_propietario
        FOREIGN KEY (id_propietario)
        REFERENCES propietario(id_propietario),

    CONSTRAINT fk_propiedad_vendedor
        FOREIGN KEY (id_vendedor)
        REFERENCES vendedor(id_usuario)
);


-- ============================================================
-- TABLA: FOTOGRAFIA
-- ============================================================

CREATE TABLE fotografia (
    id_fotografia INT AUTO_INCREMENT PRIMARY KEY,
    ruta VARCHAR(255) NOT NULL,
    descripcion VARCHAR(255),

    id_propiedad INT NOT NULL,

    CONSTRAINT fk_fotografia_propiedad
        FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad)
);


-- ============================================================
-- TABLA: OPERACION_INMOBILIARIA
-- ============================================================

CREATE TABLE operacion_inmobiliaria (
    id_operacion INT AUTO_INCREMENT PRIMARY KEY,
    tipo_operacion_inmobiliaria VARCHAR(20) NOT NULL,
    fecha DATE NOT NULL,
    precio DECIMAL(12,2) NOT NULL,
    estado_operacion VARCHAR(20) NOT NULL DEFAULT 'Activa',

    id_propiedad INT NOT NULL,
    id_cliente INT NOT NULL,
    id_vendedor INT NOT NULL,

    CONSTRAINT fk_operacion_propiedad
        FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad),

    CONSTRAINT fk_operacion_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),

    CONSTRAINT fk_operacion_vendedor
        FOREIGN KEY (id_vendedor)
        REFERENCES vendedor(id_usuario)
);

-- ============================================================
-- INSERCIÓN DE VALORES
-- ============================================================

INSERT INTO usuario
    (nombre_usuario, contrasena, activo)
VALUES
    ('admin', 'admin123', TRUE),
    ('juan', 'juan123', TRUE),
    ('maria', 'maria123', TRUE);

INSERT INTO administrador
    (id_usuario, nombre, apellido, DNI, telefono)
VALUES
    (1, 'Carlos', 'Gomez', '30123456', '3435000001');

INSERT INTO vendedor
    (id_usuario, nombre, apellido, DNI, telefono)
VALUES
    (2, 'Juan', 'Perez', '32123456', '3435000002'),
    (3, 'Maria', 'Lopez', '33123456', '3435000003');

INSERT INTO propietario
    (nombre, apellido, DNI, telefono, domicilio, ciudad)
VALUES
    ('Roberto', 'Martinez', '27123456',
     '3435000010', 'Belgrano 125', 'Crespo'),

    ('Laura', 'Fernandez', '28123456',
     '3435000011', 'San Martin 845', 'Crespo'),

    ('Daniel', 'Gonzalez', '29123456',
     '3435000012', 'Entre Rios 430', 'Crespo');

INSERT INTO cliente
    (nombre, apellido, DNI, telefono,
     tipo_propiedad_buscada, tipo_operacion,
     ubicacion_buscada, presupuesto, id_vendedor)
VALUES
    ('Pedro', 'Rodriguez', '34123456',
     '3435000020', 'Casa', 'Compra',
     'Crespo', 85000000, 2),

    ('Ana', 'Sanchez', '35123456',
     '3435000021', 'Departamento', 'Alquiler',
     'Crespo', 55000000, 3),

    ('Lucia', 'Ramirez', '36123456',
     '3435000022', 'Casa', 'Compra',
     'Crespo', 70000000, 2);

INSERT INTO propiedad
    (direccion, ciudad, zona, tipo_propiedad, precio,
     estado_propiedad, habitaciones, baños, superficie,
     patio, cochera, id_propietario, id_vendedor)
VALUES

    ('Av. Belgrano 1250', 'Crespo', 'Centro', 'Casa',
     80000000, 'Disponible',
     3, 2, 180.00, TRUE, TRUE,
     1, 2),

    ('San Martin 845', 'Crespo', 'Centro', 'Departamento',
     52000000, 'Disponible',
     2, 1, 95.00, FALSE, TRUE,
     2, 3),

    ('Entre Rios 430', 'Crespo', 'Sur', 'Casa',
     65000000, 'Disponible',
     3, 2, 140.00, TRUE, TRUE,
     3, 2),

    ('Sarmiento 1120', 'Crespo', 'Norte', 'Casa',
     45000000, 'Disponible',
     2, 1, 80.00, TRUE, FALSE,
     1, NULL);

INSERT INTO fotografia
    (ruta, descripcion, id_propiedad)
VALUES
    ('fotos/propiedad1_frente.jpg',
     'Vista frontal de la propiedad',
     1),

    ('fotos/propiedad1_living.jpg',
     'Living de la propiedad',
     1),

    ('fotos/propiedad1_cocina.jpg',
     'Cocina de la propiedad',
     1),

    ('fotos/propiedad2_frente.jpg',
     'Vista frontal de la propiedad',
     2),

    ('fotos/propiedad3_frente.jpg',
     'Vista frontal de la propiedad',
     3);

INSERT INTO operacion_inmobiliaria
    (tipo_operacion_inmobiliaria, fecha, precio,
     estado_operacion, id_propiedad, id_cliente, id_vendedor)
VALUES
    ('Alquiler', '2026-09-20', 500000,
     'Activa', 2, 2, 3);

UPDATE propiedad
SET estado_propiedad = 'Alquilada'
WHERE id_propiedad = 2;


-- ============================================================
-- CONSULTAS DE COMPROBACION
-- ============================================================

SELECT * FROM usuario;

SELECT * FROM administrador;

SELECT * FROM vendedor;

SELECT * FROM propietario;

SELECT * FROM cliente;

SELECT * FROM propiedad;

SELECT * FROM fotografia;

SELECT * FROM operacion_inmobiliaria;