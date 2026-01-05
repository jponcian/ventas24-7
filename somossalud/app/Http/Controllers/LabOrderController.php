<?php

namespace App\Http\Controllers;

use App\Models\LabOrder;
use App\Models\LabOrderDetail;
use App\Models\LabExam;
use App\Models\LabCategory;
use App\Models\LabResult;
use App\Models\User;
use App\Models\Clinica;
use App\Notifications\ResultadoLaboratorioListo;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;
use SimpleSoftwareIO\QrCode\Facades\QrCode;
use Barryvdh\DomPDF\Facade\Pdf;

class LabOrderController extends Controller
{
    /**
     * Mostrar listado de órdenes
     */
    public function index(Request $request)
    {
        $user = Auth::user();
        
        // Filtros (Fecha por defecto HOY)
        $status = $request->get('status', 'all');
        //$date = $request->get('date');
        // Si el parámetro no está presente, es la carga inicial: usar HOY.
        // Si está presente (incluso vacío), respetar el valor enviado.
        $date = $request->has('date') ? $request->get('date') : now()->format('Y-m-d'); 
        $patientSearch = $request->get('patient_search');

        $query = LabOrder::with(['patient', 'doctor', 'clinica', 'details.exam'])
            ->orderBy('created_at', 'desc');

        // Filtrar por fecha
        if ($date) {
            $query->whereDate('order_date', $date);
        }

        // Filtrar por paciente (nombre o cédula)
        if ($patientSearch) {
            $query->whereHas('patient', function($q) use ($patientSearch) {
                $q->where('name', 'like', "%{$patientSearch}%")
                  ->orWhere('cedula', 'like', "%{$patientSearch}%");
            });
        }

        // Filtrar por clínica si no es super-admin
        if (!$user->hasRole('super-admin')) {
            $query->where('clinica_id', $user->clinica_id);
        }

        // Si es laboratorio-resul, solo mostrar órdenes pendientes o completadas hace menos de 2 días
        if ($user->hasRole('laboratorio-resul') && !$user->hasRole(['super-admin', 'admin_clinica', 'laboratorio'])) {
            $query->where(function($q) {
                $q->where('status', 'pending')
                  ->orWhere(function($subQ) {
                      $subQ->where('status', 'completed')
                           ->where('result_date', '>=', now()->subDays(2));
                  });
            });
        }

        // Filtrar por estado
        if ($status !== 'all') {
            $query->where('status', $status);
        }

        $orders = $query->paginate(20)->appends($request->all());

        return view('lab.orders.index', compact('orders', 'status', 'date', 'patientSearch'));
    }

    /**
     * Mostrar formulario de creación de orden
     */
    public function create()
    {
        $user = Auth::user();

        // Obtener categorías con sus exámenes activos
        // Obtener categorías con sus exámenes activos (Solo columnas necesarias)
        $categories = LabCategory::active()
            ->with([
                'exams' => function ($query) {
                    $query->active()
                        ->select('id', 'name', 'price', 'lab_category_id') // Slim Loading: 70% menos memoria
                        ->orderBy('name');
                }
            ])
            ->orderBy('name')
            ->get();

        // Obtener pacientes (usuarios con rol paciente)
        $patients = User::role('paciente')
            ->orderBy('name')
            ->get();

        // Obtener clínicas
        if ($user->hasRole('super-admin')) {
            $clinicas = Clinica::all();
        } else {
            $clinicas = Clinica::where('id', $user->clinica_id)->get();
        }

        return view('lab.orders.create', compact('categories', 'patients', 'clinicas'));
    }

    /**
     * Guardar nueva orden
     */
    public function store(Request $request)
    {
        $request->validate([
            'patient_id' => 'required|exists:usuarios,id',
            'clinica_id' => 'required|exists:clinicas,id',
            'order_date' => 'required|date',
            'exams' => 'required|array|min:1',
            'exams.*' => 'exists:lab_exams,id',
            'observations' => 'nullable|string'
        ]);

        try {
            DB::beginTransaction();

            // Crear la orden
            $dailyCount = LabOrder::whereDate('order_date', $request->order_date)->count() + 1;
            $order = LabOrder::create([
                'order_number' => LabOrder::generateOrderNumber(),
                'patient_id' => $request->patient_id,
                'clinica_id' => $request->clinica_id,
                'order_date' => $request->order_date,
                'sample_date' => $request->order_date, // Fecha de muestra igual a la fecha de la orden
                'status' => 'pending',
                'daily_exam_count' => $dailyCount,
                'observations' => $request->observations,
                'created_by' => Auth::id()
            ]);

            // Agregar los exámenes solicitados
            $total = 0;
            foreach ($request->exams as $examId) {
                $exam = LabExam::findOrFail($examId);

                LabOrderDetail::create([
                    'lab_order_id' => $order->id,
                    'lab_exam_id' => $exam->id,
                    'price' => $exam->price,
                    'status' => 'pending'
                ]);

                $total += $exam->price;
            }

            // Actualizar el total
            $order->update(['total' => $total]);

            DB::commit();

            return redirect()
                ->route('lab.orders.show', $order->id)
                ->with('success', 'Orden de laboratorio creada exitosamente');

        } catch (\Exception $e) {
            DB::rollBack();
            return back()
                ->withInput()
                ->with('error', 'Error al crear la orden: ' . $e->getMessage());
        }
    }

    /**
     * Ver detalle de la orden
     */
    public function show($id)
    {
        $order = LabOrder::with([
            'patient',
            'doctor',
            'clinica',
            'details.exam.items',
            'details.results.examItem',
            'createdBy'
        ])->findOrFail($id);

        // Verificar permisos
        $user = Auth::user();
        if (!$user->hasRole('super-admin') && $order->clinica_id !== $user->clinica_id) {
            abort(403, 'No tiene permisos para ver esta orden');
        }

        return view('lab.orders.show', compact('order'));
    }

    /**
     * Mostrar formulario para cargar resultados
     */
    public function loadResults($id)
    {
        $order = LabOrder::with([
            'patient',
            'doctor',
            'clinica',
            'details.exam.items',
            'details.results.examItem'
        ])->findOrFail($id);

        // Verificar permisos
        $user = Auth::user();
        if (!$user->hasRole('super-admin') && $order->clinica_id !== $user->clinica_id) {
            abort(403, 'No tiene permisos para cargar resultados a esta orden');
        }

        // Verificar si el rol laboratorio-resul puede modificar (solo hasta 2 días después)
        if ($user->hasRole('laboratorio-resul') && !$user->hasRole(['super-admin', 'admin_clinica', 'laboratorio'])) {
            if ($order->status === 'completed' && $order->result_date) {
                $daysSinceResult = now()->diffInDays($order->result_date);
                if ($daysSinceResult > 2) {
                    return redirect()->route('lab.orders.show', $order->id)
                        ->with('error', 'No puede modificar resultados después de 2 días de haberlos cargado.');
                }
            }
        }

        return view('lab.orders.load_results', compact('order'));
    }

    /**
     * Guardar resultados de la orden
     */
    public function storeResults(Request $request, $id)
    {
        $order = LabOrder::findOrFail($id);
        $user = Auth::user();

        // Verificar si el rol laboratorio-resul puede modificar (solo hasta 2 días después)
        if ($user->hasRole('laboratorio-resul') && !$user->hasRole(['super-admin', 'admin_clinica', 'laboratorio'])) {
            if ($order->status === 'completed' && $order->result_date) {
                $daysSinceResult = now()->diffInDays($order->result_date);
                if ($daysSinceResult > 2) {
                    return redirect()->route('lab.orders.show', $order->id)
                        ->with('error', 'No puede modificar resultados después de 2 días de haberlos cargado.');
                }
            }
        }

        $request->validate([
            'results' => 'required|array',
            'results.*.value' => 'nullable|string',
            // 'results.*.observation' => 'nullable|string', // Ya no guardamos observaciones por ítem individualmente
            'observations' => 'nullable|string'
        ]);

        try {
            DB::beginTransaction();

            // Guardar resultados
            foreach ($request->results as $itemId => $resultData) {
                $detail = $order->details()
                    ->whereHas('exam.items', function ($query) use ($itemId) {
                        $query->where('id', $itemId);
                    })
                    ->first();

                if ($detail && !empty($resultData['value'])) {
                    LabResult::updateOrCreate(
                        [
                            'lab_order_detail_id' => $detail->id,
                            'lab_exam_item_id' => $itemId
                        ],
                        [
                            'value' => $resultData['value'],
                            'observation' => null // Limpiamos la observación individual si existiera
                        ]
                    );
                }
            }

            // Actualizar fechas, estado y observaciones generales de la orden
            $updateData = [
                'status' => 'completed',
                'observations' => $request->observations,
                'verification_code' => $order->verification_code ?? LabOrder::generateVerificationCode(),
                'results_loaded_by' => Auth::id()
            ];
            
            // Solo actualizar result_date si es la primera vez que se cargan resultados
            if ($order->status !== 'completed') {
                $updateData['result_date'] = now();
            }
            
            $order->update($updateData);

            $order->details()->update(['status' => 'completed']);

            DB::commit();

            // Enviar notificación al paciente de que sus resultados están listos
            // Se envía después del commit para que el mensaje de éxito se muestre después del envío
            $whatsappSent = false;
            $pdfSent = false;
            if ($order->patient) {
                // Enviar email si tiene email
                if (!empty($order->patient->email)) {
                    try {
                        $order->patient->notify(new ResultadoLaboratorioListo($order));
                        \Log::info('Email de resultados enviado', ['order_id' => $order->id]);
                    } catch (\Exception $e) {
                        \Log::error('Error enviando email de resultados', [
                            'order_id' => $order->id,
                            'error' => $e->getMessage()
                        ]);
                    }
                }

                // Enviar WhatsApp con PDF si tiene teléfono y está habilitado
                if (config('whatsapp.enabled') && !empty($order->patient->telefono)) {
                    try {
                        $whatsappService = new \App\Services\WhatsAppService();
                        
                        // Formatear número de teléfono
                        $phoneNumber = $this->formatPhoneNumber($order->patient->telefono);
                        
                        if ($phoneNumber) {
                            // Generar QR para el PDF
                            $qrCode = base64_encode(QrCode::format('svg')
                                ->size(150)
                                ->generate(route('lab.orders.verify', $order->verification_code)));

                            // Generar PDF
                            $pdf = Pdf::loadView('lab.orders.pdf', compact('order', 'qrCode'));
                            
                            // Obtener contenido y convertir a Base64
                            $pdfContent = $pdf->output();
                            $base64Pdf = 'data:application/pdf;base64,' . base64_encode($pdfContent);
                            
                            $filename = $order->order_number . '-' . strtoupper(str_replace(' ', '-', $order->patient->name)) . '.pdf';

                            // Preparar caption para el PDF
                            $clinica = $order->clinica->nombre ?? 'SomosSalud';
                            $verificationUrl = route('lab.orders.verify', $order->verification_code);
                            $caption = "🏥 *{$clinica} - Resultados Listos*\n\n";
                            $caption .= "Hola {$order->patient->name} 👋\n\n";
                            $caption .= "¡Buenas noticias! Tus resultados de laboratorio ya están disponibles. 🔬✅\n\n";
                            $caption .= "📋 *Orden:* {$order->order_number}\n";
                            $caption .= "🧪 *Exámenes:* {$order->details->count()}\n";
                            $caption .= "🔐 *Código:* {$order->verification_code}\n\n";
                            $caption .= "📄 Adjunto encontrarás tus resultados en PDF\n\n";
                            $caption .= "🔗 *Validar resultado online:*\n";
                            $caption .= "{$verificationUrl}\n\n";
                            $caption .= "_Gracias por confiar en SomosSalud_ 💚";

                            // Enviar PDF por WhatsApp
                            $result = $whatsappService->sendDocument($phoneNumber, $base64Pdf, $caption, $filename);
                            
                            if ($result['success']) {
                                $whatsappSent = true;
                                $pdfSent = true;
                                \Log::info('PDF de resultados enviado por WhatsApp automáticamente', [
                                    'order_id' => $order->id,
                                    'phone' => $phoneNumber,
                                    'filename' => $filename
                                ]);
                            } else {
                                \Log::error('Error al enviar PDF por WhatsApp automáticamente', [
                                    'order_id' => $order->id,
                                    'phone' => $phoneNumber,
                                    'error' => $result['error'] ?? 'Unknown error'
                                ]);
                            }
                        } else {
                            \Log::warning('Formato de teléfono inválido para WhatsApp', [
                                'order_id' => $order->id,
                                'telefono' => $order->patient->telefono
                            ]);
                        }
                    } catch (\Exception $e) {
                        \Log::error('Excepción al enviar PDF por WhatsApp automáticamente', [
                            'order_id' => $order->id,
                            'error' => $e->getMessage(),
                            'trace' => $e->getTraceAsString()
                        ]);
                    }
                }
            }

            // Preparar mensajes de respuesta
            $redirect = redirect()->route('lab.orders.show', $order->id)
                ->with('success', 'Resultados guardados exitosamente');
            
            // Agregar mensaje adicional si se envió WhatsApp con PDF
            if ($whatsappSent && $pdfSent) {
                $phoneNumber = $order->patient->telefono;
                $redirect->with('info', "📱 PDF enviado automáticamente por WhatsApp al paciente ({$phoneNumber})");
            }

            return $redirect;

        } catch (\Exception $e) {
            DB::rollBack();
            return back()
                ->withInput()
                ->with('error', 'Error al guardar resultados: ' . $e->getMessage());
        }
    }

    /**
     * Generar PDF de la orden con resultados
     */
    public function downloadPDF($id)
    {
        $order = LabOrder::with([
            'patient',
            'doctor',
            'clinica',
            'resultsLoadedBy',
            'details.exam.items',
            'details.results.examItem'
        ])->findOrFail($id);

        // Verificar permisos
        $user = Auth::user();
        $isAuthorizedStaff = $user->hasRole(['laboratorio', 'laboratorio-resul', 'admin_clinica', 'super-admin', 'recepcionista']);
        $isPatientOwner = $order->patient_id === $user->id;

        if (!$isAuthorizedStaff && !$isPatientOwner) {
            abort(403, 'No tiene permisos para descargar este resultado.');
        }

        if (!$order->isCompleted()) {
            return back()->with('error', 'La orden aún no tiene resultados completos');
        }

        // Generar QR
        $qrCode = base64_encode(QrCode::format('svg')
            ->size(150)
            ->generate(route('lab.orders.verify', $order->verification_code)));

        $pdf = Pdf::loadView('lab.orders.pdf', compact('order', 'qrCode'));

        $filename = $order->order_number . '-' . strtoupper(str_replace(' ', '-', $order->patient->name)) . '.pdf';
        return $pdf->download($filename);
    }

    /**
     * Generar ticket PDF de la orden
     */
    public function downloadTicket($id)
    {
        $order = LabOrder::with([
            'patient',
            'clinica',
            'details.exam'
        ])->findOrFail($id);

        // Verificar permisos
        $user = Auth::user();
        if (!$user->hasRole('super-admin') && $order->clinica_id !== $user->clinica_id) {
            abort(403, 'No tiene permisos para ver este ticket.');
        }

        $pdf = Pdf::loadView('lab.orders.ticket', compact('order'));
        $pdf->setPaper([0, 0, 226.77, 566.93], 'portrait'); // 80mm de ancho

        $filename = 'TICKET-' . $order->order_number . '.pdf';
        return $pdf->stream($filename);
    }

    /**
     * Enviar PDF de resultados por WhatsApp
     */
    public function sendPDFWhatsApp($id)
    {
        $order = LabOrder::with([
            'patient',
            'doctor',
            'clinica',
            'resultsLoadedBy',
            'details.exam.items',
            'details.results.examItem'
        ])->findOrFail($id);

        // Verificar permisos
        $user = Auth::user();
        if (!$user->hasRole('super-admin') && $order->clinica_id !== $user->clinica_id) {
            return back()->with('error', 'No tiene permisos para enviar este resultado.');
        }

        if (!$order->isCompleted()) {
            return back()->with('error', 'La orden aún no tiene resultados completos');
        }

        // Verificar que el paciente tenga teléfono
        if (empty($order->patient->telefono)) {
            return back()->with('error', 'El paciente no tiene un número de teléfono registrado');
        }

        try {
            $whatsappService = new \App\Services\WhatsAppService();
            
            // Formatear número de teléfono
            $phoneNumber = $this->formatPhoneNumber($order->patient->telefono);
            
            if (!$phoneNumber) {
                return back()->with('error', 'El formato del teléfono del paciente no es válido');
            }

            // Generar QR
            $qrCode = base64_encode(QrCode::format('svg')
                ->size(150)
                ->generate(route('lab.orders.verify', $order->verification_code)));

            // Generar PDF
            $pdf = Pdf::loadView('lab.orders.pdf', compact('order', 'qrCode'));
            
            // Obtener contenido y convertir a Base64
            // Esto permite enviar el archivo sin necesidad de una URL pública accesible
            $pdfContent = $pdf->output();
            $base64Pdf = 'data:application/pdf;base64,' . base64_encode($pdfContent);
            
            $filename = $order->order_number . '-' . strtoupper(str_replace(' ', '-', $order->patient->name)) . '.pdf';

            \Log::info('Preparando envío de PDF por WhatsApp (Base64)', [
                'order_id' => $order->id,
                'phone' => $phoneNumber,
                'filename' => $filename,
                'size_bytes' => strlen($pdfContent)
            ]);

            // Preparar mensaje
            $clinica = $order->clinica->nombre ?? 'SomosSalud';
            $caption = "🏥 *{$clinica}*\n\n";
            $caption .= "📋 Resultados de Laboratorio\n";
            $caption .= "Orden: {$order->order_number}\n";
            $caption .= "Paciente: {$order->patient->name}\n\n";
            $caption .= "Adjunto encontrarás tus resultados en PDF 📄";

            // Enviar PDF por WhatsApp
            $result = $whatsappService->sendDocument($phoneNumber, $base64Pdf, $caption, $filename);

            \Log::info('Respuesta de WhatsApp API', [
                'order_id' => $order->id,
                'result' => $result
            ]);
            
            if ($result['success']) {
                \Log::info('PDF de resultados enviado por WhatsApp', [
                    'order_id' => $order->id,
                    'phone' => $phoneNumber,
                    'filename' => $filename
                ]);

                return back()->with('success', "PDF enviado exitosamente por WhatsApp a {$order->patient->telefono}");
            } else {
                \Log::error('Error al enviar PDF por WhatsApp', [
                    'order_id' => $order->id,
                    'phone' => $phoneNumber,
                    'error' => $result['error'] ?? 'Unknown error',
                    'data' => $result['data'] ?? null
                ]);

                return back()->with('error', 'Error al enviar el PDF por WhatsApp: ' . ($result['error'] ?? 'Error desconocido'));
            }

        } catch (\Exception $e) {
            \Log::error('Excepción al enviar PDF por WhatsApp', [
                'order_id' => $order->id,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return back()->with('error', 'Error al enviar el PDF: ' . $e->getMessage());
        }
    }

    /**
     * Verificación pública de resultados (sin login)
     */
    public function verify($code)
    {
        $order = LabOrder::where('verification_code', $code)
            ->with([
                'patient',
                'doctor',
                'clinica',
                'details.exam.items',
                'details.results.examItem'
            ])
            ->firstOrFail();

        if (!$order->isCompleted()) {
            abort(404, 'Resultados no disponibles');
        }

        return view('lab.orders.verify', compact('order'));
    }

    /**
     * Buscar pacientes (AJAX)
     */
    public function searchPatients(Request $request)
    {
        $search = $request->get('q');

        $patients = User::role('paciente')
            ->where(function ($query) use ($search) {
                $query->where('name', 'like', "%{$search}%")
                    ->orWhere('cedula', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%");
            })
            ->limit(10)
            ->get(['id', 'name', 'cedula', 'email']);

        return response()->json($patients);
    }

    /**
     * Eliminar un examen de la orden
     */
    public function deleteExamItem(Request $request)
    {
        $itemId = $request->input('item_id');
        $item = \App\Models\LabExamItem::find($itemId);
        if ($item) {
            $item->delete();
            return response()->json(['success' => true]);
        }
        return response()->json(['success' => false], 404);
    }

    /**
     * Formatear número de teléfono venezolano a formato internacional
     * Convierte: 0414-1234567 → +584141234567
     * Operadoras: Movistar (0414, 0424), Digitel (0412, 0422), Movilnet (0416, 0426)
     * 
     * @param string $phone
     * @return string|null
     */
    private function formatPhoneNumber($phone)
    {
        // Limpiar el número (quitar espacios, guiones, paréntesis)
        $phone = preg_replace('/[^0-9+]/', '', $phone);
        
        // Si ya tiene el formato internacional correcto
        // +58 + (0414|0424|0412|0422|0416|0426) + 7 dígitos
        if (preg_match('/^\+58(41[24]|42[246])\d{7}$/', $phone)) {
            return $phone;
        }
        
        // Si es formato local venezolano: 04XX-XXXXXXX
        if (preg_match('/^0(41[24]|42[246])(\d{7})$/', $phone, $matches)) {
            return '+58' . $matches[1] . $matches[2];
        }
        
        // Si ya tiene 58 pero sin el +
        if (preg_match('/^58(41[24]|42[246])\d{7}$/', $phone)) {
            return '+' . $phone;
        }
        
        return null;
    }

    /**
     * Eliminar una orden de laboratorio
     */
    public function destroy(LabOrder $order)
    {
        try {
            // Verificar permisos
            if (!auth()->user()->hasRole(['super-admin', 'admin_clinica'])) {
                return redirect()->route('lab.orders.index')
                    ->with('error', 'No tienes permisos para eliminar órdenes.');
            }

            $orderNumber = $order->order_number;
            
            // Eliminar resultados asociados
            foreach ($order->details as $detail) {
                $detail->results()->delete();
            }
            
            // Eliminar detalles de la orden
            $order->details()->delete();
            
            // Eliminar la orden
            $order->delete();
            
            \Log::info('Orden de laboratorio eliminada', [
                'order_number' => $orderNumber,
                'deleted_by' => auth()->user()->name
            ]);
            
            return redirect()->route('lab.orders.index')
                ->with('success', "Orden {$orderNumber} eliminada exitosamente.");
                
        } catch (\Exception $e) {
            \Log::error('Error al eliminar orden de laboratorio', [
                'order_id' => $order->id,
                'error' => $e->getMessage()
            ]);
            
            return redirect()->route('lab.orders.show', $order->id)
                ->with('error', 'Error al eliminar la orden: ' . $e->getMessage());
        }
    }
    /**
     * Descarga pública de PDF (URL firmada)
     */
    public function downloadPublicPDF($id)
    {
        $order = LabOrder::with([
            'patient',
            'doctor',
            'clinica',
            'resultsLoadedBy',
            'details.exam.items',
            'details.results.examItem'
        ])->findOrFail($id);
        
        // No verificamos Auth::user() porque confiamos en la firma de la URL (signed middleware)

        if (!$order->isCompleted()) {
            abort(404, 'La orden aún no tiene resultados completos');
        }

        // Generar QR
        $qrCode = base64_encode(QrCode::format('svg')
            ->size(150)
            ->generate(route('lab.orders.verify', $order->verification_code)));

        $pdf = Pdf::loadView('lab.orders.pdf', compact('order', 'qrCode'));

        $filename = $order->order_number . '-' . strtoupper(str_replace(' ', '-', $order->patient->name)) . '.pdf';
        return $pdf->download($filename);
    }
}
