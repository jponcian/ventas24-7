<?php

namespace App\Policies;

use App\Models\SolicitudInventario;
use App\Models\User;

class SolicitudInventarioPolicy
{
    /**
     * Ver lista de solicitudes
     */
    public function viewAny(User $user): bool
    {
        return $user->hasAnyRole(['super-admin', 'admin_clinica', 'almacen', 'almacen-jefe']);
    }

    /**
     * Ver detalle de solicitud
     */
    public function view(User $user, SolicitudInventario $solicitud): bool
    {
        // Admin y jefe de almacén pueden ver todas
        if ($user->hasAnyRole(['super-admin', 'admin_clinica', 'almacen-jefe'])) {
            return true;
        }

        // Usuario de almacén regular solo puede ver sus propias solicitudes
        if ($user->hasRole('almacen')) {
            return $solicitud->solicitante_id === $user->id;
        }

        return false;
    }

    /**
     * Crear solicitud
     */
    public function create(User $user): bool
    {
        return $user->hasAnyRole(['super-admin', 'admin_clinica', 'almacen', 'almacen-jefe']);
    }

    /**
     * Aprobar/rechazar solicitud
     */
    public function approve(User $user, SolicitudInventario $solicitud): bool
    {
        return $user->hasAnyRole(['super-admin', 'admin_clinica', 'almacen-jefe'])
            && $solicitud->isPendiente();
    }

    /**
     * Despachar solicitud
     */
    public function dispatch(User $user, SolicitudInventario $solicitud): bool
    {
        return $user->hasAnyRole(['super-admin', 'admin_clinica', 'almacen-jefe'])
            && $solicitud->isAprobada();
    }

    /**
     * Eliminar solicitud
     */
    public function delete(User $user, SolicitudInventario $solicitud): bool
    {
        // Solo el solicitante puede eliminar si está pendiente
        if ($user->hasRole('almacen') && !$user->hasRole('almacen-jefe')) {
            return $solicitud->solicitante_id === $user->id && $solicitud->isPendiente();
        }

        // Admin y jefe de almacén pueden eliminar cualquiera que esté pendiente
        return $user->hasAnyRole(['super-admin', 'admin_clinica', 'almacen-jefe']) && $solicitud->isPendiente();
    }
}
