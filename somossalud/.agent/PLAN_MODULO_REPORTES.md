# Plan: Módulo de Reportes

## Resumen del Sistema

Basándome en el análisis del proyecto, el sistema "Somos Salud" incluye los siguientes módulos:

### Módulos Existentes:
1. **Citas Médicas** - Gestión de citas programadas con especialistas
2. **Atenciones** - Atenciones de emergencia/guardia con seguros
3. **Laboratorio** - Órdenes de exámenes y resultados
4. **Inventario** - Solicitudes, ingresos y gestión de materiales
5. **Suscripciones** - Planes de pacientes y reportes de pago
6. **Usuarios** - Pacientes, especialistas, personal administrativo
7. **Nómina** (mencionado en conversaciones previas)

---

## Propuesta de Reportes por Módulo

### 📊 1. REPORTES DE CITAS MÉDICAS

#### 1.1 Citas por Período
- **Filtros**: Fecha inicio/fin, especialista, estado
- **Datos**: Total citas, por estado (pendiente/confirmada/cancelada/concluida)
- **Gráficos**: Barras por estado, línea de tendencia temporal
- **Exportar**: PDF, Excel

#### 1.2 Productividad de Especialistas
- **Filtros**: Rango de fechas, especialista específico
- **Datos**: Citas atendidas, promedio por día, tasa de cancelación
- **Gráficos**: Comparativa entre especialistas, ranking
- **Exportar**: PDF, Excel

#### 1.3 Ingresos por Citas
- **Filtros**: Período, especialista, tipo de servicio
- **Datos**: Total facturado, ingreso promedio por cita, descuentos aplicados
- **Gráficos**: Barras de ingresos mensuales, pie chart por especialidad
- **Exportar**: PDF, Excel

---

### 🏥 2. REPORTES DE ATENCIONES (GUARDIA/EMERGENCIA)

#### 2.1 Atenciones por Aseguradora
- **Filtros**: Fecha, aseguradora, estado de validación
- **Datos**: Total atenciones, por aseguradora, monto facturado
- **Gráficos**: Pie chart distribución por aseguradora
- **Exportar**: PDF, Excel

#### 2.2 Atenciones Pendientes de Validación
- **Filtros**: Fecha desde
- **Datos**: Listado de atenciones sin validar, tiempo de espera
- **Útil para**: Recepción y administración
- **Exportar**: Excel para seguimiento

#### 2.3 Reporte de Atenciones por Médico
- **Filtros**: Período, médico
- **Datos**: Cantidad de atenciones, tiempo promedio de atención
- **Exportar**: PDF, Excel

---

### 🔬 3. REPORTES DE LABORATORIO

#### 3.1 Órdenes de Laboratorio por Período
- **Filtros**: Fecha, estado (pendiente/en progreso/completado)
- **Datos**: Total órdenes, promedio por día, ingresos generados
- **Gráficos**: Línea temporal de órdenes
- **Exportar**: PDF, Excel

#### 3.2 Exámenes Más Solicitados
- **Filtros**: Período
- **Datos**: Ranking de exámenes más frecuentes, ingresos por examen
- **Gráficos**: Barras horizontales top 10
- **Exportar**: PDF, Excel

#### 3.3 Tiempo de Procesamiento
- **Filtros**: Período
- **Datos**: Tiempo promedio entre orden y resultado
- **Gráficos**: Evolución del tiempo promedio
- **Útil para**: Control de calidad del servicio
- **Exportar**: Excel

#### 3.4 Órdenes Pendientes
- **Datos**: Listado de órdenes sin completar, días de antigüedad
- **Útil para**: Seguimiento diario del laboratorio
- **Exportar**: PDF

---

### 📦 4. REPORTES DE INVENTARIO

#### 4.1 Estado de Stock
- **Filtros**: Categoría de material
- **Datos**: Materiales con stock bajo mínimo, valor del inventario
- **Gráficos**: Indicadores visuales de stock crítico
- **Exportar**: PDF, Excel

#### 4.2 Movimientos de Inventario
- **Filtros**: Período, tipo (ingreso/egreso), material
- **Datos**: Detalle de todos los movimientos
- **Exportar**: Excel para análisis

#### 4.3 Solicitudes de Inventario
- **Filtros**: Período, estado, categoría
- **Datos**: Total solicitudes, tiempo promedio de aprobación/despacho
- **Gráficos**: Estado de solicitudes (pendiente/aprobada/despachada)
- **Exportar**: PDF, Excel

#### 4.4 Consumo por Departamento/Área
- **Filtros**: Período
- **Datos**: Materiales más solicitados por área
- **Útil para**: Planificación de compras
- **Exportar**: Excel

#### 4.5 Historial de Material
- **Filtros**: Material específico
- **Datos**: Todos los movimientos de un material (ingresos, egresos, stock)
- **Gráficos**: Línea temporal del stock
- **Exportar**: PDF

---

### 💳 5. REPORTES DE SUSCRIPCIONES Y PAGOS

#### 5.1 Suscripciones Activas
- **Datos**: Total suscripciones activas, por plan
- **Gráficos**: Distribución por plan
- **Exportar**: PDF, Excel

#### 5.2 Pagos Reportados
- **Filtros**: Período, estado (pendiente/aprobado/rechazado)
- **Datos**: Total reportes, monto pendiente de validar
- **Exportar**: Excel

#### 5.3 Ingresos por Suscripciones
- **Filtros**: Período
- **Datos**: Total facturado, proyección mensual
- **Gráficos**: Línea de tendencia
- **Exportar**: PDF, Excel

---

### 👥 6. REPORTES DE USUARIOS Y PACIENTES

#### 6.1 Usuarios Registrados
- **Filtros**: Rol, fecha de registro
- **Datos**: Total usuarios, crecimiento mensual, por rol
- **Gráficos**: Evolución temporal
- **Exportar**: Excel

#### 6.2 Pacientes Activos vs Inactivos
- **Filtros**: Período de última actividad
- **Datos**: Pacientes con citas/atenciones recientes
- **Útil para**: Marketing y retención
- **Exportar**: Excel

---

### 💰 7. REPORTES FINANCIEROS CONSOLIDADOS

#### 7.1 Dashboard Ejecutivo
- **Datos**: Vista general de todos los ingresos (citas, lab, suscripciones)
- **Periodo**: Seleccionable (día/semana/mes/año)
- **Gráficos**: KPIs principales, comparativas
- **Exportar**: PDF ejecutivo

#### 7.2 Reporte de Ingresos Consolidado
- **Filtros**: Período
- **Datos**: Detalle de ingresos por módulo (citas, laboratorio, suscripciones)
- **Gráficos**: Distribución porcentual
- **Exportar**: PDF, Excel

---

## Estructura Propuesta

### Ubicación en el Menú Lateral
```
📊 REPORTES
  ├── 📅 Citas Médicas
  ├── 🏥 Atenciones
  ├── 🔬 Laboratorio
  ├── 📦 Inventario
  ├── 💳 Suscripciones
  └── 💰 Consolidado Financiero
```

### Permisos por Rol
- **super-admin**: Acceso total a todos los reportes
- **admin_clinica**: Acceso total a todos los reportes
- **almacen-jefe**: Reportes de inventario + consolidado
- **laboratorio**: Reportes de laboratorio
- **recepcionista**: Reportes de citas, atenciones, suscripciones
- **especialista**: Solo sus propios reportes de productividad

---

## Características Técnicas Sugeridas

### Funcionalidades Comunes
1. **Filtros avanzados** en todos los reportes
2. **Exportación** a PDF y Excel
3. **Gráficos interactivos** con Chart.js o similar
4. **Datos en tiempo real** o con caché de 5 minutos
5. **Impresión amigable** con diseño optimizado
6. **Guardado de filtros favoritos** (opcional fase 2)

### Stack Técnico
- **Backend**: Controladores dedicados para cada tipo de reporte
- **Frontend**: Blade templates con componentes reutilizables
- **Gráficos**: Chart.js o ApexCharts
- **Exportación PDF**: DomPDF o TCPDF
- **Exportación Excel**: Laravel Excel (Maatwebsite)
- **Tablas**: DataTables.js para filtrado y paginación
- **Diseño**: AdminLTE (ya usado en el proyecto)

---

## Priorización Recomendada

### FASE 1 (Más críticos e inmediatos)


### FASE 2 (Análisis y optimización)
6. Productividad de Especialistas
7. Ingresos por Citas
8. Exámenes Más Solicitados
9. Atenciones por Aseguradora
10. Consumo de Inventario por Área

### FASE 3 (Avanzados y opcionales)
11. Tiempo de Procesamiento Laboratorio
12. Pacientes Activos vs Inactivos
13. Guardado de filtros favoritos
14. Reportes programados por email

---

## Próximos Pasos


2. **Definir** qué reportes implementar primero
3. **Crear** estructura de controladores y rutas
4. **Diseñar** vistas con filtros reutilizables
5. **Implementar** lógica de consultas optimizadas
6. **Agregar** exportación PDF/Excel
7. **Integrar** gráficos interactivos
8. **Probar** con datos reales
