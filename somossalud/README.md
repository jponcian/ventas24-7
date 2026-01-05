# 🏥 Clínica SaludSonrisa - Sistema de Gestión Clínica

Sistema integral de gestión clínica desarrollado con Laravel, que incluye aplicación móvil Flutter y módulos completos para la administración de una clínica médica moderna.

---

## 📋 Descripción del Proyecto

**Clínica SaludSonrisa** es un sistema completo de gestión clínica que integra:

- 🖥️ **Backend Laravel**: Sistema administrativo completo
- 📱 **App Flutter**: Aplicación móvil para pacientes
- 🌐 **Web Móvil**: Portal web responsive para pacientes
- 💬 **Integración WhatsApp**: Notificaciones y recordatorios automáticos
- 🔬 **Módulo de Laboratorio**: Gestión completa de exámenes y resultados
- 💊 **Control de Inventario**: Gestión de materiales y bodega
- 💰 **Sistema de Pagos**: Integración con Cashea para pagos en cuotas

---

## 🚀 Características Principales

### 👥 Gestión de Pacientes
- Registro completo de pacientes con historial médico
- Sistema de suscripciones para acceso a servicios
- Portal del paciente con acceso a resultados y citas
- Gestión de perfiles y datos personales

### 📅 Sistema de Citas Médicas
- Agendamiento de citas por especialidad y doctor
- Recordatorios automáticos por WhatsApp
- Gestión de disponibilidad de médicos
- Historial completo de atenciones
- Campo de motivo de consulta

### 🔬 Módulo de Laboratorio
- **Gestión de Órdenes**: Creación y seguimiento de órdenes de laboratorio
- **Parámetros Inteligentes**: Sistema de referencias por edad y sexo
- **Tipos de Parámetros**: Encabezado, Numérico, Texto
- **Generación de PDFs**: Resultados profesionales en PDF
- **Tickets Térmicos**: Impresión de tickets para órdenes
- **Envío por WhatsApp**: Resultados directamente al paciente
- **Referencias Automáticas**: Selección inteligente según edad/sexo del paciente

### 💊 Gestión de Materiales y Bodega
- Control de inventario en tiempo real
- **Categorías**: Enfermería, Quirófano, UCI, Oficina, Laboratorio
- Sistema de solicitudes y órdenes de compra
- Gestión de proveedores
- Control de stock mínimo y alertas

### 💰 Sistema de Pagos
- Registro de pagos y estado de cuenta
- **Integración Cashea**: Pagos en cuotas sin interés
- Comisiones automáticas
- Reportes de pagos desde app móvil
- Métodos de pago múltiples

### 📲 Notificaciones WhatsApp
- Recordatorios automáticos de citas
- Envío de resultados de laboratorio
- Notificaciones personalizadas
- Integración con Evolution API

### 📊 Reportes y Estadísticas
- Dashboard administrativo
- Reportes de atenciones
- Estadísticas de laboratorio
- Control financiero

---

## 🛠️ Tecnologías Utilizadas

### Backend
- **Framework**: Laravel 10.x
- **Base de Datos**: MySQL/MariaDB
- **Autenticación**: Laravel Sanctum
- **PDF**: DomPDF / Laravel-DomPDF
- **WhatsApp**: Evolution API

### Frontend Web
- **Template Engine**: Blade
- **CSS Framework**: Bootstrap 5 + Custom CSS
- **JavaScript**: Vanilla JS + jQuery
- **Icons**: Font Awesome

### App Móvil
- **Framework**: Flutter
- **Versión Actual**: 1.0.3
- **Plataformas**: Android (APK disponible)

---

## 📁 Estructura del Proyecto

```
somossalud/
├── app/
│   ├── Http/
│   │   ├── Controllers/      # Controladores del sistema
│   │   │   ├── Api/         # API para app móvil
│   │   │   ├── LabOrderController.php
│   │   │   ├── CitaController.php
│   │   │   └── ...
│   │   └── Middleware/
│   ├── Models/              # Modelos Eloquent
│   │   ├── User.php
│   │   ├── Cita.php
│   │   ├── LabOrder.php
│   │   └── ...
│   └── Services/            # Servicios (WhatsApp, etc.)
│
├── resources/
│   └── views/
│       ├── paciente/        # Portal del paciente
│       ├── laboratorio/     # Módulo de laboratorio
│       ├── atenciones/      # Gestión de atenciones
│       ├── administracion/  # Panel administrativo
│       └── layouts/         # Layouts principales
│
├── database/
│   ├── javier_ponciano_5.sql  # Base de datos completa
│   ├── factories/
│   └── seeders/
│
├── routes/
│   ├── web.php             # Rutas web
│   ├── api.php             # API para app móvil
│   └── ...
│
├── app_somossalud/         # Aplicación Flutter
│   ├── lib/
│   │   ├── screens/
│   │   ├── services/
│   │   ├── models/
│   │   └── widgets/
│   └── pubspec.yaml
│
├── mobile/                 # Web móvil responsive
│
└── .agent/                 # Documentación del proyecto
    ├── NOTAS_PROYECTO.md   # ⭐ LEER SIEMPRE AL INICIAR
    ├── notes/              # Notas de sesiones
    └── sql/                # Scripts SQL útiles
```

---

## 🔧 Instalación y Configuración

### Requisitos Previos
- PHP 8.1 o superior
- Composer
- MySQL/MariaDB
- Node.js y NPM
- WAMP/XAMPP/MAMP (para desarrollo local)

### Instalación

1. **Clonar el repositorio**
```bash
git clone [URL_DEL_REPOSITORIO]
cd somossalud
```

2. **Instalar dependencias PHP**
```bash
composer install
```

3. **Instalar dependencias JavaScript**
```bash
npm install
```

4. **Configurar archivo .env**
```bash
cp .env.example .env
php artisan key:generate
```

5. **Configurar base de datos en .env**
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=javier_ponciano_5
DB_USERNAME=root
DB_PASSWORD=
```

6. **Importar base de datos**
```bash
# Importar el archivo SQL en tu gestor de base de datos
# Ubicación: database/javier_ponciano_5.sql
```

7. **Configurar WhatsApp (Evolution API)**
```env
EVOLUTION_API_URL=tu_url_api
EVOLUTION_API_KEY=tu_api_key
EVOLUTION_INSTANCE=tu_instancia
```

8. **Generar enlace simbólico para storage**
```bash
php artisan storage:link
```

9. **Compilar assets**
```bash
npm run dev
# o para producción
npm run build
```

10. **Iniciar servidor de desarrollo**
```bash
php artisan serve
```

---

## 📱 Configuración de la App Flutter

### Desarrollo

1. **Navegar a la carpeta de la app**
```bash
cd app_somossalud
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar URL del backend**
```dart
// lib/services/api_service.dart
static const String baseUrl = 'http://tu-servidor/api';
```

4. **Ejecutar en modo desarrollo**
```bash
flutter run
```

### Generar APK

```bash
flutter build apk --release
# APK ubicado en: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔐 Usuarios y Roles

### Roles del Sistema
- **Administrador**: Acceso completo al sistema
- **Doctor**: Gestión de atenciones y recetas
- **Recepcionista**: Gestión de citas y pacientes
- **Laboratorio**: Gestión de órdenes y resultados
- **Paciente**: Acceso a portal del paciente

### Usuario por Defecto (Desarrollo)
```
Usuario: admin
Contraseña: [configurada en la BD]
```

---

## 📊 Módulos del Sistema

### 1. Dashboard Administrativo
- Resumen de actividades
- Estadísticas en tiempo real
- Accesos rápidos a módulos principales

### 2. Gestión de Pacientes
- CRUD completo de pacientes
- Historial médico
- Sistema de suscripciones
- Estado de cuenta

### 3. Citas Médicas
- Calendario de citas
- Asignación por especialidad
- Recordatorios automáticos
- Gestión de disponibilidad

### 4. Atenciones Médicas
- Registro de atenciones
- Recetas médicas digitales
- Diagnósticos y tratamientos
- Historial completo

### 5. Laboratorio
- Órdenes de laboratorio
- Gestión de parámetros
- Referencias inteligentes
- Resultados en PDF
- Envío por WhatsApp

### 6. Materiales y Bodega
- Control de inventario
- **5 Categorías**: Enfermería, Quirófano, UCI, Oficina, Laboratorio
- Solicitudes de compra
- Órdenes a proveedores
- Alertas de stock

### 7. Pagos y Facturación
- Registro de pagos
- Estado de cuenta
- Comisiones
- Integración Cashea

### 8. Reportes
- Reportes de atenciones
- Estadísticas de laboratorio
- Reportes financieros
- Exportación a Excel/PDF

---

## 🔄 Flujos de Trabajo Principales

### Flujo de Cita Médica
1. Paciente agenda cita (app o web)
2. Sistema valida suscripción activa
3. Se envía recordatorio por WhatsApp
4. Doctor realiza atención
5. Se genera receta digital (si aplica)
6. Paciente puede ver receta en la app

### Flujo de Laboratorio
1. Doctor solicita exámenes
2. Se genera orden de laboratorio
3. Paciente recibe ticket térmico
4. Laboratorio registra resultados
5. Sistema selecciona referencias automáticamente
6. Se genera PDF de resultados
7. Se envía por WhatsApp al paciente
8. Paciente puede ver en la app

### Flujo de Pago
1. Paciente realiza pago
2. Se registra en estado de cuenta
3. Se genera comisión (si aplica)
4. Paciente puede reportar pago desde app
5. Administración valida y aprueba

---

## 🌐 API Endpoints (App Móvil)

### Autenticación
```
POST /api/login
POST /api/register
POST /api/logout
```

### Citas
```
GET  /api/citas
POST /api/citas
GET  /api/especialidades
GET  /api/doctores/{especialidad_id}
```

### Laboratorio
```
GET  /api/lab-orders
GET  /api/lab-orders/{id}
GET  /api/lab-orders/{id}/pdf
```

### Perfil
```
GET  /api/profile
PUT  /api/profile
```

### Pagos
```
GET  /api/payments
POST /api/report-payment
```

---

## 📝 Cambios Recientes (Diciembre 2024)

### ✅ Implementado
- Sistema de referencias inteligentes en laboratorio
- Campo `motivo` en citas médicas
- Sistema completo de categorías de inventario (Enfermería, Quirófano, UCI, Oficina, Laboratorio)
- Envío de resultados por WhatsApp
- Tickets térmicos para laboratorio
- Recetas médicas digitales con URL pública
- App Flutter versión 1.0.3
- Integración completa con Cashea
- Comisiones automáticas en estado de cuenta

### 🔄 En Proceso
- Optimización de consultas de base de datos
- Mejoras en sistema de reportes
- Documentación completa de API

---

## 🐛 Solución de Problemas Comunes

### Error de permisos en storage
```bash
chmod -R 775 storage bootstrap/cache
```

### Error de migraciones
**NOTA**: Este proyecto NO usa migraciones PHP. Todos los cambios se hacen directamente en SQL.
Importar `database/javier_ponciano_5.sql` si necesitas resetear la BD.

### App móvil no conecta
1. Verificar URL del backend en `api_service.dart`
2. Asegurar que el servidor esté corriendo
3. Verificar configuración de CORS en Laravel

### WhatsApp no envía mensajes
1. Verificar configuración de Evolution API en `.env`
2. Validar que la instancia esté activa
3. Revisar logs en `storage/logs/laravel.log`

---

## 📚 Documentación Adicional

- **NOTAS_PROYECTO.md**: ⭐ **LEER SIEMPRE AL INICIAR** - Estado actual del proyecto
- **ROADMAP_APP_PACIENTES.md**: Roadmap de la aplicación móvil
- **CAMBIOS_SESION_30_12_2024.md**: Últimos cambios importantes
- **.agent/notes/**: Notas detalladas de sesiones de trabajo
- **.agent/sql/**: Scripts SQL útiles para mantenimiento

---

## 🤝 Contribución

Este es un proyecto privado para Clínica SaludSonrisa. Para contribuir:

1. Crear una rama para tu feature
2. Realizar cambios y commit
3. Push a la rama
4. Crear Pull Request

---

## 📄 Licencia

Proyecto propietario - Clínica SaludSonrisa © 2024

---

## 👨‍💻 Desarrollador

**Javier Ponciano**
- Proyecto: Clínica SaludSonrisa
- Última actualización: Diciembre 2024

---

## 🆘 Soporte

Para soporte o consultas sobre el sistema:
- Revisar documentación en `.agent/`
- Consultar logs en `storage/logs/`
- Revisar archivo `NOTAS_PROYECTO.md` para contexto actualizado

---

**Nota Importante**: Este sistema está en constante desarrollo. Siempre revisar `NOTAS_PROYECTO.md` para el estado más actualizado del proyecto.
