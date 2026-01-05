<nav x-data="{ open: false }" class="bg-white border-b border-gray-100 shadow-sm">
    <div
        style="height:6px;background:linear-gradient(90deg,#10b981 0%,#06b6d4 50%,#4f46e5 100%);box-shadow:0 1px 2px rgba(0,0,0,.06)">
    </div>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <div class="flex">
                <div class="shrink-0 flex items-center">
                    <a href="{{ route('dashboard') }}" class="d-flex align-items-center gap-2">
                        <x-application-logo class="block h-12 w-auto fill-current text-gray-800"
                            style="height: 48px; width: auto;" />
                    </a>
                </div>
                <div class="hidden space-x-8 sm:-my-px sm:ms-10 sm:flex">
                    <x-nav-link :href="route('panel.pacientes')" :active="request()->routeIs('panel.pacientes')">
                        <i class="fa-solid fa-house-user me-1 text-emerald-500"></i>
                        {{ __('Panel de pacientes') }}
                    </x-nav-link>
                    <x-nav-link :href="route('suscripcion.show')" :active="request()->routeIs('suscripcion.*')">
                        <i class="fa-regular fa-id-card me-1 text-sky-500"></i>
                        {{ __('Mi suscripción') }}
                    </x-nav-link>
                    <x-nav-link :href="route('citas.paciente')" :active="request()->routeIs('citas.*')">
                        <i class="fa-solid fa-calendar-check me-1 text-indigo-500"></i>
                        {{ __('Citas médicas') }}
                    </x-nav-link>
                </div>
            </div>
            <div class="hidden sm:flex sm:items-center sm:ms-6">
                <div class="dropdown">
                    <button
                        class="btn btn-light bg-white border-0 shadow-sm rounded-pill px-3 py-2 d-flex align-items-center gap-2 dropdown-toggle"
                        type="button" data-bs-toggle="dropdown" aria-expanded="false"
                        style="color: #64748b; font-weight: 500;">
                        <div style="font-size: 0.85rem; font-weight: 500;">{{ Auth::user()->name }}</div>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end border-0 shadow-lg rounded-4 p-2 mt-2"
                        style="min-width: 200px;">
                        <li>
                            <div class="px-3 py-2 border-bottom mb-2">
                                <div class="small text-muted text-uppercase fw-bold" style="font-size: 0.7rem;">Cuenta
                                </div>
                                <div class="fw-semibold text-dark" style="font-size: 0.75rem;">{{ Auth::user()->name }}
                                </div>
                                <div class="small text-muted text-truncate" style="font-size: 0.65rem;">
                                    {{ Auth::user()->email }}
                                </div>
                            </div>
                        </li>
                        <li>
                            <a class="dropdown-item rounded-3 d-flex align-items-center gap-2 py-2 mb-1 text-secondary"
                                href="{{ route('profile.edit', ['context' => 'paciente']) }}">
                                <i class="fa-solid fa-user-circle text-primary opacity-75"></i> {{ __('Perfil') }}
                            </a>
                        </li>
                        <li>
                            <form method="POST" action="{{ route('logout') }}">
                                @csrf
                                <button class="dropdown-item rounded-3 d-flex align-items-center gap-2 py-2 text-danger"
                                    type="submit">
                                    <i class="fa-solid fa-right-from-bracket opacity-75"></i> {{ __('Cerrar sesión') }}
                                </button>
                            </form>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="-me-2 flex items-center sm:hidden">
                <button @click="open = ! open"
                    class="inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:bg-gray-100 focus:text-gray-500 transition duration-150 ease-in-out">
                    <svg class="h-6 w-6" stroke="currentColor" fill="none" viewBox="0 0 24 24">
                        <path :class="{'hidden': open, 'inline-flex': ! open }" class="inline-flex"
                            stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M4 6h16M4 12h16M4 18h16" />
                        <path :class="{'hidden': ! open, 'inline-flex': open }" class="hidden" stroke-linecap="round"
                            stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>
            </div>
        </div>
    </div>
    <div :class="{'block': open, 'hidden': ! open}" class="hidden sm:hidden">
        <div class="pt-2 pb-3 space-y-1">
            <x-responsive-nav-link :href="route('dashboard')" :active="request()->routeIs('dashboard')">
                <i class="fa-solid fa-house-user me-1 text-emerald-500"></i> {{ __('Panel de pacientes') }}
            </x-responsive-nav-link>
            <x-responsive-nav-link :href="route('suscripcion.show')" :active="request()->routeIs('suscripcion.*')">
                <i class="fa-regular fa-id-card me-1 text-sky-500"></i> {{ __('Mi suscripción') }}
            </x-responsive-nav-link>
            <x-responsive-nav-link :href="route('citas.paciente')" :active="request()->routeIs('citas.*')">
                <i class="fa-solid fa-calendar-check me-1 text-indigo-500"></i> {{ __('Citas médicas') }}
            </x-responsive-nav-link>
        </div>
        <div class="pt-4 pb-1 border-t border-gray-200">
            <div class="px-4">
                <div class="font-medium text-base text-gray-800">{{ Auth::user()->name }}</div>
                <div class="font-medium text-sm text-gray-500">{{ Auth::user()->email }}</div>
            </div>
            <div class="mt-3 space-y-1">
                <x-responsive-nav-link :href="route('profile.edit', ['context' => 'paciente'])">
                    {{ __('Perfil') }}
                </x-responsive-nav-link>
                <form method="POST" action="{{ route('logout') }}">
                    @csrf
                    <x-responsive-nav-link :href="route('logout')"
                        onclick="event.preventDefault(); this.closest('form').submit();">
                        {{ __('Cerrar sesión') }}
                    </x-responsive-nav-link>
                </form>
            </div>
        </div>
    </div>
</nav>