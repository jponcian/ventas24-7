# App SomosSalud - Pacientes

Aplicación móvil Flutter para pacientes del sistema SomosSalud.

## 📱 Funcionalidades Implementadas

### ✅ Versión Actual (v1.0.0)
- **Login con validación**: Autenticación contra el backend Laravel
- **Dashboard moderno**: Interfaz similar al panel web de pacientes
- **Gestión de sesión**: Persistencia de token y datos de usuario
- **Navegación**: Acceso rápido a funcionalidades principales

### 🚧 Próximamente
- Gestión de citas médicas
- Consulta de resultados de laboratorio
- Edición de perfil
- Gestión de suscripción
- Notificaciones push

## 🛠️ Configuración

### Requisitos Previos
- Flutter SDK (versión 3.9.2 o superior)
- Android Studio / VS Code
- Dispositivo Android o Emulador

### Configurar URL del Backend

Edita el archivo `lib/services/auth_service.dart` y cambia la URL según tu entorno:

```dart
// Para emulador Android
static const String baseUrl = 'http://10.0.2.2/somossalud/public/api';

// Para dispositivo físico (reemplaza con tu IP local)
static const String baseUrl = 'http://192.168.1.XXX/somossalud/public/api';

// Para producción
static const String baseUrl = 'https://clinicasaludsonrisa.com.ve/api';
```

## 🚀 Instalación de Dependencias

```bash
cd app_somossalud
flutter pub get
```

## 📦 Compilar APK

### APK de Desarrollo (Debug)
```bash
flutter build apk --debug
```
El APK se generará en: `build/app/outputs/flutter-apk/app-debug.apk`

### APK de Producción (Release)
```bash
flutter build apk --release
```
El APK se generará en: `build/app/outputs/flutter-apk/app-release.apk`

### APK Optimizado por Arquitectura
Para generar APKs separados por arquitectura (más pequeños):
```bash
flutter build apk --split-per-abi
```
Generará múltiples APKs en `build/app/outputs/flutter-apk/`:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit Intel)

## 🧪 Ejecutar en Modo Desarrollo

### En Emulador
```bash
flutter run
```

### En Dispositivo Físico
1. Habilita "Opciones de Desarrollador" en tu dispositivo Android
2. Activa "Depuración USB"
3. Conecta el dispositivo por USB
4. Ejecuta:
```bash
flutter devices  # Verifica que tu dispositivo esté conectado
flutter run
```

## 📱 Instalar APK en Dispositivo

1. Transfiere el APK a tu dispositivo Android
2. Habilita "Instalar aplicaciones de fuentes desconocidas" en Configuración
3. Abre el archivo APK y sigue las instrucciones de instalación

## 🔧 Comandos Útiles

```bash
# Ver dispositivos conectados
flutter devices

# Limpiar build cache
flutter clean

# Reinstalar dependencias
flutter pub get

# Verificar problemas
flutter doctor

# Ver logs en tiempo real
flutter logs
```

## 📝 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada
├── models/
│   └── user_model.dart      # Modelo de usuario
├── screens/
│   ├── login_screen.dart    # Pantalla de login
│   └── home_screen.dart     # Dashboard principal
└── services/
    └── auth_service.dart    # Servicio de autenticación
```

## 🎨 Diseño

La aplicación utiliza un diseño moderno con:
- Gradientes de color
- Tarjetas con sombras suaves
- Animaciones de transición
- Diseño responsive
- Paleta de colores consistente con el proyecto web

## 🔐 Seguridad

- Tokens de autenticación almacenados de forma segura con SharedPreferences
- Validación de formularios
- Manejo seguro de sesiones
- Logout con confirmación

## 📄 Licencia

Proyecto privado - SomosSalud

## 👥 Contacto

Para soporte técnico, contacta al equipo de desarrollo.
