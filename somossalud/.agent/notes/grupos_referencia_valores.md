# Grupos de Referencia de Laboratorio - Valores del Select

## 📊 Resumen

El select "Grupo de Referencia" se llena con los registros de la tabla `lab_reference_groups` que tengan `active = 1`.

**Consulta en el controlador:**
```php
$groups = LabReferenceGroup::where('active', true)->orderBy('description')->get();
```

## 📋 Valores Actuales en la Base de Datos

Actualmente hay **29 grupos de referencia** en la base de datos:

### 🔵 Grupos por Edad y Sexo (Demográficos)

| ID | Código | Descripción | Sexo | Edad Inicio | Edad Fin |
|----|--------|-------------|------|-------------|----------|
| 1 | M002 | **INFANTES** | Todos (3) | 0 años, 1 mes | 0 años, 12 meses |
| 2 | M003 | **NEONATOS** | Todos (3) | 1 día | 2 días |
| 3 | M004 | **HOMBRES** | Masculino (1) | 0 años, 1 día | 150 años |
| 4 | M005 | **MUJERES** | Femenino (2) | 0 años, 1 día | 150 años |
| 5 | M010 | **NIÑOS** | Todos (3) | 1 año | 13 años |
| 11 | M023 | **ADULTOS** | Todos (3) | 14 años | 150 años |
| 12 | M024 | **RECIEN NACIDOS** | Todos (3) | 3 días | 30 días |

### 🟢 Grupos Genéricos - TODOS (Sin restricción de edad/sexo)

| ID | Código | Descripción | Sexo | Uso |
|----|--------|-------------|------|-----|
| 6 | M017 | **VALOR1-TODOS** | Todos (3) | Valor genérico 1 |
| 7 | M018 | **VALOR2-TODOS** | Todos (3) | Valor genérico 2 |
| 8 | M019 | **VALOR3-TODOS** | Todos (3) | Valor genérico 3 |
| 9 | M021 | **VALOR4-TODOS** | Todos (3) | Valor genérico 4 |
| 10 | M022 | **VALOR5-TODOS** | Todos (3) | Valor genérico 5 |
| 13 | M025 | **VALOR6-TODOS** | Todos (3) | Valor genérico 6 |
| 22 | M034 | **VALOR7-TODOS** | Todos (3) | Valor genérico 7 |

### 🟣 Grupos Específicos - FEMENINO

| ID | Código | Descripción | Sexo | Uso |
|----|--------|-------------|------|-----|
| 14 | M026 | **VALOR1-FEME** | Femenino (2) | Valor femenino 1 |
| 15 | M027 | **VALOR2-FEME** | Femenino (2) | Valor femenino 2 |
| 16 | M028 | **VALOR3-FEME** | Femenino (2) | Valor femenino 3 |
| 17 | M029 | **VALOR4-FEME** | Femenino (2) | Valor femenino 4 |
| 24 | M036 | **VALOR5-FEME** | Femenino (2) | Valor femenino 5 |
| 25 | M037 | **VALOR6-FEME** | Femenino (2) | Valor femenino 6 |

### 🔴 Grupos Específicos - MASCULINO

| ID | Código | Descripción | Sexo | Uso |
|----|--------|-------------|------|-----|
| 18 | M030 | **VALOR1-MASC** | Masculino (1) | Valor masculino 1 |
| 19 | M031 | **VALOR2-MASC** | Masculino (1) | Valor masculino 2 |
| 20 | M032 | **VALOR3-MASC** | Masculino (1) | Valor masculino 3 |
| 21 | M033 | **VALOR4-MASC** | Masculino (1) | Valor masculino 4 |
| 23 | M035 | **VALOR5-MASC** | Masculino (1) | Valor masculino 5 |

### 🟡 Grupos Específicos - NIÑOS (Sin edad definida)

| ID | Código | Descripción | Sexo | Edad |
|----|--------|-------------|------|------|
| 26 | M038 | **NIÑOS-01** | Todos (3) | 0-0 años |
| 27 | M039 | **NIÑOS-02** | Todos (3) | 0-0 años |
| 28 | M040 | **NIÑOS-03** | Todos (3) | 0-0 años |
| 29 | M041 | **NIÑOS-04** | Sin sexo (0) | 0-0 años |

## 🔑 Códigos de Sexo

```
1 = Masculino (HOMBRES)
2 = Femenino (MUJERES)
3 = Todos (Ambos sexos)
0 = Sin definir
```

## 📝 Formato del Select en la Vista

En `resources/views/lab/management/references.blade.php`:

```html
<select name="lab_reference_group_id" class="form-control select2" required>
    <option value="">Seleccione un grupo...</option>
    @foreach($groups as $group)
        <option value="{{ $group->id }}">
            {{ $group->description }} - 
            @if($group->sex == 1) Masculino
            @elseif($group->sex == 2) Femenino
            @else Todos
            @endif
            ({{ $group->age_start_year }}-{{ $group->age_end_year }} años)
        </option>
    @endforeach
</select>
```

## 🎯 Ejemplo de Opciones Mostradas

Así se vería el select ordenado alfabéticamente por `description`:

```
- ADULTOS - Todos (14-150 años)
- HOMBRES - Masculino (0-150 años)
- INFANTES - Todos (0-0 años)
- MUJERES - Femenino (0-150 años)
- NEONATOS - Todos (0-0 años)
- NIÑOS - Todos (1-13 años)
- NIÑOS-01 - Todos (0-0 años)
- NIÑOS-02 - Todos (0-0 años)
- NIÑOS-03 - Todos (0-0 años)
- NIÑOS-04 - Sin definir (0-0 años)
- RECIEN NACIDOS - Todos (0-0 años)
- VALOR1-FEME - Femenino (0-0 años)
- VALOR1-MASC - Masculino (0-0 años)
- VALOR1-TODOS - Todos (0-0 años)
- VALOR2-FEME - Femenino (0-0 años)
- VALOR2-MASC - Masculino (0-0 años)
- VALOR2-TODOS - Todos (0-0 años)
... (y así sucesivamente)
```

## 💡 Uso Recomendado

### Grupos Demográficos Principales (Más usados):
1. **HOMBRES** (M004) - Para hombres adultos
2. **MUJERES** (M005) - Para mujeres adultas
3. **NIÑOS** (M010) - Para niños de 1-13 años
4. **ADULTOS** (M023) - Para adultos sin distinción de sexo
5. **INFANTES** (M002) - Para bebés de 1-12 meses
6. **NEONATOS** (M003) - Para recién nacidos de 1-2 días
7. **RECIEN NACIDOS** (M024) - Para recién nacidos de 3-30 días

### Grupos Genéricos (Para valores únicos):
- **VALOR1-TODOS** hasta **VALOR7-TODOS** - Para parámetros que no varían por edad/sexo

### Grupos Específicos por Sexo:
- **VALOR1-FEME** hasta **VALOR6-FEME** - Para valores específicos de mujeres
- **VALOR1-MASC** hasta **VALOR5-MASC** - Para valores específicos de hombres

## 📊 Estadísticas

- **Total de grupos:** 29
- **Grupos demográficos:** 7
- **Grupos genéricos (Todos):** 7
- **Grupos femeninos:** 6
- **Grupos masculinos:** 5
- **Grupos niños (sin edad):** 4
- **Todos activos:** Sí (active = 1)

## 🔄 Origen de los Datos

Estos datos fueron insertados en la base de datos el **2025-11-25 22:19:17** y provienen de un sistema de laboratorio previo que fue migrado.

Los grupos con nombres genéricos (VALOR1-TODOS, VALOR2-FEME, etc.) son placeholders que permiten flexibilidad para definir múltiples rangos de referencia para un mismo parámetro según diferentes criterios.

---

**Última actualización:** 2025-12-11  
**Fuente:** `database/javier_ponciano_5.sql` líneas 3334-3362
