<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Route;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // Fix for older MySQL/MariaDB installations where the max key length
        // with utf8mb4 exceeds the default. This sets the default string length
        // to 191 to avoid "Specified key was too long" errors during migrations.
        Schema::defaultStringLength(191);

        // Use Bootstrap 5 for pagination views instead of Tailwind
        \Illuminate\Pagination\Paginator::useBootstrapFive();

        // Safety: ensure Spatie middleware aliases exist at runtime even if
        // Kernel.php changes haven't been picked up by a running process.
        // This prevents a BindingResolutionException when the string
        // 'role' is treated as a class name by the container.
        try {
            $router = $this->app->make('router');
            if (method_exists($router, 'aliasMiddleware')) {
                $router->aliasMiddleware('role', \Spatie\Permission\Middleware\RoleMiddleware::class);
                $router->aliasMiddleware('permission', \Spatie\Permission\Middleware\PermissionMiddleware::class);
                $router->aliasMiddleware('role_or_permission', \Spatie\Permission\Middleware\RoleOrPermissionMiddleware::class);
            }
        } catch (\Throwable $e) {
            // If router isn't available yet (rare), silently ignore — Kernel should register middleware.
        }
    }
}
