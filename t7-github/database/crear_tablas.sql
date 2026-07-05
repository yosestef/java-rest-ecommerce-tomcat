-- ============================================
-- SCRIPT DE BASE DE DATOS - TAREA 7
-- Sistema de Comercio Electrónico
-- Yoselyn Estefany Reyes Ruiz - 2023630858
-- ============================================

-- Crear base de datos si no existe
CREATE DATABASE IF NOT EXISTS servicio_web;
USE servicio_web;

-- ============================================
-- TABLA: usuarios
-- ============================================
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(64) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100),
    fecha_nacimiento DATETIME NOT NULL,
    telefono BIGINT,
    genero CHAR(1),
    token VARCHAR(20),
    INDEX idx_email (email),
    INDEX idx_token (token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: fotos_usuarios
-- ============================================
CREATE TABLE IF NOT EXISTS fotos_usuarios (
    id_foto INT AUTO_INCREMENT PRIMARY KEY,
    foto LONGBLOB NOT NULL,
    id_usuario INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    INDEX idx_usuario (id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: stock (artículos disponibles)
-- ============================================
CREATE TABLE IF NOT EXISTS stock (
    id_articulo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    cantidad INT NOT NULL DEFAULT 0,
    id_usuario INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_nombre (nombre),
    INDEX idx_usuario (id_usuario),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    CHECK (precio > 0),
    CHECK (cantidad >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: fotos_articulos
-- ============================================
CREATE TABLE IF NOT EXISTS fotos_articulos (
    id_foto INT AUTO_INCREMENT PRIMARY KEY,
    fotografia LONGBLOB NOT NULL,
    id_articulo INT NOT NULL,
    FOREIGN KEY (id_articulo) REFERENCES stock(id_articulo) ON DELETE CASCADE,
    INDEX idx_articulo (id_articulo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: carrito_compra
-- ============================================
CREATE TABLE IF NOT EXISTS carrito_compra (
    id_usuario INT NOT NULL,
    id_articulo INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_articulo),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_articulo) REFERENCES stock(id_articulo) ON DELETE CASCADE,
    UNIQUE INDEX idx_usuario_articulo (id_usuario, id_articulo),
    CHECK (cantidad > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- DATOS DE PRUEBA (OPCIONAL)
-- ============================================

-- Insertar usuario de prueba
-- Password: test123 (debes cambiarlo por el hash real si lo usas)
INSERT IGNORE INTO usuarios 
    (email, password, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, telefono, genero)
VALUES 
    ('yose@escom.ipn.mx', 'test123', 'Yoselyn', 'Reyes', 'Ruiz', '2000-01-01 00:00:00', 5512345678, 'M');

-- Obtener ID del usuario de prueba
SET @id_usuario_prueba = (SELECT id_usuario FROM usuarios WHERE email = 'yose@escom.ipn.mx');

-- Insertar artículos de prueba
INSERT IGNORE INTO stock 
    (nombre, descripcion, precio, cantidad, id_usuario)
VALUES 
    ('Laptop Gaming Pro', 'Laptop de alto rendimiento con GPU RTX 4070', 25999.00, 15, @id_usuario_prueba),
    ('Mouse Inalámbrico', 'Mouse ergonómico con 6 botones programables', 499.00, 50, @id_usuario_prueba),
    ('Teclado Mecánico RGB', 'Teclado mecánico con switches azules', 1299.00, 30, @id_usuario_prueba),
    ('Monitor 27" 4K', 'Monitor profesional con panel IPS', 8999.00, 10, @id_usuario_prueba),
    ('Audífonos Bluetooth', 'Audífonos con cancelación de ruido activa', 2499.00, 25, @id_usuario_prueba);

-- ============================================
-- MOSTRAR INFORMACIÓN DE LAS TABLAS
-- ============================================

SELECT '============================================' AS '';
SELECT 'TABLAS CREADAS EXITOSAMENTE' AS '';
SELECT '============================================' AS '';

SHOW TABLES;

SELECT '============================================' AS '';
SELECT 'ESTRUCTURA DE TABLA: usuarios' AS '';
SELECT '============================================' AS '';
DESCRIBE usuarios;

SELECT '============================================' AS '';
SELECT 'ESTRUCTURA DE TABLA: stock' AS '';
SELECT '============================================' AS '';
DESCRIBE stock;

SELECT '============================================' AS '';
SELECT 'ESTRUCTURA DE TABLA: carrito_compra' AS '';
SELECT '============================================' AS '';
DESCRIBE carrito_compra;

SELECT '============================================' AS '';
SELECT 'DATOS DE PRUEBA INSERTADOS' AS '';
SELECT '============================================' AS '';

SELECT COUNT(*) AS total_usuarios FROM usuarios;
SELECT COUNT(*) AS total_articulos FROM stock;

SELECT '============================================' AS '';
SELECT 'ARTÍCULOS DISPONIBLES:' AS '';
SELECT '============================================' AS '';

SELECT 
    id_articulo, 
    nombre, 
    precio, 
    cantidad 
FROM stock 
ORDER BY id_articulo;
