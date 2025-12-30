Cashea - módulo independiente

Descripción

Carpeta `cashea` contiene un pequeño módulo PHP para gestionar compras, cuotas y pagos.

Instalación mínima

1. Copia `config.sample.php` a `config.php` y ajusta las credenciales de tu MySQL local.
2. Asegúrate de que tu servidor web tenga permisos de lectura/escritura donde corresponda.
3. Importa las tablas necesarias (compras, pagos, users). El proyecto asume estas tablas con columnas usadas en `db.php`.

Archivos importantes

- `index.php` - interfaz frontend con calendario y modales.
- `db.php` - funciones de acceso a la base de datos.
- `api/` - endpoints JSON para autenticación y operaciones CRUD.

Notas de seguridad

- `config.php` no está versionado por defecto (ver `.gitignore`).
- No expongas credenciales en repositorios públicos.
