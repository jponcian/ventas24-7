# 🚀 Instrucciones para Desplegar en Producción

## 📋 Pasos para Implementar

### 1. **Agregar Campo Teléfono en la Base de Datos**

Ejecuta este SQL en tu base de datos de producción:

```sql
ALTER TABLE `usuarios` 
ADD COLUMN `telefono` VARCHAR(20) NULL 
AFTER `email`;
```

**Verificar**:
```sql
DESCRIBE usuarios;
```

Deberías ver el campo `telefono` después de `email`.

---

### 2. **Subir Archivos al Servidor**

Sube los siguientes archivos nuevos:

```
app/Services/WhatsAppService.php
app/Channels/WhatsAppChannel.php
app/Notifications/CitaRecordatorio.php
app/Console/Commands/EnviarRecordatoriosCitas.php
config/whatsapp.php
```

Archivos modificados que también debes subir:

```
app/Models/User.php
app/Http/Controllers/Admin/UserManagementController.php
app/Console/Kernel.php
resources/views/admin/users/index.blade.php
routes/web.php
```

---

### 3. **Configurar Variables de Entorno**

Agrega al archivo `.env` de producción:

```env
WHATSAPP_ENABLED=true
WHATSAPP_INSTANCE_ID=instance152977
WHATSAPP_TOKEN=35uuhzm4pkblah6q
WHATSAPP_API_URL=https://api.ultramsg.com
```

---

### 4. **Limpiar Caché en Producción**

Ejecuta en el servidor:

```bash
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear
```

---

### 5. **Activar el Scheduler (Recordatorios Automáticos)**

**Verificar que el cron esté configurado**:

Edita el crontab del servidor:
```bash
crontab -e
```

Debe tener esta línea (ajusta la ruta a tu proyecto):
```
* * * * * cd /var/www/somossalud && php artisan schedule:run >> /dev/null 2>&1
```

**Verificar que funciona**:
```bash
php artisan schedule:list
```

Deberías ver:
- `exchange:sync-bcv` (diario a las 09:05)
- `citas:recordatorios` (cada 15 minutos)

---

### 6. **Probar el Sistema**

#### **Prueba 1: Envío Manual de WhatsApp**

1. Agrega un número de teléfono a un usuario:
   ```sql
   UPDATE usuarios SET telefono = '0414-1234567' WHERE id = TU_ID;
   ```

2. Ve al panel de usuarios: `https://tudominio.com/admin/users`

3. Haz clic en el botón verde de WhatsApp

4. Deberías recibir un mensaje

#### **Prueba 2: Recordatorios de Citas** (manual)

```bash
php artisan citas:recordatorios
```

Esto:
- Buscará citas próximas (24h y 2h)
- Enviará recordatorios por email y WhatsApp
- Mostrará en consola el resultado

---

## ✅ Checklist de Verificación

- [ ] Campo `telefono` agregado en la BD
- [ ] Archivos subidos al servidor
- [ ] Variables `.env` configuradas
- [ ] Caché limpiado
- [ ] Crontab configurado
- [ ] Instancia de WhatsApp autenticada (#152977)
- [ ] Prueba manual de WhatsApp exitosa
- [ ] Comando `citas:recordatorios` probado

---

## 🔧 Configuración Adicional Necesaria

### **Agregar Campo Teléfono en Formularios**

Deberás actualizar estos archivos para que se pueda capturar el teléfono al crear/editar usuarios:

1. `resources/views/admin/users/create.blade.php`
2. `resources/views/admin/users/edit.blade.php`
3. `app/Http/Controllers/Admin/UserManagementController.php` (validación)

**Validación sugerida**:
```php
'telefono' => ['nullable', 'regex:/^0(41[24]|42[246])\d{7}$/']
```

**Mensaje de error**:
```php
'telefono.regex' => 'El formato del teléfono debe ser: 0414-1234567 (Movistar, Digitel o Movilnet)'
```

---

## 📱 Operadoras Soportadas

| Operadora | Prefijos |
|-----------|----------|
| Movistar  | 0414, 0424 |
| Digitel   | 0412, 0422 |
| Movilnet  | 0416, 0426 |

**Formatos aceptados**:
- `0414-1234567`
- `04141234567`
- `+584141234567`
- `584141234567`

Todos se convierten automáticamente a: `+584141234567`

---

## 🐛 Troubleshooting Producción

### No se envían los recordatorios automáticamente

1. **Verificar crontab**:
   ```bash
   crontab -l
   ```

2. **Ver últimas ejecuciones**:
   ```bash
   grep CRON /var/log/syslog | tail -20
   ```

3. **Ejecutar manualmente**:
   ```bash
   php artisan citas:recordatorios
   ```

### Errores de WhatsApp

1. **Verificar logs**:
   ```bash
   tail -f storage/logs/laravel.log
   ```

2. **Verificar instancia**:
   - https://api.ultramsg.com/
   - Estado debe ser "authenticated"

3. **Verificar credenciales en `.env`**

---

## 📧 Configuración de Email (si aún no está)

Para que los recordatorios por email funcionen:

```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=tu@email.com
MAIL_PASSWORD=tu_password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@somossalud.com
MAIL_FROM_NAME="SomosSalud"
```

---

## ⚡ Comandos Útiles

```bash
# Ver comandos programados
php artisan schedule:list

# Ejecutar recordatorios manualmente
php artisan citas:recordatorios

# Limpiar todo el caché
php artisan optimize:clear

# Ver rutas de WhatsApp
php artisan route:list --name=whatsapp

# Ver logs en tiempo real
tail -f storage/logs/laravel.log
```

---

## 🎯 Próximos Pasos Recomendados

1. **Agregar campo telefono en formularios de usuario**
2. **Hacer backup de la BD antes de cualquier cambio**
3. **Probar exhaustivamente en local antes de subir**
4. **Documentar cualquier cambio adicional**
5. **Configurar alertas si los recordatorios fallan**

---

¿Necesitas ayuda con algún paso específico? 🚀
