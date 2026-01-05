<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class LabExamItem extends Model
{
    protected $table = 'lab_exam_items';
    protected $fillable = ['lab_exam_id','code','name','unit','reference_value','type','order'];

    public function exam()
    {
        return $this->belongsTo(LabExam::class, 'lab_exam_id');
    }

    public function results()
    {
        return $this->hasMany(LabResult::class, 'lab_exam_item_id');
    }

    public function referenceRanges()
    {
        return $this->hasMany(LabReferenceRange::class, 'lab_exam_item_id');
    }

    /**
     * Obtener el rango de referencia específico para un paciente
     * Retorna un solo rango si puede determinarlo automáticamente,
     * o una colección de rangos si requiere interpretación manual
     */
    public function getReferenceRangeForPatient($patient)
    {
        if (!$patient || !$patient->fecha_nacimiento || !$patient->sexo) {
            return null;
        }

        $age = \Carbon\Carbon::parse($patient->fecha_nacimiento)->age;
        $sex = $patient->sexo; // 'M' o 'F'
        
        // Convertir sexo a formato numérico del sistema viejo (1=H, 2=M, 3=Todos)
        $sexCode = ($sex === 'M') ? 1 : 2;

        // Obtener todos los rangos aplicables por sexo
        $ranges = $this->referenceRanges()
            ->with('group')
            ->whereHas('group', function($q) use ($age, $sexCode) {
                $q->where(function($query) use ($sexCode) {
                    $query->where('sex', $sexCode)
                          ->orWhere('sex', 3); // 3 = Todos
                })
                ->where(function($query) use ($age) {
                    // Grupos con edad definida (selección automática)
                    $query->where(function($subQ) use ($age) {
                        $subQ->where('age_start_year', '<=', $age)
                             ->where('age_end_year', '>=', $age)
                             ->where('age_start_year', '>', 0); // Excluir grupos VALOR-X (0-0)
                    })
                    // O grupos VALOR-X (requieren parsing de condición)
                    ->orWhere(function($subQ) {
                        $subQ->where('age_start_year', 0)
                             ->where('age_end_year', 0);
                    });
                });
            })
            ->get();

        // Si no hay rangos, retornar null
        if ($ranges->isEmpty()) {
            return null;
        }

        // Si solo hay un rango, retornarlo directamente
        if ($ranges->count() == 1) {
            return $ranges->first();
        }

        // Si hay múltiples rangos, intentar filtrar por edad definida primero
        $rangesWithAge = $ranges->filter(function($range) use ($age) {
            return $range->group->age_start_year > 0 
                && $range->group->age_start_year <= $age 
                && $range->group->age_end_year >= $age;
        });

        // Si encontramos rangos con edad definida, usar el primero
        if ($rangesWithAge->isNotEmpty()) {
            return $rangesWithAge->first();
        }

        // Si todos son VALOR-X (0-0), intentar parsing de condición especial
        $matchedRange = null;
        foreach ($ranges as $range) {
            if ($this->edadAplicaEnCondicion($age, $range->condition)) {
                $matchedRange = $range;
                break;
            }
        }

        // Si encontramos un rango por condición, retornarlo
        if ($matchedRange) {
            return $matchedRange;
        }

        // Si no pudimos determinar un rango específico, retornar todos
        // para que se muestren en el PDF y el médico interprete
        return $ranges;
    }

    /**
     * Verificar si la edad del paciente aplica en la condición especial
     * Parsea formatos como: "Hombres 18-30 años", "Mujeres >70 años", etc.
     */
    private function edadAplicaEnCondicion($edad, $condicion)
    {
        if (!$condicion) {
            return false;
        }

        // Formato: "18-30 años" o "Hombres 18-30 años"
        if (preg_match('/(\d+)\s*-\s*(\d+)\s*años/', $condicion, $matches)) {
            $min = (int)$matches[1];
            $max = (int)$matches[2];
            return $edad >= $min && $edad <= $max;
        }

        // Formato: ">70 años" o "Hombres >70 años"
        if (preg_match('/>(\d+)\s*años/', $condicion, $matches)) {
            $min = (int)$matches[1];
            return $edad > $min;
        }

        // Formato: ">=65 años"
        if (preg_match('/>=(\d+)\s*años/', $condicion, $matches)) {
            $min = (int)$matches[1];
            return $edad >= $min;
        }

        // Formato: "<18 años" o "Menores de 18 años"
        if (preg_match('/<(\d+)\s*años/', $condicion, $matches)) {
            $max = (int)$matches[1];
            return $edad < $max;
        }

        // Formato: "<=17 años"
        if (preg_match('/<=(\d+)\s*años/', $condicion, $matches)) {
            $max = (int)$matches[1];
            return $edad <= $max;
        }

        return false;
    }
}
?>
