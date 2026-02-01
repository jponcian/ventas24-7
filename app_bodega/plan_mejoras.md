# Plan de Mejoras - Ventas 24/7

Este documento detalla las mejoras y nuevas funcionalidades a implementar en la aplicación, transformándola de "Bodega Cloud" a "Ventas 24/7".

## 1. Rediseño de Marca y Login
- [ ] Cambiar el nombre de la aplicación de "Bodega Cloud" a **Ventas 24/7**.
- [ ] Rediseñar la pantalla de inicio de sesión con una estética "Premium":
    - Uso de degradados modernos.
    - Tipografía elegante (Outfit/Inter).
    - Reemplazar el icono de tienda por uno más versátil y moderno.
- [ ] Actualizar el nombre y el icono de la aplicación en Android (Launcher Icon).

## 2. Gestión de Productos y Precios
- [ ] **Corrección en Edición**: Al cargar un producto para editar, el "Costo por Paquete" debe calcularse como `Precio Unitario * Unidades por Paquete` para evitar distorsiones de precios.
- [ ] **Fecha de Vencimiento**:
    - [ ] Agregar campo `fecha_vencimiento` en la base de datos y API.
    - [ ] Agregar selector de fecha en el formulario de productos.
    - [ ] Implementar sistema de alertas al iniciar sesión que notifique si hay productos por vencer en los próximos 7 días.

## 3. Reportes Nativos
- [ ] Eliminar la dependencia de archivos PHP remotos para la generación de etiquetas.
- [ ] Implementar generación de PDF nativa en Flutter:
    - Formato optimizado para impresión de etiquetas.
    - Inclusión de códigos de barras generados dinámicamente.
    - Diseño profesional y fácil de recortar.

## 4. Sistema de Roles y Superadmin
- [ ] **Roles de Usuario**:
    - **Administrador**: Acceso total a todas las funciones (compras, ventas, reportes, inventario).
    - **Vendedor**: Acceso restringido únicamente a la realización de ventas.
- [ ] **Superadmin (Dueño)**:
    - Validación especial para el usuario maestro.
    - Gestión de múltiples negocios (Multitenancy básico).
    - Creación de usuarios asignados a negocios específicos.

## 5. Optimización Técnica
- [ ] Refactorización del manejo de estados para mayor fluidez.
- [ ] Mejorar la respuesta visual de las pantallas (Micro-animaciones).
