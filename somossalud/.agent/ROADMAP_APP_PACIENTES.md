# 📱 Plan de Mejoras - App Pacientes SomosSalud

**Fecha:** 30 de Diciembre, 2024  
**Versión Actual:** 1.1.0  
**Última Actualización:** Sistema de Agendamiento de Citas Médicas

---

## ✅ Funcionalidades Implementadas (v1.1.0)

### Módulos Principales:
1. **Autenticación**
   - Login con cédula y contraseña
   - Logout seguro
   - Gestión de tokens (Sanctum)

2. **Dashboard**
   - Resumen de suscripción activa
   - Próxima cita médica
   - Última receta médica
   - Resultados de laboratorio recientes (propios y dependientes)

3. **Resultados de Laboratorio**
   - Lista de resultados completados
   - Detalle de cada resultado con parámetros
   - Descarga de PDF firmado
   - Visualización por familia (titular + dependientes)

4. **Citas Médicas**
   - Lista de citas (pendientes, completadas, canceladas)
   - Detalle de cita con diagnóstico y tratamiento
   - **NUEVO:** Agendamiento de citas
     - Selección de especialidad
     - Selección de especialista
     - Calendario de fechas
     - Grilla de horarios disponibles reales
     - Validación de disponibilidad
   - Visualización de recetas médicas (si la cita está concluida)

5. **Perfil de Usuario**
   - Visualización de datos personales
   - Edición de perfil
   - Cambio de contraseña

6. **Suscripción**
   - Estado de suscripción activa
   - Detalles del plan
   - Fecha de vencimiento

7. **Reportar Pagos**
   - Formulario para reportar pagos
   - Carga de comprobantes
   - Seguimiento de estado

---

## 🐛 Correcciones Recientes

### v1.1.0 (30/12/2024):
1. ✅ Formato de hora AM/PM en selectores de tiempo
2. ✅ Validación corregida de tabla `usuarios` (no `users`)
3. ✅ Manejo de errores mejorado en endpoints de citas
4. ✅ Formato de fecha con hora en resultados del dashboard
5. ✅ Grilla visual de horarios disponibles basada en disponibilidad real del doctor

---

## 🚀 Funcionalidades Pendientes

### 🔴 ALTA PRIORIDAD

#### 1. 👨‍👩‍👧 Gestión de Dependientes
**Descripción:** Permitir al usuario gestionar y ver información de sus dependientes (hijos, familiares).

**Backend:** ✅ Ya implementado
- Relación `representante_id` en tabla `usuarios`
- Método `dependientes()` en modelo User
- Dashboard ya filtra por familia

**Frontend:** ❌ Pendiente
- [ ] Pantalla de lista de dependientes
- [ ] Agregar nuevo dependiente
- [ ] Editar dependiente
- [ ] Selector de perfil activo (titular/dependiente)
- [ ] Filtrar resultados y citas por dependiente seleccionado

**Endpoints necesarios:**
```php
GET  /paciente/dependientes          // Listar dependientes
POST /paciente/dependientes          // Crear dependiente
PUT  /paciente/dependientes/{id}     // Actualizar dependiente
DELETE /paciente/dependientes/{id}   // Eliminar dependiente
```

**Estimación:** 2-3 días

---

#### 2. 🔔 Notificaciones Push
**Descripción:** Alertas en tiempo real para eventos importantes.

**Casos de uso:**
- Recordatorio de cita (24h antes)
- Nuevos resultados de laboratorio disponibles
- Vencimiento de suscripción (7 días antes)
- Confirmación de cita agendada

**Backend:** ⚠️ Parcialmente implementado
- ✅ Ya existe sistema de WhatsApp
- ❌ Falta Firebase Cloud Messaging

**Frontend:** ❌ Pendiente
- [ ] Integrar Firebase Cloud Messaging
- [ ] Solicitar permisos de notificaciones
- [ ] Manejar notificaciones en foreground/background
- [ ] Pantalla de configuración de notificaciones

**Dependencias:**
```yaml
firebase_core: ^2.24.2
firebase_messaging: ^14.7.9
flutter_local_notifications: ^16.3.0
```

**Estimación:** 3-4 días

---

#### 3. 📅 Cancelar/Reprogramar Citas
**Descripción:** Permitir al paciente gestionar sus citas agendadas.

**Backend:** ✅ Ya implementado
- Método `cancelar()` en CitaController
- Método `reprogramar()` en CitaController

**Frontend:** ❌ Pendiente
- [ ] Botón "Cancelar" en detalle de cita
- [ ] Modal de confirmación de cancelación
- [ ] Pantalla de reprogramación con nuevo selector de fecha/hora
- [ ] Validación de horarios disponibles

**Endpoints necesarios:**
```php
POST /paciente/citas/{id}/cancelar      // Ya existe en web, falta en API
POST /paciente/citas/{id}/reprogramar   // Ya existe en web, falta en API
```

**Estimación:** 1-2 días

---

### 🟡 MEDIA PRIORIDAD

#### 4. 💳 Historial de Pagos
**Descripción:** Ver pagos reportados y su estado de aprobación.

**Backend:** ⚠️ Parcialmente implementado
- ✅ Modelo `ReportePago` existe
- ❌ Falta endpoint para listar pagos del usuario

**Frontend:** ❌ Pendiente
- [ ] Pantalla de historial de pagos
- [ ] Estados: Pendiente, Aprobado, Rechazado
- [ ] Detalle de cada pago
- [ ] Filtros por estado y fecha

**Endpoints necesarios:**
```php
GET /paciente/pagos              // Listar pagos reportados
GET /paciente/pagos/{id}         // Detalle de pago
```

**Estimación:** 1 día

---

#### 5. 📅 Vista de Calendario
**Descripción:** Calendario mensual con todas las citas.

**Backend:** ✅ Ya implementado (endpoint de citas existe)

**Frontend:** ❌ Pendiente
- [ ] Integrar paquete de calendario
- [ ] Marcar días con citas
- [ ] Tap en día para ver citas de ese día
- [ ] Indicadores de color por estado

**Dependencias:**
```yaml
table_calendar: ^3.0.9
```

**Estimación:** 2 días

---

#### 6. 📱 Compartir Resultados
**Descripción:** Compartir PDFs de resultados por WhatsApp/Email.

**Backend:** ✅ Ya implementado
- URLs firmadas temporales ya existen

**Frontend:** ❌ Pendiente
- [ ] Botón "Compartir" en detalle de resultado
- [ ] Integración con share nativo
- [ ] Opción de compartir por WhatsApp directo

**Dependencias:**
```yaml
share_plus: ^7.2.1
```

**Estimación:** 1 día

---

#### 7. 💊 Historial Médico Completo
**Descripción:** Timeline con todas las consultas y atenciones.

**Backend:** ✅ Ya implementado
- Datos disponibles en modelos `Cita` y `Atencion`

**Frontend:** ❌ Pendiente
- [ ] Pantalla de historial médico
- [ ] Timeline visual
- [ ] Filtros por especialidad, doctor, fecha
- [ ] Búsqueda de texto

**Endpoints necesarios:**
```php
GET /paciente/historial-medico   // Citas + Atenciones unificadas
```

**Estimación:** 2-3 días

---

### 🟢 BAJA PRIORIDAD

#### 8. 🌙 Modo Oscuro
**Descripción:** Tema oscuro para la aplicación.

**Frontend:** ❌ Pendiente
- [ ] Definir paleta de colores oscuros
- [ ] Implementar ThemeData dark
- [ ] Toggle en configuración
- [ ] Persistir preferencia

**Estimación:** 1-2 días

---

#### 9. 📊 Gráficas de Salud
**Descripción:** Visualización de evolución de parámetros de laboratorio.

**Backend:** ❌ Pendiente
- Necesita endpoint para datos históricos de parámetros específicos

**Frontend:** ❌ Pendiente
- [ ] Selección de parámetro a graficar
- [ ] Gráfica de líneas con evolución temporal
- [ ] Indicadores de valores de referencia

**Dependencias:**
```yaml
fl_chart: ^0.66.0
```

**Estimación:** 3-4 días

---

#### 10. 🔍 Búsqueda Global
**Descripción:** Buscar en todos los módulos desde un solo lugar.

**Frontend:** ❌ Pendiente
- [ ] Barra de búsqueda global
- [ ] Búsqueda en resultados, citas, recetas
- [ ] Filtros avanzados

**Estimación:** 2 días

---

#### 11. ⚡ Modo Offline
**Descripción:** Cache de datos para acceso sin internet.

**Frontend:** ❌ Pendiente
- [ ] Implementar cache local (Hive/SQLite)
- [ ] Sincronización automática
- [ ] Indicador de modo offline

**Dependencias:**
```yaml
hive: ^2.2.3
hive_flutter: ^1.1.0
connectivity_plus: ^5.0.2
```

**Estimación:** 3-4 días

---

## 🐛 Bugs y Mejoras Menores

### Bugs Conocidos:


### Mejoras de UX:
- [ ] Pull-to-refresh en todas las pantallas de lista
- [ ] Loading states más claros (skeleton screens)
- [ ] Mensajes de error más amigables y específicos
- [ ] Animaciones de transición entre pantallas
- [ ] Validación de suscripción activa antes de agendar citas
- [ ] Confirmación antes de acciones destructivas
- [ ] Indicadores de progreso en formularios largos

### Mejoras de Performance:
- [ ] Lazy loading en listas largas
- [ ] Optimización de imágenes
- [ ] Cache de imágenes de perfil
- [ ] Paginación en listados

---

## 📋 Plan de Desarrollo Sugerido

### Sprint 1 (Semana 1-2):
**Objetivo:** Mejorar gestión de citas y familia

1. Gestión de Dependientes (3 días)
2. Cancelar/Reprogramar Citas (2 días)
3. Mejoras de UX menores (2 días)

**Entregable:** v1.2.0

---

### Sprint 2 (Semana 3-4):
**Objetivo:** Notificaciones y pagos

1. Notificaciones Push (4 días)
2. Historial de Pagos (1 día)
3. Compartir Resultados (1 día)
4. Testing y bugfixes (1 día)

**Entregable:** v1.3.0

---

### Sprint 3 (Semana 5-6):
**Objetivo:** Experiencia de usuario avanzada

1. Vista de Calendario (2 días)
2. Historial Médico Completo (3 días)
3. Modo Oscuro (2 días)

**Entregable:** v1.4.0

---

### Sprint 4 (Futuro):
**Objetivo:** Features avanzadas

1. Gráficas de Salud
2. Búsqueda Global
3. Modo Offline

**Entregable:** v2.0.0

---

## 🔧 Deuda Técnica

### Backend:
1. Agregar endpoints faltantes para API móvil:
   - Gestión de dependientes
   - Cancelar/reprogramar citas desde API
   - Historial de pagos
   - Historial médico unificado

2. Implementar Firebase Admin SDK para notificaciones push

3. Optimizar queries con eager loading

### Frontend:
1. Refactorizar servicios para usar Repository Pattern
2. Implementar manejo de estado con Provider/Riverpod
3. Agregar tests unitarios y de integración
4. Documentar código
5. Implementar CI/CD para builds automáticos

---

## 📝 Notas Importantes

### Archivos Modificados en v1.1.0:
```
Backend (Laravel):
- app/Http/Controllers/Api/ApiPatientController.php
- routes/api.php

Frontend (Flutter):
- lib/services/patient_service.dart
- lib/services/auth_service.dart
- lib/screens/new_appointment_screen.dart
- lib/screens/appointments_screen.dart
- pubspec.yaml (versión 1.1.0+2)

Web:
- resources/views/landing.blade.php (versión APK)
```

### Archivos a Subir al Servidor:
1. `app/Http/Controllers/Api/ApiPatientController.php` ✅
2. `routes/api.php` ✅
3. `public/apks/app-pacientes.apk` ✅

### Comandos Git Útiles:
```bash
# Crear rama para nueva funcionalidad
git checkout -b feature/gestion-dependientes

# Ver cambios
git status
git diff

# Commit
git add .
git commit -m "feat: implementar gestión de dependientes"

# Push
git push origin feature/gestion-dependientes
```

---

## 📞 Contacto y Recursos

**Repositorio:** https://github.com/jponcian/ponciano.git  
**Servidor Producción:** https://clinicasaludsonrisa.com.ve  
**APK Descarga:** https://clinicasaludsonrisa.com.ve/apks/app-pacientes.apk

---

**Última actualización:** 30 de Diciembre, 2024 - 07:38 AM  
**Próxima revisión:** En oficina
