-- ===========================================================
-- 0. LIMPIEZA (Para asegurar que los IDs empiecen en 1)
-- ===========================================================
SET FOREIGN_KEY_CHECKS = 0; -- Desactiva validaciones temporalmente para borrar sin problemas
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS categorias;
SET FOREIGN_KEY_CHECKS = 1; -- Reactiva validaciones

-- ===========================================================
-- 1. TABLA: CATEGORIAS
-- ===========================================================
CREATE TABLE categorias (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(200) NULL,
    estado ENUM('Activa', 'Inactiva') DEFAULT 'Activa'
);

-- ===========================================================
-- 2. TABLA: PRODUCTOS
-- ===========================================================
CREATE TABLE productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    categoria_id INT NOT NULL, 
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    estado ENUM('Activo','Inactivo','Descontinuado') DEFAULT 'Activo',
    imagen_url VARCHAR(255) NULL,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_productos_categorias FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id)
);

-- ===========================================================
-- 3. INSERTAR CATEGORÍAS 
-- ===========================================================
INSERT INTO categorias (categoria_id, nombre, descripcion, estado) VALUES 
(1, 'Electrónica', 'Dispositivos móviles, computadoras y accesorios.', 'Activa'),      -- ID será 1
(2, 'Hogar y Cocina', 'Electrodomésticos y decoración para el hogar.', 'Activa'),      -- ID será 2
(3, 'Ropa Deportiva', 'Indumentaria para gimnasio y deportes al aire libre.', 'Activa'), -- ID será 3
(4, 'Juguetes Vintage', 'Juguetes de colección y temporadas pasadas.', 'Inactiva');    -- ID será 4

-- ===========================================================
-- 4. INSERTAR PRODUCTOS
-- ===========================================================
INSERT INTO productos (categoria_id, nombre, descripcion, precio, stock, estado, imagen_url) VALUES 
(1, 'Smartphone Galaxy X', 'Teléfono con 128GB de almacenamiento.', 8500.00, 45, 'Activo', 'https://img.ejemplo.com/galaxy-x.jpg'),
(1, 'Laptop Pro 15 pulgadas', 'Computadora portátil ideal para diseño.', 24500.50, 10, 'Activo', 'https://img.ejemplo.com/laptop-pro.jpg'),
(1, 'Mouse Inalámbrico', 'Mouse ergonómico con batería recargable.', 350.00, 0, 'Inactivo', NULL), 
(2, 'Cafetera Programable', 'Cafetera para 12 tazas.', 890.00, 25, 'Activo', 'https://img.ejemplo.com/cafetera.jpg'),
(2, 'Juego de Sartenes', 'Set de 3 sartenes antiadherentes.', 1200.00, 60, 'Activo', NULL),
(3, 'Camiseta Running', 'Camiseta transpirable talla M.', 299.90, 100, 'Activo', 'https://img.ejemplo.com/camiseta.jpg'),
(3, 'Tenis Deportivos', 'Calzado especial para alto impacto.', 1500.00, 15, 'Activo', 'https://img.ejemplo.com/tenis.jpg'),
(4, 'Figura de Acción Retro', 'Edición limitada del año 1999.', 4500.00, 2, 'Descontinuado', 'https://img.ejemplo.com/figura.jpg');

COMMIT;

-- ===========================================================
-- 5. CONSULTAS DE PRUEBA
-- ===========================================================
SELECT * FROM categorias; -- Verifica primero que esto tenga IDs 1, 2, 3, 4
SELECT * FROM productos;  -- Verifica que se hayan insertado
