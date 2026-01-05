# Diferencia entre VALOR1-MASC, VALOR2-MASC, VALOR3-MASC, etc.

## 🎯 Concepto Clave

**NO hay diferencia funcional entre ellos.** Son simplemente **"slots" o "espacios"** que te permiten definir **múltiples rangos de referencia** para el mismo parámetro cuando solo aplican a **hombres**.

## 🔑 ¿Por Qué Existen Múltiples VALOR-MASC?

Porque un mismo parámetro puede tener **diferentes rangos normales** según:
- **Edad específica** (aunque el grupo no la defina)
- **Condición clínica** (en ayunas, post-ejercicio, etc.)
- **Método de medición**
- **Interpretación clínica** (normal, límite, alto, etc.)

## 📊 Ejemplo Práctico: Testosterona Total

### **Escenario:** La testosterona tiene diferentes rangos según la edad del hombre

```
Parámetro: Testosterona Total (ng/dL)

Configuración de referencias:

1. VALOR1-MASC
   Min: 300
   Max: 1000
   Condición: "Hombres adultos (20-49 años)"

2. VALOR2-MASC
   Min: 240
   Max: 870
   Condición: "Hombres 50-59 años"

3. VALOR3-MASC
   Min: 200
   Max: 740
   Condición: "Hombres 60+ años"

4. VALOR4-MASC
   Min: 10
   Max: 50
   Condición: "Niños prepúberes"
```

### **¿Cómo funciona?**

El sistema seleccionará **el primer rango** que coincida con el sexo del paciente (Masculino).

**Importante:** Como todos los grupos VALOR-MASC tienen:
- `sex = 1` (Masculino)
- `age_start_year = 0`
- `age_end_year = 0`

El sistema **NO puede distinguir automáticamente** por edad. Por eso usas el campo **"Condición"** para documentar cuándo usar cada rango.

## 🎓 Casos de Uso Reales

### **CASO 1: PSA (Antígeno Prostático Específico)**

El PSA tiene diferentes límites según la edad:

```
Parámetro: PSA (ng/mL)

1. VALOR1-MASC
   Min: NULL
   Max: 2.5
   Condición: "Hombres 40-49 años"

2. VALOR2-MASC
   Min: NULL
   Max: 3.5
   Condición: "Hombres 50-59 años"

3. VALOR3-MASC
   Min: NULL
   Max: 4.5
   Condición: "Hombres 60-69 años"

4. VALOR4-MASC
   Min: NULL
   Max: 6.5
   Condición: "Hombres 70+ años"
```

**Uso:** El médico o laboratorista selecciona manualmente el rango apropiado según la edad del paciente.

---

### **CASO 2: Testosterona Libre**

Diferentes rangos según método de medición:

```
Parámetro: Testosterona Libre (pg/mL)

1. VALOR1-MASC
   Min: 50
   Max: 210
   Condición: "Método: Diálisis de equilibrio"

2. VALOR2-MASC
   Min: 47
   Max: 244
   Condición: "Método: Cálculo (Vermeulen)"

3. VALOR3-MASC
   Min: 35
   Max: 155
   Condición: "Método: Inmunoensayo directo"
```

**Uso:** Se selecciona según el método que usó el laboratorio.

---

### **CASO 3: Espermatozoides (Análisis de Semen)**

Diferentes parámetros de calidad:

```
Parámetro: Concentración de espermatozoides (millones/mL)

1. VALOR1-MASC
   Min: 15
   Max: NULL
   Condición: "Normal (OMS 2021)"

2. VALOR2-MASC
   Min: 10
   Max: 14.9
   Condición: "Oligozoospermia leve"

3. VALOR3-MASC
   Min: 5
   Max: 9.9
   Condición: "Oligozoospermia moderada"

4. VALOR4-MASC
   Min: NULL
   Max: 4.9
   Condición: "Oligozoospermia severa"
```

**Uso:** Para clasificar automáticamente el resultado.

---

### **CASO 4: Hemoglobina Glicosilada (HbA1c) - Interpretación**

Diferentes rangos de interpretación clínica:

```
Parámetro: HbA1c (%)

1. VALOR1-MASC
   Min: NULL
   Max: 5.6
   Condición: "Normal"

2. VALOR2-MASC
   Min: 5.7
   Max: 6.4
   Condición: "Prediabetes"

3. VALOR3-MASC
   Min: 6.5
   Max: NULL
   Condición: "Diabetes"
```

**Nota:** En este caso, podrías usar VALOR-TODOS en lugar de VALOR-MASC, ya que aplica a ambos sexos.

---

## 🔄 ¿Cuándo Usar Cada VALOR-MASC?

### **Usa VALOR1-MASC cuando:**
- Es el **único** rango de referencia para hombres
- Es el rango **más común** o **estándar**

**Ejemplo:**
```
PSA:
- VALOR1-MASC: < 4.0 ng/mL (Rango estándar)
```

### **Usa VALOR2-MASC, VALOR3-MASC, etc. cuando:**
- Necesitas **múltiples rangos** para el mismo parámetro
- Hay **diferentes interpretaciones** clínicas
- Hay **diferentes métodos** de medición
- Hay **diferentes grupos de edad** (documentados en "Condición")

**Ejemplo:**
```
Testosterona:
- VALOR1-MASC: 300-1000 (Adultos jóvenes)
- VALOR2-MASC: 240-870 (Adultos medios)
- VALOR3-MASC: 200-740 (Adultos mayores)
```

---

## 💡 Comparación: VALOR-MASC vs HOMBRES

### **Grupo: HOMBRES**
- **Sexo:** Masculino (1)
- **Edad:** 0-150 años (DEFINIDA)
- **Selección:** AUTOMÁTICA por edad y sexo
- **Uso:** Cuando el rango aplica a **todos los hombres** sin distinción adicional

**Ejemplo:**
```
Hemoglobina:
- HOMBRES: 13.5-17.5 g/dL
  → Se aplica automáticamente a cualquier hombre adulto
```

### **Grupo: VALOR1-MASC**
- **Sexo:** Masculino (1)
- **Edad:** 0-0 años (NO DEFINIDA)
- **Selección:** MANUAL o por primer match
- **Uso:** Cuando necesitas **múltiples rangos** para hombres con diferentes condiciones

**Ejemplo:**
```
PSA:
- VALOR1-MASC: < 2.5 (40-49 años)
- VALOR2-MASC: < 3.5 (50-59 años)
- VALOR3-MASC: < 4.5 (60-69 años)
  → El laboratorista selecciona según la edad
```

---

## 🎯 Regla de Oro

### **Usa HOMBRES cuando:**
✅ El rango es **único** para todos los hombres adultos
✅ Quieres selección **automática** por edad/sexo
✅ No hay subdivisiones adicionales

**Ejemplo:** Hemoglobina, Hematocrito

### **Usa VALOR1-MASC, VALOR2-MASC, etc. cuando:**
✅ Necesitas **múltiples rangos** para hombres
✅ Los rangos dependen de **condiciones adicionales** (edad específica, método, etc.)
✅ Quieres **documentar** diferentes interpretaciones

**Ejemplo:** PSA, Testosterona, Espermatozoides

---

## 📝 Ejemplo Completo: Configurar PSA

### **Paso 1:** Crear el parámetro "PSA" en el examen

### **Paso 2:** Ir a "Gestionar Referencias"

### **Paso 3:** Agregar los rangos:

```
1. Click "Agregar Referencia"
   - Grupo: VALOR1-MASC
   - Valor Min: (vacío)
   - Valor Max: 2.5
   - Condición: "Hombres 40-49 años"
   - Guardar

2. Click "Agregar Referencia"
   - Grupo: VALOR2-MASC
   - Valor Min: (vacío)
   - Valor Max: 3.5
   - Condición: "Hombres 50-59 años"
   - Guardar

3. Click "Agregar Referencia"
   - Grupo: VALOR3-MASC
   - Valor Min: (vacío)
   - Valor Max: 4.5
   - Condición: "Hombres 60-69 años"
   - Guardar

4. Click "Agregar Referencia"
   - Grupo: VALOR4-MASC
   - Valor Min: (vacío)
   - Valor Max: 6.5
   - Condición: "Hombres 70+ años"
   - Guardar
```

### **Paso 4:** Al cargar resultados

El sistema mostrará el **primer rango** (VALOR1-MASC) automáticamente, pero el laboratorista puede ver en el campo "Condición" cuál es el apropiado según la edad del paciente.

---

## 🔍 Limitación Actual del Sistema

**Problema:** El método `getReferenceRangeForPatient()` retorna **el primer rango** que coincida con el sexo, sin distinguir entre VALOR1-MASC, VALOR2-MASC, etc.

**Solución actual:** Usar el campo **"Condición"** para documentar cuándo usar cada rango.

**Mejora futura:** Modificar el método para que también considere rangos de edad más específicos dentro de los grupos VALOR-MASC.

---

## 📊 Tabla Resumen

| Grupo | Diferencia | Cuándo Usar | Ejemplo |
|-------|-----------|-------------|---------|
| **VALOR1-MASC** | Primer rango | Rango principal o más común | PSA < 4.0 (estándar) |
| **VALOR2-MASC** | Segundo rango | Rango alternativo o por edad | PSA < 3.5 (50-59 años) |
| **VALOR3-MASC** | Tercer rango | Otro rango específico | PSA < 4.5 (60-69 años) |
| **VALOR4-MASC** | Cuarto rango | Otro rango específico | PSA < 6.5 (70+ años) |
| **VALOR5-MASC** | Quinto rango | Rango adicional | (según necesidad) |

---

## 🎓 Conclusión

**VALOR1-MASC, VALOR2-MASC, VALOR3-MASC, VALOR4-MASC y VALOR5-MASC:**

- ✅ Son **idénticos funcionalmente**
- ✅ Solo difieren en el **número** (1, 2, 3, 4, 5)
- ✅ Te permiten definir **hasta 5 rangos diferentes** para hombres
- ✅ Usas el campo **"Condición"** para documentar cuándo usar cada uno
- ✅ El sistema selecciona **el primero** que coincida con el sexo
- ✅ Son útiles para parámetros con **múltiples interpretaciones** o **rangos por edad**

**Analogía:** Son como tener 5 cajones etiquetados "Rango 1", "Rango 2", "Rango 3", etc. Tú decides qué poner en cada cajón según tus necesidades.

---

**Última actualización:** 2025-12-11  
**Estado:** ✅ Explicación completa
