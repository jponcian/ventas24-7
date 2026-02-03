# Resumen de Implementación - Sistema de Fiados y Dashboard Administrativo

## Fecha: 02/02/2026

## Módulos Implementados

### 1. Dashboard Administrativo (`admin_dashboard_screen.dart`)

**Características:**
- Dashboard exclusivo para usuarios con rol de administrador
- Reportes financieros avanzados:
  - Ventas del día con número de transacciones
  - Ganancia neta (ventas - costos) con porcentaje de margen
  - Inversión total en inventario actual
  - Costos del día de productos vendidos
- Gráfico de ventas por hora (usando fl_chart)
- Top 5 productos más vendidos del día
- Selector de fecha para consultar datos históricos
- Acciones rápidas para nueva venta y reportes

**Endpoint requerido en backend:**
- `GET /bodega/api/admin_dashboard.php?negocio_id={id}&fecha={yyyy-mm-dd}`

**Respuesta esperada:**
```json
{
  "ok": true,
  "total_ventas_usd": 1500.50,
  "total_costos_usd": 900.30,
  "num_ventas": 25,
  "inversion_total_usd": 5000.00,
  "ventas_por_hora": [
    {"hora": 8, "total": 150.00},
    {"hora": 9, "total": 200.00}
  ],
  "top_products": [
    {
      "nombre": "Producto A",
      "cantidad_vendida": 50,
      "total_ventas": 500.00
    }
  ]
}
```

---

### 2. Sistema de Fiados (Créditos a Clientes)

#### 2.1 Modelos de Datos (`fiado_model.dart`)

**Clases creadas:**
- `Cliente`: Gestión de clientes con deuda total
- `Fiado`: Registro de créditos otorgados
- `FiadoDetalle`: Productos incluidos en cada fiado con precios congelados
- `Abono`: Pagos parciales o totales de fiados

#### 2.2 Gestión de Fiados (`fiados_screen.dart`)

**Características:**
- Interfaz con tabs para Clientes y Fiados
- Búsqueda de clientes por nombre, cédula o teléfono
- Visualización de deuda total por cliente
- **Integración con WhatsApp**: Envío automático de estado de cuenta
  - Genera mensaje formateado con todos los fiados pendientes
  - Calcula total adeudado
  - Abre WhatsApp con el mensaje pre-cargado
- Lista de fiados pendientes con información detallada

#### 2.3 Formulario de Clientes (`cliente_form_screen.dart`)

**Características:**
- Crear y editar clientes
- Campos: Nombre, Cédula, Teléfono, Dirección
- Validación de campos obligatorios
- Diseño moderno con Material 3

#### 2.4 Nuevo Fiado (`nuevo_fiado_screen.dart`)

**Características:**
- Selección de cliente desde dropdown
- Búsqueda y selección de productos
- **Precios congelados**: Los precios se guardan al momento de crear el fiado
- Visualización de stock disponible
- Resumen de fiado antes de guardar
- Cálculo automático en Bs y USD

#### 2.5 Detalle de Fiado (`fiado_detail_screen.dart`)

**Características:**
- Visualización completa del fiado
- Lista de productos con precios congelados
- Historial de abonos
- **Registro de abonos**:
  - Soporte para pagos en USD o Bs
  - Conversión automática con tasa del día
  - Campo de observaciones
  - Actualización automática del saldo pendiente

---

### 3. Actualizaciones en API Service (`api_service.dart`)

**Nuevos endpoints agregados:**

#### Dashboard Administrativo
- `getAdminDashboardData(String fecha)`: Obtiene datos del dashboard

#### Clientes
- `getClientes()`: Lista todos los clientes
- `getCliente(int id)`: Obtiene un cliente específico
- `crearCliente(Map data)`: Crea nuevo cliente
- `actualizarCliente(int id, Map data)`: Actualiza cliente

#### Fiados
- `getFiados()`: Lista todos los fiados
- `getFiadoDetalle(int id)`: Obtiene detalle de un fiado
- `crearFiado(Map data)`: Crea nuevo fiado

#### Abonos
- `getAbonosFiado(int fiadoId)`: Lista abonos de un fiado
- `registrarAbono(Map data)`: Registra un nuevo abono

---

### 4. Dependencias Agregadas

**En `pubspec.yaml`:**
```yaml
fl_chart: ^0.69.0  # Para gráficos en dashboard administrativo
```

---

## Endpoints del Backend Requeridos

### 1. Dashboard Administrativo
```
GET /bodega/api/admin_dashboard.php?negocio_id={id}&fecha={fecha}
```

### 2. Clientes
```
GET /bodega/api/clientes.php?negocio_id={id}
GET /bodega/api/clientes.php?id={id}
POST /bodega/api/clientes.php
PUT /bodega/api/clientes.php
```

### 3. Fiados
```
GET /bodega/api/fiados.php?negocio_id={id}
GET /bodega/api/fiados.php?id={id}
POST /bodega/api/fiados.php
```

### 4. Abonos
```
GET /bodega/api/abonos.php?fiado_id={id}
POST /bodega/api/abonos.php
```

---

## Estructura de Base de Datos Sugerida

### Tabla: clientes
```sql
CREATE TABLE clientes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  negocio_id INT NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  cedula VARCHAR(20),
  telefono VARCHAR(20),
  direccion TEXT,
  deuda_total DECIMAL(10,2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (negocio_id) REFERENCES negocios(id)
);
```

### Tabla: fiados
```sql
CREATE TABLE fiados (
  id INT PRIMARY KEY AUTO_INCREMENT,
  negocio_id INT NOT NULL,
  cliente_id INT NOT NULL,
  total_bs DECIMAL(10,2) NOT NULL,
  total_usd DECIMAL(10,2) NOT NULL,
  saldo_pendiente DECIMAL(10,2) NOT NULL,
  tasa DECIMAL(10,2) NOT NULL,
  estado ENUM('pendiente', 'pagado', 'cancelado') DEFAULT 'pendiente',
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (negocio_id) REFERENCES negocios(id),
  FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);
```

### Tabla: fiado_detalles
```sql
CREATE TABLE fiado_detalles (
  id INT PRIMARY KEY AUTO_INCREMENT,
  fiado_id INT NOT NULL,
  producto_id INT NOT NULL,
  cantidad DECIMAL(10,3) NOT NULL,
  precio_unitario_bs DECIMAL(10,2) NOT NULL,
  precio_unitario_usd DECIMAL(10,2) NOT NULL,
  subtotal_bs DECIMAL(10,2) NOT NULL,
  subtotal_usd DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (fiado_id) REFERENCES fiados(id),
  FOREIGN KEY (producto_id) REFERENCES productos(id)
);
```

### Tabla: abonos
```sql
CREATE TABLE abonos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  fiado_id INT NOT NULL,
  monto_bs DECIMAL(10,2) NOT NULL,
  monto_usd DECIMAL(10,2) NOT NULL,
  observaciones TEXT,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (fiado_id) REFERENCES fiados(id)
);
```

---

## Próximos Pasos

### Backend (PHP)
1. Crear los archivos PHP para los endpoints mencionados
2. Implementar la lógica de negocio para:
   - Cálculo de deuda total por cliente
   - Actualización de saldo pendiente al registrar abonos
   - Generación de reportes del dashboard administrativo
   - Cálculo de ganancia real (ventas - costos)

### Frontend (Flutter)
1. Integrar las nuevas pantallas al menú principal (drawer)
2. Implementar control de acceso por roles:
   - Dashboard normal para vendedores
   - Dashboard administrativo solo para admins
   - Módulo de fiados según permisos
3. Agregar navegación desde el drawer a:
   - Dashboard Administrativo (solo admin)
   - Gestión de Fiados

### Funcionalidades Adicionales Sugeridas
1. **Reajuste de precios en fiados**: Función para actualizar precios de fiados pendientes cuando suben los productos
2. **Notificaciones**: Alertas para clientes con deudas vencidas
3. **Reportes de fiados**: Estadísticas de créditos otorgados, recuperación, etc.
4. **Límite de crédito**: Establecer monto máximo de crédito por cliente

---

## Notas Importantes

1. **Precios Congelados**: Los precios de los productos en los fiados se guardan al momento de la creación y no cambian aunque el producto suba de precio
2. **WhatsApp**: La integración usa el esquema `wa.me` que funciona en dispositivos móviles
3. **Roles**: El sistema diferencia entre vendedores y administradores
4. **Tasa de cambio**: Se usa la tasa del día para conversiones USD/Bs en abonos

---

## Archivos Creados

1. `lib/admin_dashboard_screen.dart` - Dashboard administrativo
2. `lib/fiado_model.dart` - Modelos de datos
3. `lib/fiados_screen.dart` - Pantalla principal de fiados
4. `lib/cliente_form_screen.dart` - Formulario de clientes
5. `lib/nuevo_fiado_screen.dart` - Crear nuevo fiado
6. `lib/fiado_detail_screen.dart` - Detalle y abonos de fiado

## Archivos Modificados

1. `lib/api_service.dart` - Nuevos métodos de API
2. `pubspec.yaml` - Nueva dependencia fl_chart
