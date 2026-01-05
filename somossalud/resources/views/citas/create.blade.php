<x-app-layout>
    @push('head')
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%);
            --card-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.05);
        }

        body {
            font-family: 'Outfit', sans-serif !important;
            background-color: #f8fafc;
        }

        .page-header-custom {
            background: white;
            padding: 2rem 1.5rem;
            border-radius: 1rem;
            box-shadow: 0 4px 20px -5px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }
        
        .page-header-custom::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; height: 4px;
            background: var(--primary-gradient);
        }

        .content-card {
            background: white;
            border-radius: 1.5rem;
            border: none;
            box-shadow: var(--card-shadow);
            overflow: hidden;
            margin-bottom: 1.5rem;
        }

        .form-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #64748b;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            border-radius: 0.75rem;
            border: 2px solid #e2e8f0;
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            transition: all 0.2s;
        }

        .form-control:focus, .form-select:focus {
            border-color: #0ea5e9;
            box-shadow: 0 0 0 4px rgba(14, 165, 233, 0.1);
        }

        .btn-primary-custom {
            background: var(--primary-gradient);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 0.75rem;
            font-weight: 600;
            box-shadow: 0 4px 12px rgba(14, 165, 233, 0.25);
            transition: all 0.2s;
            width: 100%;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(14, 165, 233, 0.35);
            color: white;
        }

        /* Calendar Styles */
        .ss-cal {
            background: #f8fafc;
            border-radius: 1rem;
            padding: 1rem;
            border: 1px solid #f1f5f9;
        }

        .ss-day {
            border-radius: 0.75rem;
            background: white;
            border: 1px solid #e2e8f0;
            transition: all 0.2s;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 0.75rem 0.5rem;
        }

        .ss-day:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            border-color: #0ea5e9;
        }

        .ss-day.active {
            background: #0ea5e9;
            border-color: #0ea5e9;
            color: white !important;
        }

        .ss-day.active .text-muted {
            color: rgba(255,255,255,0.8) !important;
        }

        .ss-day:disabled {
            background: #f1f5f9;
            opacity: 0.7;
            cursor: not-allowed;
        }

        .ss-slot-btn {
            border-radius: 0.5rem;
            padding: 0.5rem 1rem;
            font-weight: 500;
            border: 1px solid #e2e8f0;
            background: white;
            color: #1e293b;
            transition: all 0.2s;
        }

        .ss-slot-btn:hover {
            border-color: #0ea5e9;
            color: #0ea5e9;
        }

        .ss-slot-btn.active {
            background: #0ea5e9;
            border-color: #0ea5e9;
            color: white;
        }

        @media (max-width: 768px) {
            .page-header-custom {
                padding: 1.5rem 1rem;
            }
        }
    </style>
    @endpush

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <!-- Header -->
            <div class="page-header-custom">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="h3 font-weight-bold mb-1" style="color: #0f172a;">Nueva Cita</h1>
                        <p class="text-muted mb-0">Agenda tu próxima consulta médica</p>
                    </div>
                </div>
            </div>

            @if(session('info'))
                <div class="alert alert-info border-0 shadow-sm rounded-lg mb-4">
                    <i class="fas fa-info-circle me-2"></i>{{ session('info') }}
                </div>
            @endif

            <div class="content-card">
                <div class="p-4 p-md-5">
                    <form method="POST" action="{{ route('citas.store') }}" id="form-cita">
                        @csrf

                        <div class="row g-4">
                            <!-- Selección de Especialidad y Médico -->
                            <div class="col-md-6">
                                <label class="form-label">Especialidad</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0 rounded-start-3">
                                        <i class="fas fa-stethoscope text-muted"></i>
                                    </span>
                                    <select name="especialidad_id" id="especialidad_id" class="form-select border-start-0 ps-0 rounded-end-3 @error('especialidad_id') is-invalid @enderror" required>
                                        <option value="" selected disabled>Selecciona una especialidad</option>
                                        @foreach($especialidades as $esp)
                                            <option value="{{ $esp->id }}" {{ old('especialidad_id') == $esp->id ? 'selected' : '' }}>{{ $esp->nombre }}</option>
                                        @endforeach
                                    </select>
                                </div>
                                @error('especialidad_id')<div class="text-danger small mt-1">{{ $message }}</div>@enderror
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Especialista</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0 rounded-start-3">
                                        <i class="fas fa-user-md text-muted"></i>
                                    </span>
                                    <select name="especialista_id" id="especialista_id" class="form-select border-start-0 ps-0 rounded-end-3 @error('especialista_id') is-invalid @enderror" required disabled>
                                        <option value="" selected disabled>Selecciona primero especialidad</option>
                                    </select>
                                </div>
                                @error('especialista_id')<div class="text-danger small mt-1">{{ $message }}</div>@enderror
                            </div>

                            <!-- Calendario -->
                            <div class="col-12">
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <label class="form-label mb-0">Disponibilidad</label>
                                    <div class="btn-group btn-group-sm">
                                        <button type="button" class="btn btn-outline-secondary" id="cal-prev" disabled>
                                            <i class="fas fa-chevron-left"></i>
                                        </button>
                                        <button type="button" class="btn btn-outline-secondary" id="cal-next">
                                            <i class="fas fa-chevron-right"></i>
                                        </button>
                                    </div>
                                </div>
                                
                                <div class="ss-cal">
                                    <div class="text-center fw-bold text-dark mb-3" id="cal-rango"></div>
                                    <div class="row row-cols-3 row-cols-md-4 row-cols-lg-6 g-2" id="cal-grid">
                                        <div class="col-12 text-center text-muted py-4">
                                            <i class="fas fa-calendar-alt fa-2x mb-2 opacity-25"></i>
                                            <p class="small mb-0">Selecciona un especialista para ver disponibilidad</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Horarios -->
                            <div class="col-12">
                                <label class="form-label">Horarios Disponibles</label>
                                <div id="slot-list" class="d-flex flex-wrap gap-2">
                                    <span class="text-muted small fst-italic">Selecciona un día del calendario</span>
                                </div>
                                <select name="fecha" id="slot_hora" class="d-none" required>
                                    <option value="" selected disabled>Selecciona hora</option>
                                </select>
                                @error('fecha')<div class="text-danger small mt-1">{{ $message }}</div>@enderror
                            </div>

                            <!-- Motivo -->
                            <div class="col-12">
                                <label class="form-label">Motivo de la consulta (Opcional)</label>
                                <textarea name="motivo" rows="3" class="form-control" placeholder="Describe brevemente el motivo de tu visita...">{{ old('motivo') }}</textarea>
                                @error('motivo')<div class="text-danger small mt-1">{{ $message }}</div>@enderror
                            </div>

                            <!-- Botón Submit -->
                            <div class="col-12 pt-2">
                                <button type="submit" class="btn-primary-custom">
                                    Confirmar Cita
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const espSelect = document.getElementById('especialidad_id');
            const docSelect = document.getElementById('especialista_id');
            let rangoInicio = new Date(); // hoy
            let rangoDias = 12; // adaptable
            
            // Ajustar días según pantalla
            if(window.innerWidth < 768) rangoDias = 6;
            
            const slotSelect = document.getElementById('slot_hora');
            const calGrid = document.getElementById('cal-grid');
            const calPrev = document.getElementById('cal-prev');
            const calNext = document.getElementById('cal-next');
            const calRango = document.getElementById('cal-rango');
            const slotList = document.getElementById('slot-list');

            function resetSelect(selectEl, placeholder) {
                selectEl.innerHTML = `<option value="" disabled selected>${placeholder}</option>`;
                selectEl.disabled = true;
            }

            espSelect.addEventListener('change', () => {
                resetSelect(docSelect, 'Cargando...');
                resetSelect(slotSelect, 'Selecciona fecha');
                slotList.innerHTML = '<span class="text-muted small fst-italic">Selecciona un día del calendario</span>';
                
                fetch(`{{ route('citas.doctores') }}?especialidad_id=${espSelect.value}`, {credentials:'same-origin'})
                    .then(r => {
                        if(!r.ok) throw new Error('Status '+r.status);
                        return r.json();
                    })
                    .then(json => {
                        if (!json.data || !json.data.length) {
                            resetSelect(docSelect, 'No hay especialistas disponibles');
                            calGrid.innerHTML = '<div class="col-12 text-center text-muted py-3">No hay especialistas</div>';
                            return;
                        }
                        docSelect.disabled = false;
                        docSelect.innerHTML = '<option value="" disabled selected>Selecciona un especialista</option>';
                        json.data.forEach(d => {
                            const opt = document.createElement('option');
                            opt.value = d.id; opt.textContent = d.nombre;
                            docSelect.appendChild(opt);
                        });
                    })
                    .catch(() => {
                        resetSelect(docSelect, 'Error cargando');
                    });
            });

            function fmtDate(d){ const y=d.getFullYear(); const m=(d.getMonth()+1).toString().padStart(2,'0'); const day=d.getDate().toString().padStart(2,'0'); return `${y}-${m}-${day}`; }
            function fmtDatePretty(d){ const meses=['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic']; return `${d.getDate()} ${meses[d.getMonth()]}`; }
            function sumarDias(base, n){ const d=new Date(base); d.setDate(d.getDate()+n); return d; }

            function renderRango(){ 
                const fin = sumarDias(rangoInicio, rangoDias-1); 
                calRango.textContent = `${fmtDatePretty(rangoInicio)} - ${fmtDatePretty(fin)}`; 
            }

            function cargarDias(){
                if(!docSelect.value){ return; }
                renderRango();
                calGrid.innerHTML = '<div class="col-12 text-center text-muted py-4"><div class="spinner-border spinner-border-sm text-primary" role="status"></div></div>';
                
                fetch(`{{ route('citas.dias') }}?especialista_id=${docSelect.value}&dias=${rangoDias}`, {credentials:'same-origin'})
                    .then(r => { if(!r.ok) throw new Error(); return r.json(); })
                    .then(json => {
                        calGrid.innerHTML = '';
                        const map = new Map();
                        (json.data||[]).forEach(it => map.set(it.fecha, it.slots));
                        
                        for(let i=0;i<rangoDias;i++){
                            const d = sumarDias(rangoInicio, i);
                            const f = fmtDate(d);
                            const slots = map.get(f) || 0;
                            const disabled = slots===0;
                            
                            const col = document.createElement('div');
                            col.className = 'col';
                            col.innerHTML = `
                                <button type="button" class="w-100 ss-day text-center p-2" data-fecha="${f}" ${disabled?'disabled':''}>
                                    <div class="small text-muted text-uppercase mb-1" style="font-size: 0.7rem;">${d.toLocaleDateString('es-VE',{weekday:'short'})}</div>
                                    <div class="h5 mb-0 fw-bold">${d.getDate()}</div>
                                    ${!disabled ? `<div class="badge bg-success bg-opacity-10 text-success rounded-pill mt-1" style="font-size: 0.6rem;">${slots} Libres</div>` : ''}
                                </button>`;
                            calGrid.appendChild(col);
                        }
                        
                        [...calGrid.querySelectorAll('button[data-fecha]')].forEach(btn => {
                            btn.addEventListener('click', () => {
                                calGrid.querySelectorAll('button').forEach(b=>b.classList.remove('active'));
                                btn.classList.add('active');
                                cargarSlots(btn.dataset.fecha);
                            });
                        });
                    })
                    .catch(()=>{ calGrid.innerHTML = '<div class="col-12 text-center text-danger small">Error al cargar disponibilidad.</div>'; });
            }

            function cargarSlots(fecha){
                resetSelect(slotSelect, 'Selecciona hora');
                slotList.innerHTML = '<div class="spinner-border spinner-border-sm text-primary" role="status"></div>';
                
                fetch(`{{ route('citas.slots') }}?especialista_id=${docSelect.value}&fecha=${fecha}`, {credentials:'same-origin'})
                    .then(r=>{ if(!r.ok) throw new Error(); return r.json(); })
                    .then(json=>{
                        slotSelect.disabled = false;
                        slotSelect.innerHTML = '<option value="" disabled selected>Selecciona hora</option>';
                        slotList.innerHTML = '';
                        
                        if(!(json.data||[]).length){
                            slotList.innerHTML = '<span class="text-muted small">No hay horarios disponibles.</span>';
                            return;
                        }
                        
                        json.data.forEach(slot => {
                            const opt = document.createElement('option');
                            opt.value = slot.valor; opt.textContent = slot.hora;
                            slotSelect.appendChild(opt);

                            const btn = document.createElement('button');
                            btn.type = 'button';
                            btn.className = 'ss-slot-btn';
                            btn.textContent = slot.hora;
                            btn.addEventListener('click', () => {
                                slotList.querySelectorAll('button').forEach(b=>b.classList.remove('active'));
                                btn.classList.add('active');
                                slotSelect.value = slot.valor;
                            });
                            slotList.appendChild(btn);
                        });
                    })
                    .catch(()=>{ slotList.innerHTML = '<span class="text-danger small">Error obteniendo horarios.</span>'; });
            }

            docSelect.addEventListener('change', () => {
                rangoInicio = new Date();
                calPrev.disabled = true;
                cargarDias();
                slotList.innerHTML = '<span class="text-muted small fst-italic">Selecciona un día del calendario</span>';
            });

            calNext.addEventListener('click', ()=>{ rangoInicio = sumarDias(rangoInicio, rangoDias); calPrev.disabled = false; cargarDias(); });
            calPrev.addEventListener('click', ()=>{ rangoInicio = sumarDias(rangoInicio, -rangoDias); if (rangoInicio <= new Date()) { rangoInicio = new Date(); calPrev.disabled = true; } cargarDias(); });

            renderRango();
        });
    </script>
</x-app-layout>
