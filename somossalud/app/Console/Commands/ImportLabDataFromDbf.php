<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ImportLabDataFromDbf extends Command
{
    protected $signature = 'lab:import-dbf';
    protected $description = 'Importar datos de laboratorio desde archivos DBF del sistema viejo';

    public function handle()
    {
        $this->info('=== IMPORTANDO DATOS DE LABORATORIO DESDE DBF ===');
        
        try {
            // Verificar si la extensión dbase está disponible
            if (!function_exists('dbase_open')) {
                $this->error('La extensión dbase no está instalada en PHP.');
                $this->info('Alternativa: Usar el script Python o instalar php-dbase');
                return 1;
            }

            $dbfPath = base_path('SISCAL03/DBF');
            
            if (!file_exists($dbfPath)) {
                $this->error("No se encuentra la carpeta: {$dbfPath}");
                return 1;
            }

            // Importar categorías
            $this->importCategories($dbfPath);
            
            // Importar exámenes
            $this->importExams($dbfPath);
            
            // Importar ítems
            $this->importItems($dbfPath);
            
            $this->info("\n✅ IMPORTACIÓN COMPLETADA EXITOSAMENTE");
            return 0;
            
        } catch (\Exception $e) {
            $this->error("Error: " . $e->getMessage());
            $this->error($e->getTraceAsString());
            return 1;
        }
    }

    private function importCategories($dbfPath)
    {
        $this->info("\n=== IMPORTANDO CATEGORÍAS ===");
        
        $file = $dbfPath . '/LVTTIPO.DBF';
        if (!file_exists($file)) {
            $this->warn("Archivo no encontrado: {$file}");
            return;
        }

        $db = dbase_open($file, 0);
        if (!$db) {
            $this->error("No se pudo abrir: {$file}");
            return;
        }

        $count = 0;
        $numRecords = dbase_numrecords($db);
        
        for ($i = 1; $i <= $numRecords; $i++) {
            $record = dbase_get_record_with_names($db, $i);
            
            if ($record['deleted']) continue;
            
            $code = trim($record['TIP_EXA']);
            $name = trim($record['DES_TIP']);
            
            DB::table('lab_categories')->updateOrInsert(
                ['code' => $code],
                [
                    'name' => $name,
                    'active' => true,
                    'created_at' => now(),
                    'updated_at' => now()
                ]
            );
            
            $count++;
            if ($count <= 10) {
                $this->line("  ✓ {$code} - {$name}");
            }
        }
        
        dbase_close($db);
        $this->info("✓ Total categorías: {$count}");
    }

    private function importExams($dbfPath)
    {
        $this->info("\n=== IMPORTANDO EXÁMENES ===");
        
        $file = $dbfPath . '/LVTEXAM.DBF';
        if (!file_exists($file)) {
            $this->warn("Archivo no encontrado: {$file}");
            return;
        }

        $db = dbase_open($file, 0);
        if (!$db) {
            $this->error("No se pudo abrir: {$file}");
            return;
        }

        $count = 0;
        $numRecords = dbase_numrecords($db);
        
        for ($i = 1; $i <= $numRecords; $i++) {
            $record = dbase_get_record_with_names($db, $i);
            
            if ($record['deleted'] || !$record['STATUS']) continue;
            
            $code = trim($record['COD_EXA']);
            $tipExa = trim($record['TIP_EXA']);
            $name = trim($record['DES_EXA'] ?? '');
            $abbreviation = trim($record['DES_ABR'] ?? '');
            $price = floatval($record['PRE_EX1'] ?? 0);
            
            // Obtener ID de categoría
            $category = DB::table('lab_categories')->where('code', $tipExa)->first();
            $categoryId = $category ? $category->id : null;
            
            DB::table('lab_exams')->updateOrInsert(
                ['code' => $code],
                [
                    'lab_category_id' => $categoryId,
                    'name' => $name,
                    'abbreviation' => $abbreviation,
                    'price' => $price,
                    'active' => true,
                    'created_at' => now(),
                    'updated_at' => now()
                ]
            );
            
            $count++;
            if ($count <= 10) {
                $this->line("  ✓ {$code} - {$name} (\${$price})");
            }
        }
        
        dbase_close($db);
        $this->info("✓ Total exámenes: {$count}");
    }

    private function importItems($dbfPath)
    {
        $this->info("\n=== IMPORTANDO ÍTEMS ===");
        
        $file = $dbfPath . '/LVTPRUE.DBF';
        if (!file_exists($file)) {
            $this->warn("Archivo no encontrado: {$file}");
            return;
        }

        $db = dbase_open($file, 0);
        if (!$db) {
            $this->error("No se pudo abrir: {$file}");
            return;
        }

        $count = 0;
        $numRecords = dbase_numrecords($db);
        
        for ($i = 1; $i <= $numRecords; $i++) {
            $record = dbase_get_record_with_names($db, $i);
            
            if ($record['deleted']) continue;
            
            $codExa = trim($record['COD_EXA']);
            $codPru = trim($record['COD_PRU']);
            $name = trim($record['DES_PRU'] ?? '');
            $unit = trim($record['UNI_RES'] ?? '');
            $type = trim($record['TIP_RES'] ?? 'text');
            $order = intval($record['POS_PRU'] ?? 0);
            
            // Obtener ID del examen
            $exam = DB::table('lab_exams')->where('code', $codExa)->first();
            if (!$exam) continue;
            
            DB::table('lab_exam_items')->updateOrInsert(
                ['lab_exam_id' => $exam->id, 'code' => $codPru],
                [
                    'name' => $name,
                    'unit' => $unit,
                    'type' => $type,
                    'order' => $order,
                    'created_at' => now(),
                    'updated_at' => now()
                ]
            );
            
            $count++;
            if ($count <= 10) {
                $this->line("  ✓ {$codExa}/{$codPru} - {$name}");
            }
        }
        
        dbase_close($db);
        $this->info("✓ Total ítems: {$count}");
    }
}
