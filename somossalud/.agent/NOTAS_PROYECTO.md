# 📋 NOTAS DEL PROYECTO - Clínica SaludSonrisa

> **IMPORTANTE**: Lee este archivo SIEMPRE al abrir el proyecto para ponerte al día con el estado actual.

---

## 🎯 ESTADO ACTUAL DEL PROYECTO (Última actualización: 31/12/2024)

### ✅ Base de Datos
- **Estado**: Base de datos completamente migrada y operativa
- **Ubicación**: SQL local en `database/javier_ponciano_5.sql`
- **Migraciones**: ❌ ELIMINADAS - Ya no se usan archivos de migración PHP
- **Gestión**: Todos los cambios de BD se hacen directamente en SQL

### 📱 Aplicaciones Activas

#### 1. **Backend Laravel** (Principal)
- Sistema de gestión clínica completo
- Módulos principales:
  - 👥 Gestión de pacientes y usuarios
  - 📅 Sistema de citas médicas
  - 🔬 Módulo de laboratorio con referencias inteligentes
  - 💊 Gestión de materiales y bodega
  - 💰 Sistema de pagos y comisiones
  - 📊 Reportes y estadísticas
  - 💳 Integración con Cashea (pagos en cuotas)
  - 📲 Sistema de notificaciones WhatsApp

#### 2. **App Flutter** (`app_somossalud/`)
- Aplicación móvil para pacientes
- Funcionalidades:
  - Ver y agendar citas
  - Consultar resultados de laboratorio
  - Gestión de perfil
  - Sistema de suscripciones
  - Reportar pagos
  - Ver recetas médicas digitales

#### 3. **Web Móvil** (`mobile/`)
- Versión web responsive para pacientes
- Acceso público a funcionalidades básicas

---

## 🔥 CAMBIOS RECIENTES IMPORTANTES

### Diciembre 2024

#### Sistema de Laboratorio
- ✅ Referencias inteligentes por edad y sexo
- ✅ Gestión de parámetros con tipos (Encabezado, Numérico, Texto)
- ✅ Generación de PDFs de resultados
- ✅ Envío de resultados por WhatsApp
- ✅ Tickets térmicos para órdenes de laboratorio

#### Sistema de Citas
- ✅ Campo `motivo` agregado a citas
- ✅ Recordatorios automáticos por WhatsApp
- ✅ Recetas médicas digitales con URL pública

#### Sistema de Materiales/Bodega
- ✅ **Categorías disponibles**: Enfermería, Quirófano, UCI, Oficina, Laboratorio
- ✅ Control de stock actualizado
- ✅ Gestión de solicitudes y órdenes de compra

#### App Flutter
- ✅ Versión 1.0.3 publicada
- ✅ Integración completa con backend Laravel
- ✅ Sistema de suscripciones implementado
- ✅ Visualización de resultados de laboratorio

#### Sistema de Pagos
- ✅ Integración con Cashea
- ✅ Comisiones automáticas en estado de cuenta
- ✅ Reportes de pagos desde la app móvil

---

## 📁 ESTRUCTURA DE CARPETAS CLAVE

```
somossalud/
├── app/                    # Lógica del backend Laravel
│   ├── Http/Controllers/  # Controladores
│   ├── Models/            # Modelos Eloquent
│   └── Services/          # Servicios (WhatsApp, etc.)
├── resources/views/       # Vistas Blade
│   ├── paciente/         # Vistas para pacientes
│   ├── laboratorio/      # Módulo de laboratorio
│   ├── atenciones/       # Gestión de atenciones
│   └── administracion/   # Panel administrativo
├── database/
│   └── javier_ponciano_5.sql  # BD completa
├── app_somossalud/       # App Flutter
├── mobile/               # Web móvil
└── .agent/               # Documentación y notas
    ├── notes/            # Notas de sesiones
    └── sql/              # Scripts SQL útiles
```

---

## 🔧 CONFIGURACIÓN IMPORTANTE

### WhatsApp (Evolution API)
- **Endpoint**: Configurado en `.env`
- **Funcionalidades activas**:
  - Recordatorios de citas
  - Envío de resultados de laboratorio (PDF)
  - Notificaciones generales

### Base de Datos
- **Motor**: MySQL/MariaDB
- **Nombre**: `javier_ponciano_5`
- **Gestión**: WAMP64 local
- **Backup**: `database/javier_ponciano_5.sql`

### Autenticación
- **Backend**: Laravel Sanctum
- **App Flutter**: Token-based authentication
- **Sesiones web**: Sistema de sesiones Laravel estándar

---

## 🚨 PUNTOS CRÍTICOS A RECORDAR

1. **NO usar migraciones PHP** - Todos los cambios de BD se hacen en SQL directamente
2. **Siempre actualizar el archivo SQL** después de cambios en la BD
3. **La app Flutter** requiere backend en funcionamiento para operar
4. **WhatsApp** necesita Evolution API configurada y activa
5. **Suscripciones** son obligatorias para que pacientes agenden citas
6. **Referencias de laboratorio** se seleccionan automáticamente por edad/sexo

---

## 📝 TAREAS PENDIENTES

### Alta Prioridad
- [ ] Actualizar documentación de ayuda (README.md)
- [ ] Revisar y documentar endpoints de API
- [ ] Validar funcionamiento en producción

### Media Prioridad
- [ ] Optimizar consultas de base de datos
- [ ] Mejorar sistema de reportes
- [ ] Agregar más tests automatizados

### Baja Prioridad
- [ ] Refactorizar código legacy
- [ ] Mejorar UI/UX en secciones antiguas
- [ ] Documentar flujos de trabajo complejos

---

## 💡 NOTAS ADICIONALES

### Para Desarrollo
- Usar `php artisan serve` para servidor local
- App Flutter: `flutter run` desde `app_somossalud/`
- Base de datos: Importar `database/javier_ponciano_5.sql` si es necesario

### Para Producción
- Verificar configuración de `.env`
- Asegurar que Evolution API esté activa
- Validar permisos de carpetas `storage/` y `bootstrap/cache/`

---

## 📚 DOCUMENTACIÓN RELACIONADA

- `ROADMAP_APP_PACIENTES.md` - Roadmap de la app móvil
- `CAMBIOS_SESION_30_12_2024.md` - Últimos cambios importantes
- `.agent/notes/` - Notas de sesiones de trabajo
- `.agent/sql/` - Scripts SQL útiles

---

**Última actualización**: 31 de Diciembre de 2024
**Responsable**: Javier Ponciano
**Proyecto**: Clínica SaludSonrisa
