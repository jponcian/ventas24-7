<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Spatie\Permission\Models\Role;

class MigrateOldRolesToNewRolesSeeder extends Seeder
{
    /**
     * Migrar usuarios de roles antiguos a nuevos roles
     */
    public function run(): void
    {
        $this->command->info('🔄 Iniciando migración de roles...');

        // Mapeo de roles antiguos a nuevos
        $roleMigrations = [
            'jefe-almacen' => 'almacen-jefe',      // ID 8 -> ID 11
            'lab-resultados' => 'laboratorio-resul' // ID 9 -> ID 10
        ];

        foreach ($roleMigrations as $oldRoleName => $newRoleName) {
            $this->migrateRole($oldRoleName, $newRoleName);
        }

        $this->command->info('✅ Migración completada exitosamente');
    }

    private function migrateRole($oldRoleName, $newRoleName)
    {
        // Buscar roles
        $oldRole = Role::where('name', $oldRoleName)->first();
        $newRole = Role::where('name', $newRoleName)->first();

        if (!$oldRole) {
            $this->command->warn("⚠️  Rol antiguo '{$oldRoleName}' no encontrado, omitiendo...");
            return;
        }

        if (!$newRole) {
            $this->command->error("❌ Rol nuevo '{$newRoleName}' no encontrado. Ejecute NewRolesSeeder primero.");
            return;
        }

        // Obtener usuarios con el rol antiguo
        $users = DB::table('model_has_roles')
            ->where('role_id', $oldRole->id)
            ->get();

        if ($users->isEmpty()) {
            $this->command->info("ℹ️  No hay usuarios con el rol '{$oldRoleName}'");
        } else {
            $this->command->info("📋 Migrando {$users->count()} usuario(s) de '{$oldRoleName}' a '{$newRoleName}':");

            foreach ($users as $userRole) {
                // Verificar si el usuario ya tiene el nuevo rol
                $exists = DB::table('model_has_roles')
                    ->where('role_id', $newRole->id)
                    ->where('model_type', $userRole->model_type)
                    ->where('model_id', $userRole->model_id)
                    ->exists();

                if (!$exists) {
                    // Asignar nuevo rol
                    DB::table('model_has_roles')->insert([
                        'role_id' => $newRole->id,
                        'model_type' => $userRole->model_type,
                        'model_id' => $userRole->model_id
                    ]);
                    $this->command->info("   ✓ Usuario ID {$userRole->model_id} migrado");
                } else {
                    $this->command->info("   → Usuario ID {$userRole->model_id} ya tiene el nuevo rol");
                }

                // Eliminar rol antiguo del usuario
                DB::table('model_has_roles')
                    ->where('role_id', $oldRole->id)
                    ->where('model_type', $userRole->model_type)
                    ->where('model_id', $userRole->model_id)
                    ->delete();
            }
        }

        // Eliminar el rol antiguo
        $this->command->info("🗑️  Eliminando rol antiguo '{$oldRoleName}'...");
        $oldRole->delete();
        $this->command->info("   ✓ Rol '{$oldRoleName}' eliminado");
    }
}
