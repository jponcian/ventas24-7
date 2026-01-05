<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;

class NewRolesSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Crear roles de laboratorio
        Role::firstOrCreate(['name' => 'laboratorio-resul']);
        
        // Crear rol de almacén jefe
        Role::firstOrCreate(['name' => 'almacen-jefe']);
        
        $this->command->info('✅ Nuevos roles creados exitosamente:');
        $this->command->info('   - laboratorio-resul');
        $this->command->info('   - almacen-jefe');
    }
}
