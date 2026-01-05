# 📱 GUÍA RÁPIDA - Generar APK de SomosSalud

## ✅ Estado Actual

La aplicación está **LISTA PARA PRODUCCIÓN** con:
- ✅ Login funcional validado contra tu servidor
- ✅ Dashboard moderno
- ✅ URL configurada: `https://clinicasaludsonrisa.com.ve/api`
- ✅ Código sin errores

## 🚀 Opción 1: Compilar con Script (MÁS FÁCIL)

1. Haz doble clic en el archivo: **`compilar_apk.bat`**
2. Espera 5-10 minutos (es normal que tarde)
3. El APK estará en: `build\app\outputs\flutter-apk\app-release.apk`

## 🛠️ Opción 2: Compilar Manualmente

Abre PowerShell o CMD en esta carpeta y ejecuta:

```bash
# Paso 1: Limpiar
flutter clean

# Paso 2: Instalar dependencias
flutter pub get

# Paso 3: Compilar APK
flutter build apk --release
```

**Tiempo estimado:** 5-15 minutos (primera vez puede tardar más)

## 📦 Ubicación del APK

Después de compilar, el APK estará en:
```
build\app\outputs\flutter-apk\app-release.apk
```

**Tamaño aproximado:** 20-30 MB

## 📱 Instalar en tu Teléfono

1. Copia el archivo `app-release.apk` a tu teléfono
2. En tu teléfono, ve a **Configuración > Seguridad**
3. Habilita **"Instalar aplicaciones de fuentes desconocidas"**
4. Abre el archivo APK desde tu teléfono
5. Toca **"Instalar"**

## 🔐 Probar el Login

Usa las credenciales de un paciente existente en tu base de datos:
- Email: (correo de un paciente)
- Contraseña: (su contraseña)

La app se conectará a: `https://clinicasaludsonrisa.com.ve/api`

## ⚠️ Problemas Comunes

### El APK tarda mucho en compilar
- Es normal la primera vez (puede tardar 10-15 minutos)
- Asegúrate de tener buena conexión a internet
- Gradle descarga dependencias en segundo plano

### Error "Developer Mode not enabled"
1. Presiona `Windows + I` para abrir Configuración
2. Ve a **"Actualización y seguridad" > "Para desarrolladores"**
3. Activa **"Modo de desarrollador"**
4. Intenta compilar de nuevo

### Error de conexión al probar la app
- Verifica que `https://clinicasaludsonrisa.com.ve` esté accesible
- Verifica que la ruta `/api/login` funcione
- Prueba en un navegador: `https://clinicasaludsonrisa.com.ve/api/tasa`

## 🔄 Cambiar URL del Backend

Si necesitas cambiar la URL (por ejemplo, para pruebas locales):

1. Abre: `lib\services\auth_service.dart`
2. Busca la línea: `static const String baseUrl = ...`
3. Cámbiala según necesites:
   - Local: `'http://192.168.1.XXX/somossalud/public/api'`
   - Producción: `'https://clinicasaludsonrisa.com.ve/api'`
4. Vuelve a compilar el APK

## 📊 Versión Actual

- **Versión:** 1.0.0+1
- **Nombre:** paciente_app
- **Plataforma:** Android
- **SDK mínimo:** Android 5.0 (API 21)

## 🎯 Próximos Pasos

Una vez que valides que el login funciona correctamente, podemos agregar:
1. Gestión de citas
2. Resultados de laboratorio
3. Edición de perfil
4. Gestión de suscripción

## 📞 Soporte

Si tienes problemas, verifica:
1. ✅ Flutter instalado: `flutter doctor`
2. ✅ Internet activo
3. ✅ Servidor de producción funcionando
4. ✅ Credenciales de paciente válidas

---

**Última actualización:** 17 de Diciembre, 2025
