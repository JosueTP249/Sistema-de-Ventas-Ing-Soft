CREATE DATABASE IF NOT EXISTS sistema_ventas CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE sistema_ventas;

-- ===========================================================
-- 1. TABLA: ROLES
-- ===========================================================
CREATE TABLE roles (
    rol_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR(20) NOT NULL UNIQUE,
    descripcion VARCHAR(100) NULL,
    permisos JSON NULL
);

-- ===========================================================
-- 2. TABLA: USUARIOS
-- ===========================================================
CREATE TABLE usuarios (
    usuario_id INT AUTO_INCREMENT PRIMARY KEY,
    rol_id INT NOT NULL,
    trabajador_id VARCHAR(20) NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50) NULL,
    password_hash VARCHAR(255) NOT NULL,
    estado ENUM('Activo','Inactivo','Desactivado','Bloqueado') NOT NULL DEFAULT 'Activo',
    intentos_fallidos INT DEFAULT 0,
    fecha_bloqueo INT NULL,
    email_verificado BOOLEAN DEFAULT FALSE,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuarios_roles FOREIGN KEY (rol_id) REFERENCES roles(rol_id)
);

-- ===========================================================
-- 3. TABLA: CATEGORIAS (Nueva tabla agregada)
-- ===========================================================
CREATE TABLE categorias (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(200) NULL,
    estado ENUM('Activa', 'Inactiva') DEFAULT 'Activa'
);

-- ===========================================================
-- 4. TABLA: PRODUCTOS (Corregida)
-- ===========================================================
CREATE TABLE productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    categoria_id INT NOT NULL, -- Campo agregado para la relación
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
-- 5. TABLA: DIRECCIONES
-- ===========================================================
CREATE TABLE direcciones (
    direccion_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    calle VARCHAR(100) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    codigo_postal VARCHAR(10) NOT NULL,
    pais VARCHAR(50) DEFAULT 'México',
    es_principal BOOLEAN DEFAULT FALSE,
    activo BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_direcciones_usuarios FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
);

-- ===========================================================
-- 6. TABLA: MÉTODOS DE PAGO
-- ===========================================================
CREATE TABLE metodos_pago (
    pago_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    token_tarjeta VARCHAR(100) NOT NULL UNIQUE,
    ultimos_digitos VARCHAR(4) NOT NULL,
    fecha_vencimiento INT NOT NULL,
    tipo_tarjeta VARCHAR(20) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_metodospago_usuarios FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
);

-- ===========================================================
-- 7. TABLA: PEDIDOS
-- ===========================================================
CREATE TABLE pedidos (
    pedido_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    fecha_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('Pendiente','Enviado','Entregado','Cancelado') DEFAULT 'Pendiente',
    total DECIMAL(10,2) NOT NULL,
    direccion_envio_id INT NOT NULL,
    fecha_estimada_entrega DATE NULL,
    metodo_pago_id INT NOT NULL,
    CONSTRAINT fk_pedidos_usuarios FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id),
    CONSTRAINT fk_pedidos_direcciones FOREIGN KEY (direccion_envio_id) REFERENCES direcciones(direccion_id),
    CONSTRAINT fk_pedidos_metodos FOREIGN KEY (metodo_pago_id) REFERENCES metodos_pago(pago_id)
);

-- ===========================================================
-- 8. TABLA: DETALLE_PEDIDOS
-- ===========================================================
CREATE TABLE detalle_pedidos (
    detalle_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detalle_pedidos FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id),
    CONSTRAINT fk_detalle_productos FOREIGN KEY (producto_id) REFERENCES productos(producto_id)
);

-- ===========================================================
-- 9. TABLA: COMENTARIOS_CALIFICACIONES
-- ===========================================================
CREATE TABLE comentarios_calificaciones (
    comentario_id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    usuario_id INT NOT NULL,
    calificacion INT NOT NULL CHECK (calificacion BETWEEN 1 AND 5),
    comentario TEXT NULL,
    estado ENUM('Pendiente','Aprobado','Rechazado') DEFAULT 'Pendiente',
    fecha_creacion INT NOT NULL,
    fecha_moderacion INT NULL,
    CONSTRAINT fk_comentario_producto FOREIGN KEY (producto_id) REFERENCES productos(producto_id),
    CONSTRAINT fk_comentario_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
);

-- ===========================================================
-- 10. TABLA: DEVOLUCIONES
-- ===========================================================
CREATE TABLE devoluciones (
    devolucion_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    usuario_id INT NOT NULL,
    motivo TEXT NOT NULL,
    cantidad INT NOT NULL,
    estado ENUM('Solicitada','Aprobada','Rechazada','Completada') DEFAULT 'Solicitada',
    fecha_solicitud DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_resolucion DATETIME NULL,
    evidencia_url VARCHAR(255) NULL,
    CONSTRAINT fk_devoluciones_pedidos FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id),
    CONSTRAINT fk_devoluciones_usuarios FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
);

-- ===========================================================
-- 11. TABLA: AUDITORIA
-- ===========================================================
CREATE TABLE auditoria (
    auditoria_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NULL,
    accion VARCHAR(100) NOT NULL,
    tabla_afectada VARCHAR(50) NOT NULL,
    registro_id INT NULL,
    fecha_accion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ip_usuario VARCHAR(45) NULL,
    user_agent VARCHAR(255) NULL,
    CONSTRAINT fk_auditoria_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
);

-- ===========================================================
-- 12. TABLA: TICKETS
-- ===========================================================
CREATE TABLE tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    codigo_ticket VARCHAR(50) NOT NULL UNIQUE,
    qr_code VARCHAR(255) NULL,
    pdf_url VARCHAR(255) NOT NULL,
    fecha_emision INT NOT NULL,
    fecha_vencimiento INT NOT NULL,
    CONSTRAINT fk_tickets_pedido FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id)
);

-- ===========================================================
-- 13. TABLA: NOTIFICACIONES
-- ===========================================================
CREATE TABLE notificaciones (
    notificacion_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    tipo ENUM('Email','Sistema','Alerta') NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    mensaje TEXT NOT NULL,
    estado ENUM('Pendiente','Enviada','Leída') DEFAULT 'Pendiente',
    fecha_creacion INT NOT NULL,
    fecha_envio INT NULL,
    CONSTRAINT fk_notificaciones_usuarios FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
);

-- ===========================================================
-- ÍNDICES ADICIONALES
-- ===========================================================
CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_pedidos_usuario ON pedidos(usuario_id);
-- Este índice ahora funcionará porque la columna categoria_id ya existe
CREATE INDEX idx_productos_categoria ON productos(categoria_id); 
CREATE INDEX idx_comentarios_producto ON comentarios_calificaciones(producto_id);
CREATE INDEX idx_notificaciones_usuario ON notificaciones(usuario_id);
