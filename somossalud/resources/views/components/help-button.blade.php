{{-- Botón Flotante de Ayuda --}}
<div class="help-float-button">
    <button type="button" class="btn btn-info btn-lg shadow-lg" data-toggle="modal" data-target="#helpModal" title="Ayuda">
        <i class="fas fa-question-circle fa-lg"></i>
    </button>
</div>

{{-- Modal de Ayuda Contextual --}}
<div class="modal fade" id="helpModal" tabindex="-1" role="dialog" aria-labelledby="helpModalLabel">
    <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title" id="helpModalLabel">
                    <i class="fas fa-question-circle mr-2"></i> {{ $title ?? 'Ayuda Rápida' }}
                </h5>
                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="help-quick-guide">
                    {{ $quickGuide ?? $slot }}
                </div>
            </div>
            <div class="modal-footer bg-light">
                @php
                    $manualLink = $helpLink ?? (isset($section) ? route('help.show', $section) : route('help.index'));
                @endphp
                <a href="{{ $manualLink }}" class="btn btn-primary" target="_blank">
                    <i class="fas fa-book mr-2"></i> Ver Manual Completo
                </a>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">
                    <i class="fas fa-times mr-2"></i> Cerrar
                </button>
            </div>
        </div>
    </div>
</div>

<style>
    .help-float-button {
        position: fixed;
        bottom: 30px;
        right: 30px;
        z-index: 1050;
        animation: pulse-help 2s infinite;
    }
    
    .help-float-button .btn {
        border-radius: 50%;
        width: 50px;
        height: 50px;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s ease;
    }
    
    .help-float-button .btn:hover {
        transform: scale(1.1);
        box-shadow: 0 8px 20px rgba(23, 162, 184, 0.4) !important;
    }
    
    @keyframes pulse-help {
        0%, 100% {
            transform: scale(1);
        }
        50% {
            transform: scale(1.05);
        }
    }
    
    .modal-dialog-scrollable .modal-body {
        max-height: calc(100vh - 200px);
        overflow-y: auto;
    }
    
    /* Responsive */
    @media (max-width: 768px) {
        .help-float-button {
            bottom: 20px;
            right: 20px;
        }
        
        .help-float-button .btn {
            width: 45px;
            height: 45px;
        }
    }
    
    /* Callout styles */
    .callout {
        border-radius: 3px;
        margin: 15px 0;
        padding: 15px 30px 15px 15px;
        border-left: 5px solid #eee;
    }
    
    .callout-warning {
        border-left-color: #f39c12;
        background-color: #fcf8e3;
    }
    
    .callout-info {
        border-left-color: #17a2b8;
        background-color: #d1ecf1;
    }
    
    .callout-success {
        border-left-color: #28a745;
        background-color: #d4edda;
    }
    
    .callout h6 {
        margin-top: 0;
        margin-bottom: 5px;
    }
    
    .callout p {
        margin-bottom: 0;
    }
    
    .help-quick-guide h5 {
        border-bottom: 2px solid #17a2b8;
        padding-bottom: 10px;
        margin-bottom: 15px;
    }
    
    .help-quick-guide h6 {
        margin-top: 20px;
        margin-bottom: 10px;
    }
    
    .help-quick-guide ol {
        padding-left: 20px;
    }
    
    .help-quick-guide ol li {
        margin-bottom: 5px;
    }
</style>
