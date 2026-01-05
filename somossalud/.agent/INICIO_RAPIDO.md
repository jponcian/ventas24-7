# 🚀 INICIO RÁPIDO - Clínica SaludSonrisa

> **LEE ESTO PRIMERO**: Este archivo te pone al día rápidamente con el proyecto.

---

## ⚡ Lo Más Importante

### 1️⃣ **SIEMPRE LEE PRIMERO**
📄 `.agent/NOTAS_PROYECTO.md` - Contexto completo y actualizado

### 2️⃣ **NO USAR MIGRACIONES**
❌ Los archivos de migración PHP fueron eliminados
✅ Todos los cambios de BD se hacen en SQL directamente
📁 BD completa en: `database/javier_ponciano_5.sql`

### 3️⃣ **Estructura del Proyecto**
```
Backend Laravel  → Sistema administrativo principal
App Flutter      → app_somossalud/ (v1.0.3)
Web Móvil        → mobile/
Base de Datos    → database/javier_ponciano_5.sql
Documentación    → .agent/
```

---

## 🎯 Comandos Rápidos

### Iniciar Desarrollo
```bash
# Backend Laravel
php artisan serve

# App Flutter (desde app_somossalud/)
flutter run

# Compilar assets
npm run dev
```

### Base de Datos
```bash
# Importar BD (si es necesario)
# Usar phpMyAdmin o línea de comandos
# Archivo: database/javier_ponciano_5.sql
```

### Generar APK Flutter
```bash
cd app_somossalud
flutter build apk --release
```

---

## 📋 Módulos Principales

| Módulo | Descripción | Estado |
|--------|-------------|--------|
| 👥 Pacientes | Gestión completa + suscripciones | ✅ Operativo |
| 📅 Citas | Agendamiento + WhatsApp | ✅ Operativo |
| 🔬 Laboratorio | Órdenes + Referencias inteligentes | ✅ Operativo |
| 💊 Bodega | Inventario (5 categorías) + Solicitudes | ✅ Operativo |
| 💰 Pagos | Estado cuenta + Cashea | ✅ Operativo |
| 📲 WhatsApp | Notificaciones automáticas | ✅ Operativo |
| 📱 App Móvil | Flutter v1.0.3 | ✅ Operativo |

---

## 🔑 Configuración Esencial

### .env Principal
```env
# Base de Datos
DB_DATABASE=javier_ponciano_5
DB_USERNAME=root
DB_PASSWORD=

# WhatsApp (Evolution API)
EVOLUTION_API_URL=...
EVOLUTION_API_KEY=...
EVOLUTION_INSTANCE=...
```

### App Flutter
```dart
// lib/services/api_service.dart
static const String baseUrl = 'http://localhost:8000/api';
```

---

## 🆘 Problemas Comunes

### ❌ Error: "No se pueden ejecutar migraciones"
**Solución**: No uses migraciones. Importa `database/javier_ponciano_5.sql`

### ❌ Error: "App móvil no conecta"
**Solución**: Verifica URL en `api_service.dart` y que el servidor esté corriendo

### ❌ Error: "WhatsApp no envía"
**Solución**: Verifica configuración Evolution API en `.env`

### ❌ Error: "Permisos en storage"
**Solución**: `chmod -R 775 storage bootstrap/cache`

---

## 📚 Documentación Completa

| Archivo | Contenido |
|---------|-----------|
| `NOTAS_PROYECTO.md` | ⭐ Estado actual y contexto completo |
| `README.md` | Documentación técnica completa |
| `ROADMAP_APP_PACIENTES.md` | Roadmap de la app móvil |
| `CAMBIOS_SESION_30_12_2024.md` | Últimos cambios importantes |
| `.agent/notes/` | Notas de sesiones de trabajo |

---

## 🎨 Últimas Características (Dic 2024)

✅ Referencias de laboratorio inteligentes (por edad/sexo)  
✅ Envío de resultados por WhatsApp  
✅ Tickets térmicos para laboratorio  
✅ Recetas médicas digitales  
✅ App Flutter v1.0.3 publicada  
✅ Integración completa con Cashea  
✅ Campo motivo en citas  
✅ Sistema de categorías de inventario (Enfermería, Quirófano, UCI, Oficina, Laboratorio)  

---

## 🔄 Flujo de Trabajo Recomendado

1. **Al iniciar**: Lee `NOTAS_PROYECTO.md`
2. **Antes de cambios en BD**: Respalda `javier_ponciano_5.sql`
3. **Después de cambios en BD**: Exporta y actualiza el SQL
4. **Antes de commits**: Verifica que todo funcione
5. **Documenta cambios importantes**: Actualiza `NOTAS_PROYECTO.md`

---

## 💡 Tips Importantes

- 🔒 **Suscripciones**: Obligatorias para agendar citas
- 🔬 **Referencias Lab**: Se seleccionan automáticamente
- 📲 **WhatsApp**: Requiere Evolution API activa
- 📱 **App Flutter**: Versión actual 1.0.3
- 💳 **Cashea**: Integrado para pagos en cuotas
- 🎫 **Tickets**: Formato térmico para laboratorio

---

**Última actualización**: 31/12/2024  
**Proyecto**: Clínica SaludSonrisa  
**Desarrollador**: Javier Ponciano

---

> 💡 **Recuerda**: Siempre consulta `NOTAS_PROYECTO.md` para el contexto más actualizado
