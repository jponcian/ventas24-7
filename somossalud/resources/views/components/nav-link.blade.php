@props(['active'])

@php
    $classes = ($active ?? false)
        ? 'nav-link-active inline-flex items-center px-3 pt-1 pb-1 text-sm font-bold text-white shadow-lg'
        : 'inline-flex items-center px-1 pt-1 pb-1 text-sm font-medium text-secondary';

@endphp

<!-- CSS en línea para el nav-link activo -->
<style>
    .nav-link-active {
        background: transparent;
        color: #1976d2 !important;
        border-bottom: 4px solid #1976d2;
        border-radius: 0;
        box-shadow: none;
        position: relative;
        z-index: 2;
    }
</style>

<a {{ $attributes->merge(['class' => $classes]) }}>
    {{ $slot }}
</a>