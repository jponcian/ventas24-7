# Sistema de Notificaciones WhatsApp y Recordatorios de Citas

## ✅ Implementación Completada

### 1. Campo de Teléfono en Usuarios
- ✅ Migración creada y ejecutada
- ✅ Campo `telefono` agregado a la tabla `usuarios`
- ✅ Modelo `User` actualizado con el campo en `fillable`

### 2. Formato de Números Venezolanos
El sistema acepta y formatea automáticamente números de las siguientes operadoras:
- **Movistar**: 0414, 0424
- **Digitel**: 0412, 0422
- **Movilnet**: 0416, 0426

**Formatos aceptados**:
- Local: `0414-1234567`, `04141234567`
- Internacional: `+584141234567`, `584141234567`

**Todos se convierten a**: `+584141234567` (formato WhatsApp)

### 3. Botón de WhatsApp en Gestión de Usuarios
- ✅ Botón solo visible para roles: `super-admin` y `admin_clinica`
- ✅ Envía mensaje al teléfono del usuario seleccionado
- ✅ Valida que el usuario tenga teléfono registrado
- ✅ Valida formato del número
- ✅ Muestra alertas de éxito/error

### 4. Sistema de Recordatorios de Citas

#### 4.1 Notificaciones
**Archivo**: `app/Notifications/CitaRecordatorio.php`

Envía recordatorios por:
- ✅ Email (siempre)
- ✅ WhatsApp (si está habilitado y el usuario tiene teléfono)

**Tipos de recordatorio**:
- `24h`: Un día antes de la cita
- `2h`: Dos horas antes de la cita

#### 4.2 Canal Personalizado de WhatsApp
**Archivo**: `app/Channels/WhatsAppChannel.php`

- Integra el `WhatsAppService`
- Formatea automáticamente los números
- Maneja errores y los registra en logs

#### 4.3 Comando Programado
**Archivo**: `app/Console/Commands/EnviarRecordatoriosCitas.php`
**Comando**: `php artisan citas:recordatorios`

- Busca citas programadas para dentro de 24 horas
- Busca citas programadas para dentro de 2 horas
- Envía notificaciones a los pacientes
- Registra el resultado de cada envío

#### 4.4 Automatización
**Archivo**: `app/Console/Kernel.php`

El comando se ejecuta **automáticamente cada 15 minutos**.

---

## 🚀 Cómo Usar

### 1. Enviar WhatsApp Manualmente desde Panel de Usuarios

1. Ir a: `http://localhost/somossalud/public/admin/users`
2. Buscar un usuario que tenga teléfono registrado
3. Hacer clic en el botón verde de WhatsApp
4. El sistema enviará un mensaje de prueba

### 2. Probar Recordatorios de Citas (Manual)

```bash
php artisan citas:recordatorios
```

Este comando:
- Buscará citas próximas
- Enviará recordatorios por email y WhatsApp
- Mostrará en consola el resultado

### 3. Activar el Scheduler (Producción)

Para que los recordatorios se envíen automáticamente, ejecuta:

```bash
php artisan schedule:work
```

O en producción, agrega al crontab:
```
* * * * * cd /path-to-your-project && php artisan schedule:run >> /dev/null 2>&1
```

---

## 📋 Requisitos para que Funcione

### Variables de Entorno (.env)
```env
WHATSAPP_ENABLED=true
WHATSAPP_INSTANCE_ID=instance152977
WHATSAPP_TOKEN=35uuhzm4pkblah6q
WHATSAPP_API_URL=https://api.ultramsg.com

# Para emails
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=tu@email.com
MAIL_PASSWORD=tu_password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@somossalud.com
MAIL_FROM_NAME="SomosSalud"
```

### Instancia de WhatsApp
- Tu instancia #152977 debe estar **authenticated** (conectada)
- Verifica en: https://api.ultramsg.com/

### Usuarios con Teléfono
- Los usuarios deben tener el campo `telefono` lleno
- Formato: `0414-1234567` o `+584141234567`

---

## 📨 Mensajes que se Envían

### Recordatorio 24 Horas Antes

**Email**: Mensaje formal con botón para ver la cita

**WhatsApp**:
```
🏥 *SomosSalud - Recordatorio de Cita*

Hola [Nombre] 👋

Te recordamos que tienes una cita médica *mañana*.

📅 *Fecha y hora:* 02/12/2025 10:30
👨‍⚕️ *Especialista:* Dr. Juan Pérez
🏥 *Clínica:* SomosSalud

⏰ *Por favor llega 15 minutos antes.*

Si necesitas cancelar o reprogramar, házlo con anticipación.

_Gracias por confiar en SomosSalud_ 💚
```

### Recordatorio 2 Horas Antes

Igual que el anterior, pero dice "en 2 horas" en lugar de "mañana".

---

## 🔧 Próximos Pasos (Futuro)

1. **Agregar campo telefono en formularios**:
   - `create.blade.php` de usuarios
   - `edit.blade.php` de usuarios
   
2. **Validación del formato**:
   - En el controlador `UserManagementController`
   - Regex: `/^0(4(1[246]|2[46]))\d{7}$/`

3. **Otros recordatorios**:
   - Resultados de laboratorio listos
   - Pagos aprobados/rechazados
   - Stock bajo de inventario

4. **Panel de configuración**:
   - Activar/desactivar recordatorios por WhatsApp
   - Personalizar mensajes
   - Horarios de envío

---

## 🐛 Troubleshooting

### No llegan los recordatorios

1. **Verificar scheduler**:
   ```bash
   php artisan schedule:list
   ```
   Debe aparecer: `citas:recordatorios`

2. **Ejecutar manualmente**:
   ```bash
   php artisan citas:recordatorios
   ```

3. **Revisar logs**:
   ```bash
   tail -f storage/logs/laravel.log
   ```

### Los mensajes de WhatsApp fallan

1. **Verificar instancia**:
   - Ir a https://api.ultramsg.com/
   - Estado debe ser "authenticated"

2. **Verificar formato de teléfono**:
   - Debe ser: `+584141234567`
   - Revisar logs para ver el número formateado

3. **Verificar credenciales**:
   - `WHATSAPP_INSTANCE_ID` correcto
   - `WHATSAPP_TOKEN` correcto

---

## 📝 Archivos Creados/Modificados

### Nuevos
- `database/migrations/2025_12_01_184054_add_telefono_to_usuarios_table.php`
- `app/Services/WhatsAppService.php`
- `app/Channels/WhatsAppChannel.php`
- `app/Notifications/CitaRecordatorio.php`
- `app/Console/Commands/EnviarRecordatoriosCitas.php`
- `config/whatsapp.php`

### Modificados
- `app/Models/User.php` - Agregado campo telefono
- `app/Http/Controllers/Admin/UserManagementController.php` - Método sendWhatsAppTest
- `app/Console/Kernel.php` - Programación del comando
- `resources/views/admin/users/index.blade.php` - Botón WhatsApp
- `routes/web.php` - Ruta whatsapp-test
