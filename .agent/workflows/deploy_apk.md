---
description: Generar APK de producción y desplegar en carpeta raíz
---

1. Construir la APK en modo release
   `cd c:\wamp64\www\ponciano\app_bodega; flutter build apk --release`

2. // turbo
   Copiar la APK generada a la raíz del proyecto con el nombre correcto
   `Copy-Item "c:\wamp64\www\ponciano\app_bodega\build\app\outputs\flutter-apk\app-release.apk" "c:\wamp64\www\ponciano\ventas247.apk" -Force`
