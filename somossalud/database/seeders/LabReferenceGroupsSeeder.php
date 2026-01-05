<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\LabReferenceGroup;
use Illuminate\Support\Facades\DB;

class LabReferenceGroupsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $groups = [
            // --- GRUPOS LEGACY (Renombrados para consistencia) ---
            [
                'code' => 'M001',
                'description' => 'UNIVERSAL - Todos',
                'sex' => 3, 'age_start_year' => 0, 'age_end_year' => 120
            ],
            [
                'code' => 'M002',
                'description' => 'INFANTES - Todos', // Antes: INFANTES
                'sex' => 3, 'age_start_year' => 0, 'age_end_year' => 1
            ],
            [
                'code' => 'M003',
                'description' => 'NEONATOS - Todos', // Antes: NEONATOS
                'sex' => 3, 'age_start_year' => 0, 'age_end_year' => 0 // Dias 1-2
            ],
            [
                'code' => 'M004',
                'description' => 'HOMBRES - Masculino', // Antes: HOMBRES
                'sex' => 1, 'age_start_year' => 0, 'age_end_year' => 120
            ],
            [
                'code' => 'M005',
                'description' => 'MUJERES - Femenino', // Antes: MUJERES
                'sex' => 2, 'age_start_year' => 0, 'age_end_year' => 120
            ],
            [
                'code' => 'M010',
                'description' => 'NIÑOS - Todos', // Antes: NIÑOS
                'sex' => 3, 'age_start_year' => 1, 'age_end_year' => 13
            ],
            [
                'code' => 'M023',
                'description' => 'ADULTOS - Todos', // Antes: ADULTOS
                'sex' => 3, 'age_start_year' => 14, 'age_end_year' => 120
            ],
            [
                'code' => 'M024',
                'description' => 'RECIEN NACIDOS - Todos', // Antes: RECIEN NACIDOS
                'sex' => 3, 'age_start_year' => 0, 'age_end_year' => 0 // Dias 3-30
            ],

            // --- GRUPOS NUEVOS (Por Rango de Edad) ---
            // Hombres por grupos de edad
            [
                'code' => 'M100',
                'description' => 'ADULTOS JOVENES - Masculino',
                'sex' => 1, 'age_start_year' => 18, 'age_end_year' => 30,
            ],
            [
                'code' => 'M101',
                'description' => 'ADULTOS - Masculino',
                'sex' => 1, 'age_start_year' => 31, 'age_end_year' => 50,
            ],
            [
                'code' => 'M102',
                'description' => 'ADULTOS MADUROS - Masculino',
                'sex' => 1, 'age_start_year' => 51, 'age_end_year' => 70,
            ],
            [
                'code' => 'M103',
                'description' => 'ADULTOS MAYORES - Masculino',
                'sex' => 1, 'age_start_year' => 71, 'age_end_year' => 120,
            ],
            
            // Mujeres por grupos de edad
            [
                'code' => 'M104',
                'description' => 'ADULTOS JOVENES - Femenino',
                'sex' => 2, 'age_start_year' => 18, 'age_end_year' => 30,
            ],
            [
                'code' => 'M105',
                'description' => 'ADULTOS - Femenino',
                'sex' => 2, 'age_start_year' => 31, 'age_end_year' => 50,
            ],
            [
                'code' => 'M106',
                'description' => 'ADULTOS MADUROS - Femenino',
                'sex' => 2, 'age_start_year' => 51, 'age_end_year' => 70,
            ],
            [
                'code' => 'M107',
                'description' => 'ADULTOS MAYORES - Femenino',
                'sex' => 2, 'age_start_year' => 71, 'age_end_year' => 120,
            ],

            // Mujeres en edad fértil
            [
                'code' => 'M108',
                'description' => 'MUJERES EDAD FERTIL - Femenino',
                'sex' => 2, 'age_start_year' => 15, 'age_end_year' => 45,
            ],
            [
                'code' => 'M109',
                'description' => 'MUJERES PREMENOPAUSIA - Femenino',
                'sex' => 2, 'age_start_year' => 40, 'age_end_year' => 50,
            ],
            [
                'code' => 'M110',
                'description' => 'MUJERES POSTMENOPAUSIA - Femenino',
                'sex' => 2, 'age_start_year' => 51, 'age_end_year' => 120,
            ],
        ];

        foreach ($groups as $group) {
            
            // Intentar encontrar por CÓDIGO primero (para renombrar)
            $existing = LabReferenceGroup::where('code', $group['code'])->first();
            
            if ($existing) {
                $existing->update([
                    'description' => $group['description'],
                    'sex' => $group['sex'],
                    'age_start_year' => $group['age_start_year'],
                    'age_end_year' => $group['age_end_year'],
                    'active' => true,
                ]);
            } else {
                // Si no existe por código, intentar buscar por descripción antigua para evitar duplicados
                // (Caso extremo donde el código no coincida pero el nombre sí)
                LabReferenceGroup::updateOrCreate(
                    ['description' => $group['description']], 
                    [
                        'code' => $group['code'],
                        'sex' => $group['sex'],
                        'age_start_year' => $group['age_start_year'],
                        'age_end_year' => $group['age_end_year'],
                        'active' => true,
                    ]
                );
            }
        }

        // --- RENOMBRAR GRUPOS "VALOR-X" Y "NIÑOS-X" A NOMBRES AMIGABLES ---
        // El usuario solicitó mejorar descripciones como "VALOR1-FEME"
        
        // --- GRUPOS DE CONFIGURACIÓN MANUAL (Consolidados) ---
        $manualGroups = [
            ['code' => 'M900', 'description' => 'GENERAL - Manual', 'sex' => 3, 'age_start_year' => 0, 'age_end_year' => 0],
            ['code' => 'M901', 'description' => 'MUJERES - Manual', 'sex' => 2, 'age_start_year' => 0, 'age_end_year' => 0],
            ['code' => 'M902', 'description' => 'HOMBRES - Manual', 'sex' => 1, 'age_start_year' => 0, 'age_end_year' => 0],
            ['code' => 'M903', 'description' => 'NIÑOS - Manual', 'sex' => 3, 'age_start_year' => 0, 'age_end_year' => 13],
        ];

        foreach ($manualGroups as $g) {
            LabReferenceGroup::updateOrCreate(
                ['description' => $g['description']],
                $g
            );
        }

        $this->command->info('Grupos de referencia de laboratorio actualizados exitosamente.');
    }
}
