<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Material;

class MaterialesInventarioSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $materiales = [
            // Medicamentos
            ['nombre' => 'Paracetamol 500mg', 'categoria' => 'Medicamentos', 'unidad_medida' => 'Tableta', 'stock_minimo' => 100],
            ['nombre' => 'Ibuprofeno 400mg', 'categoria' => 'Medicamentos', 'unidad_medida' => 'Tableta', 'stock_minimo' => 100],
            ['nombre' => 'Amoxicilina 500mg', 'categoria' => 'Medicamentos', 'unidad_medida' => 'Cápsula', 'stock_minimo' => 50],
            ['nombre' => 'Omeprazol 20mg', 'categoria' => 'Medicamentos', 'unidad_medida' => 'Cápsula', 'stock_minimo' => 50],
            ['nombre' => 'Loratadina 10mg', 'categoria' => 'Medicamentos', 'unidad_medida' => 'Tableta', 'stock_minimo' => 50],
            
            // Material médico
            ['nombre' => 'Jeringa 5ml', 'categoria' => 'Material Médico', 'unidad_medida' => 'Unidad', 'stock_minimo' => 200],
            ['nombre' => 'Jeringa 10ml', 'categoria' => 'Material Médico', 'unidad_medida' => 'Unidad', 'stock_minimo' => 200],
            ['nombre' => 'Aguja 21G', 'categoria' => 'Material Médico', 'unidad_medida' => 'Unidad', 'stock_minimo' => 300],
            ['nombre' => 'Aguja 23G', 'categoria' => 'Material Médico', 'unidad_medida' => 'Unidad', 'stock_minimo' => 300],
            ['nombre' => 'Catéter IV 18G', 'categoria' => 'Material Médico', 'unidad_medida' => 'Unidad', 'stock_minimo' => 50],
            ['nombre' => 'Catéter IV 20G', 'categoria' => 'Material Médico', 'unidad_medida' => 'Unidad', 'stock_minimo' => 50],
            ['nombre' => 'Guantes de látex M', 'categoria' => 'Material Médico', 'unidad_medida' => 'Caja', 'stock_minimo' => 20],
            ['nombre' => 'Guantes de látex L', 'categoria' => 'Material Médico', 'unidad_medida' => 'Caja', 'stock_minimo' => 20],
            ['nombre' => 'Mascarilla quirúrgica', 'categoria' => 'Material Médico', 'unidad_medida' => 'Caja', 'stock_minimo' => 30],
            ['nombre' => 'Gasas estériles 10x10', 'categoria' => 'Material Médico', 'unidad_medida' => 'Paquete', 'stock_minimo' => 50],
            ['nombre' => 'Vendas elásticas 10cm', 'categoria' => 'Material Médico', 'unidad_medida' => 'Unidad', 'stock_minimo' => 30],
            ['nombre' => 'Esparadrapo 2.5cm', 'categoria' => 'Material Médico', 'unidad_medida' => 'Rollo', 'stock_minimo' => 20],
            
            // Insumos de laboratorio
            ['nombre' => 'Tubos de ensayo', 'categoria' => 'Laboratorio', 'unidad_medida' => 'Caja', 'stock_minimo' => 10],
            ['nombre' => 'Tubos vacutainer tapa roja', 'categoria' => 'Laboratorio', 'unidad_medida' => 'Caja', 'stock_minimo' => 15],
            ['nombre' => 'Tubos vacutainer tapa lila', 'categoria' => 'Laboratorio', 'unidad_medida' => 'Caja', 'stock_minimo' => 15],
            ['nombre' => 'Portaobjetos', 'categoria' => 'Laboratorio', 'unidad_medida' => 'Caja', 'stock_minimo' => 5],
            ['nombre' => 'Cubreobjetos', 'categoria' => 'Laboratorio', 'unidad_medida' => 'Caja', 'stock_minimo' => 5],
            ['nombre' => 'Alcohol isopropílico', 'categoria' => 'Laboratorio', 'unidad_medida' => 'Litro', 'stock_minimo' => 5],
            
            // Insumos de limpieza
            ['nombre' => 'Alcohol en gel', 'categoria' => 'Limpieza', 'unidad_medida' => 'Litro', 'stock_minimo' => 10],
            ['nombre' => 'Desinfectante multiusos', 'categoria' => 'Limpieza', 'unidad_medida' => 'Litro', 'stock_minimo' => 10],
            ['nombre' => 'Papel toalla', 'categoria' => 'Limpieza', 'unidad_medida' => 'Paquete', 'stock_minimo' => 20],
            ['nombre' => 'Jabón líquido antibacterial', 'categoria' => 'Limpieza', 'unidad_medida' => 'Litro', 'stock_minimo' => 10],
            ['nombre' => 'Bolsas de basura rojas', 'categoria' => 'Limpieza', 'unidad_medida' => 'Paquete', 'stock_minimo' => 10],
            ['nombre' => 'Bolsas de basura negras', 'categoria' => 'Limpieza', 'unidad_medida' => 'Paquete', 'stock_minimo' => 10],
            
            // Material de oficina
            ['nombre' => 'Papel bond carta', 'categoria' => 'Oficina', 'unidad_medida' => 'Resma', 'stock_minimo' => 5],
            ['nombre' => 'Papel bond oficio', 'categoria' => 'Oficina', 'unidad_medida' => 'Resma', 'stock_minimo' => 5],
            ['nombre' => 'Bolígrafos azules', 'categoria' => 'Oficina', 'unidad_medida' => 'Caja', 'stock_minimo' => 3],
            ['nombre' => 'Carpetas manila', 'categoria' => 'Oficina', 'unidad_medida' => 'Paquete', 'stock_minimo' => 5],
            ['nombre' => 'Grapas', 'categoria' => 'Oficina', 'unidad_medida' => 'Caja', 'stock_minimo' => 5],
        ];

        foreach ($materiales as $index => $material) {
            Material::create([
                'codigo' => 'MAT-' . str_pad($index + 1, 4, '0', STR_PAD_LEFT),
                'nombre' => $material['nombre'],
                'categoria_default' => $material['categoria'],
                'unidad_medida_default' => $material['unidad_medida'],
                'stock_minimo' => $material['stock_minimo'],
                'activo' => true,
            ]);
        }
    }
}
