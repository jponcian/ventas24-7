# Plan de Implementación - Mejoras SomosSalud



---

## 2. Filtros avanzados en listado de órdenes

### Archivos a modificar:
1. `resources/views/lab/orders/index.blade.php` - Agregar formulario de filtros
2. `app/Http/Controllers/LabOrderController.php` - Método `index()` con filtros

### Filtros a implementar:
- **Rango de fechas**: Desde/Hasta
- **Estado**: Pendiente, En Proceso, Completada
- **Paciente**: Búsqueda por nombre o cédula
- **Clínica**: Filtro por clínica
- **Número de orden**: Búsqueda exacta

### Código sugerido:
```php
// En LabOrderController::index()
public function index(Request $request)
{
    $query = LabOrder::with(['patient', 'clinica', 'details']);
    
    // Filtro por fecha
    if ($request->filled('fecha_desde')) {
        $query->whereDate('order_date', '>=', $request->fecha_desde);
    }
    if ($request->filled('fecha_hasta')) {
        $query->whereDate('order_date', '<=', $request->fecha_hasta);
    }
    
    // Filtro por estado
    if ($request->filled('status')) {
        $query->where('status', $request->status);
    }
    
    // Filtro por paciente
    if ($request->filled('paciente')) {
        $query->whereHas('patient', function($q) use ($request) {
            $q->where('name', 'like', '%' . $request->paciente . '%')
              ->orWhere('cedula', 'like', '%' . $request->paciente . '%');
        });
    }
    
    // Filtro por clínica
    if ($request->filled('clinica_id')) {
        $query->where('clinica_id', $request->clinica_id);
    }
    
    // Filtro por número de orden
    if ($request->filled('order_number')) {
        $query->where('order_number', 'like', '%' . $request->order_number . '%');
    }
    
    $orders = $query->latest()->paginate(20)->withQueryString();
    $clinicas = Clinica::all();
    
    return view('lab.orders.index', compact('orders', 'clinicas'));
}
```

---

## 3. Indicadores visuales de estado de órdenes

### Badges de estado con colores:
```html
@switch($order->status)
    @case('pending')
        <span class="badge badge-warning">
            <i class="fas fa-clock"></i> Pendiente
        </span>
        @break
    @case('in_progress')
        <span class="badge badge-info">
            <i class="fas fa-spinner fa-pulse"></i> En Proceso
        </span>
        @break
    @case('completed')
        <span class="badge badge-success">
            <i class="fas fa-check-circle"></i> Completada
        </span>
        @break
@endswitch
```

### Indicadores adicionales:
- **Tiempo transcurrido**: Mostrar días desde la creación
- **Prioridad**: Resaltar órdenes antiguas pendientes
- **Notificación enviada**: Icono de WhatsApp verde si se envió

---

## 4. Dashboard de estadísticas

### Archivo a crear:
`app/Http/Controllers/DashboardController.php`

### Estadísticas a mostrar:

#### A. Órdenes por día/mes
```php
// Órdenes del mes actual
$ordenesMes = LabOrder::whereMonth('order_date', now()->month)
    ->whereYear('order_date', now()->year)
    ->count();

// Órdenes por día (últimos 30 días)
$ordenesPorDia = LabOrder::selectRaw('DATE(order_date) as fecha, COUNT(*) as total')
    ->where('order_date', '>=', now()->subDays(30))
    ->groupBy('fecha')
    ->orderBy('fecha')
    ->get();
```

#### B. Exámenes más solicitados
```php
$examenesMasSolicitados = LabOrderDetail::selectRaw('lab_exam_id, COUNT(*) as total')
    ->with('exam')
    ->groupBy('lab_exam_id')
    ->orderByDesc('total')
    ->limit(10)
    ->get();
```

#### C. Tiempo promedio de entrega
```php
$tiempoPromedio = LabOrder::whereNotNull('result_date')
    ->selectRaw('AVG(DATEDIFF(result_date, order_date)) as promedio_dias')
    ->first()
    ->promedio_dias;
```

#### D. Gráficos con Chart.js
```html
<canvas id="ordenesChart"></canvas>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
const ctx = document.getElementById('ordenesChart');
new Chart(ctx, {
    type: 'line',
    data: {
        labels: @json($ordenesPorDia->pluck('fecha')),
        datasets: [{
            label: 'Órdenes por día',
            data: @json($ordenesPorDia->pluck('total')),
            borderColor: 'rgb(75, 192, 192)',
            tension: 0.1
        }]
    }
});
</script>
```

---

## 5. Backup y Recuperación

### A. Backups automáticos diarios de BD

#### Opción 1: Laravel Backup Package (Recomendado)
```bash
composer require spatie/laravel-backup
php artisan vendor:publish --provider="Spatie\Backup\BackupServiceProvider"
```

**Configuración en `config/backup.php`:**
```php
'backup' => [
    'name' => 'somossalud',
    'source' => [
        'files' => [
            'include' => [
                base_path(),
            ],
            'exclude' => [
                base_path('vendor'),
                base_path('node_modules'),
            ],
        ],
        'databases' => [
            'mysql',
        ],
    ],
    'destination' => [
        'disks' => [
            'local',
            's3', // o 'google'
        ],
    ],
],
```

**Programar backup diario en `app/Console/Kernel.php`:**
```php
protected function schedule(Schedule $schedule)
{
    $schedule->command('backup:clean')->daily()->at('01:00');
    $schedule->command('backup:run')->daily()->at('02:00');
}
```

#### Opción 2: Script personalizado
```php
// app/Console/Commands/DatabaseBackup.php
namespace App\Console\Commands;

use Illuminate\Console\Command;
use Carbon\Carbon;

class DatabaseBackup extends Command
{
    protected $signature = 'db:backup';
    protected $description = 'Crear backup de la base de datos';

    public function handle()
    {
        $filename = "backup-" . Carbon::now()->format('Y-m-d-His') . ".sql";
        $path = storage_path('app/backups/' . $filename);
        
        // Crear directorio si no existe
        if (!file_exists(storage_path('app/backups'))) {
            mkdir(storage_path('app/backups'), 0755, true);
        }
        
        $command = sprintf(
            'mysqldump -u%s -p%s %s > %s',
            env('DB_USERNAME'),
            env('DB_PASSWORD'),
            env('DB_DATABASE'),
            $path
        );
        
        exec($command);
        
        $this->info("Backup creado: {$filename}");
        
        // Comprimir
        exec("gzip {$path}");
        
        // Eliminar backups antiguos (más de 30 días)
        $this->cleanOldBackups();
    }
    
    private function cleanOldBackups()
    {
        $files = glob(storage_path('app/backups/*.sql.gz'));
        $now = time();
        
        foreach ($files as $file) {
            if ($now - filemtime($file) >= 30 * 24 * 3600) {
                unlink($file);
            }
        }
    }
}
```

### B. Backups en ubicación externa

#### Opción 1: Amazon S3
```bash
composer require league/flysystem-aws-s3-v3
```

**Configuración en `.env`:**
```env
AWS_ACCESS_KEY_ID=your-key
AWS_SECRET_ACCESS_KEY=your-secret
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=somossalud-backups
```

**Configuración en `config/filesystems.php`:**
```php
's3' => [
    'driver' => 's3',
    'key' => env('AWS_ACCESS_KEY_ID'),
    'secret' => env('AWS_SECRET_ACCESS_KEY'),
    'region' => env('AWS_DEFAULT_REGION'),
    'bucket' => env('AWS_BUCKET'),
],
```

#### Opción 2: Google Drive
```bash
composer require nao-pon/flysystem-google-drive
```

**Configuración:**
1. Crear proyecto en Google Cloud Console
2. Habilitar Google Drive API
3. Crear credenciales OAuth 2.0
4. Descargar JSON de credenciales

**Configuración en `config/filesystems.php`:**
```php
'google' => [
    'driver' => 'google',
    'clientId' => env('GOOGLE_DRIVE_CLIENT_ID'),
    'clientSecret' => env('GOOGLE_DRIVE_CLIENT_SECRET'),
    'refreshToken' => env('GOOGLE_DRIVE_REFRESH_TOKEN'),
    'folderId' => env('GOOGLE_DRIVE_FOLDER_ID'),
],
```

#### Script para subir a nube
```php
// Después de crear el backup local
use Illuminate\Support\Facades\Storage;

$localPath = 'backups/' . $filename . '.gz';
$cloudPath = 'backups/' . Carbon::now()->format('Y/m/') . $filename . '.gz';

// Subir a S3
Storage::disk('s3')->put($cloudPath, Storage::disk('local')->get($localPath));

// O subir a Google Drive
Storage::disk('google')->put($cloudPath, Storage::disk('local')->get($localPath));

$this->info("Backup subido a la nube");
```

### C. Restauración de backups

#### Script de restauración:
```php
// app/Console/Commands/DatabaseRestore.php
namespace App\Console\Commands;

use Illuminate\Console\Command;

class DatabaseRestore extends Command
{
    protected $signature = 'db:restore {file}';
    protected $description = 'Restaurar base de datos desde backup';

    public function handle()
    {
        $file = $this->argument('file');
        $path = storage_path('app/backups/' . $file);
        
        if (!file_exists($path)) {
            $this->error("Archivo no encontrado: {$file}");
            return 1;
        }
        
        // Descomprimir si es .gz
        if (str_ends_with($file, '.gz')) {
            exec("gunzip -c {$path} > " . str_replace('.gz', '', $path));
            $path = str_replace('.gz', '', $path);
        }
        
        if (!$this->confirm('¿Está seguro de restaurar la base de datos? Esto sobrescribirá todos los datos actuales.')) {
            return 0;
        }
        
        $command = sprintf(
            'mysql -u%s -p%s %s < %s',
            env('DB_USERNAME'),
            env('DB_PASSWORD'),
            env('DB_DATABASE'),
            $path
        );
        
        exec($command);
        
        $this->info("Base de datos restaurada exitosamente");
    }
}
```

### D. Monitoreo de backups

#### Notificación por email si falla el backup:
```php
use Illuminate\Support\Facades\Mail;

try {
    // Código de backup
    $this->info("Backup exitoso");
} catch (\Exception $e) {
    Mail::to('admin@somossalud.com')->send(new BackupFailedMail($e->getMessage()));
    $this->error("Error en backup: " . $e->getMessage());
}
```

### E. Mejores prácticas

1. **Frecuencia**: Backups diarios a las 2:00 AM
2. **Retención**: Mantener últimos 30 días localmente
3. **Nube**: Mantener últimos 90 días en S3/Google Drive
4. **Verificación**: Probar restauración mensualmente
5. **Encriptación**: Encriptar backups antes de subir a la nube
6. **Múltiples ubicaciones**: Local + S3 + Google Drive (redundancia)

---

## Prioridad de implementación:


2. **Filtros avanzados** - 2-3 horas
3. **Indicadores visuales** - 1 hora
4. **Dashboard de estadísticas** - 4-6 horas
5. **Backups automáticos** - 2-3 horas (configuración inicial)

**Tiempo total estimado**: 10-14 horas de desarrollo
