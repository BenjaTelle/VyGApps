-- Script para crear la tabla de deducciones en MariaDB / MySQL
-- Listo para copiar y pegar en la consola Linux de MariaDB/MySQL en el servidor

USE vygapps;

CREATE TABLE IF NOT EXISTS `deducciones` (
  `id_deduccion` INT(11) NOT NULL AUTO_INCREMENT,
  `id_trabajador` INT(11) NOT NULL,
  `concepto` VARCHAR(255) DEFAULT NULL,
  `monto` DECIMAL(10,2) NOT NULL,
  `estado` VARCHAR(20) NOT NULL DEFAULT 'Pendiente',
  `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `id_user_registra` INT(11) DEFAULT NULL,
  PRIMARY KEY (`id_deduccion`),
  KEY `fk_deduccion_trabajador` (`id_trabajador`),
  CONSTRAINT `fk_deduccion_trabajador` FOREIGN KEY (`id_trabajador`) REFERENCES `trabajadores` (`id_trabajador`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
