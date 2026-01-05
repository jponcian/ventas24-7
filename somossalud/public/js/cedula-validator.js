/**
 * Validador y Formateador de Cédulas Venezolanas
 * Clínica SaludSonrisa
 * 
 * Formato válido: V-12345678, E-1234567, J-123456, G-12345678, P-12345678
 * - Letras permitidas: V, E, J, G, P
 * - Si el usuario empieza con un número, se asume V- (venezolano) por defecto
 * - Números: 6 a 8 dígitos (máximo 8 dígitos, no se permiten 9 dígitos)
 */

class CedulaValidator {
    constructor(inputId) {
        this.input = document.getElementById(inputId);
        if (!this.input) {
            console.warn(`Input con ID "${inputId}" no encontrado`);
            return;
        }
        this.init();
    }

    init() {
        // Agregar evento de input para validación en tiempo real
        this.input.addEventListener('input', (e) => this.handleInput(e));
        
        // Agregar evento de paste para manejar pegado
        this.input.addEventListener('paste', (e) => this.handlePaste(e));
        
        // Validar valor inicial si existe
        if (this.input.value) {
            this.formatAndValidate(this.input.value);
        }
    }

    handleInput(e) {
        const value = e.target.value;
        this.formatAndValidate(value);
    }

    handlePaste(e) {
        e.preventDefault();
        const pastedText = (e.clipboardData || window.clipboardData).getData('text');
        this.formatAndValidate(pastedText);
    }

    formatAndValidate(value) {
        // Convertir a mayúsculas y limpiar caracteres no permitidos
        let cleaned = value.toUpperCase().replace(/[^VEJGP0-9-]/g, '');
        
        // Remover guiones existentes para reformatear
        cleaned = cleaned.replace(/-/g, '');
        
        // Si está vacío, limpiar validación
        if (cleaned.length === 0) {
            this.input.value = '';
            this.removeValidationClasses();
            return;
        }

        // Extraer primer carácter
        const firstChar = cleaned.charAt(0);
        
        // Si el primer carácter es un número, asumir V- (venezolano) por defecto
        if (/^\d$/.test(firstChar)) {
            // Usuario empezó con un número, agregar V- automáticamente
            const numbers = cleaned.slice(0, 8); // Máximo 8 dígitos
            const formatted = 'V-' + numbers;
            this.input.value = formatted;
            this.validate(formatted);
            return;
        }
        
        // Si el primer carácter es una letra válida
        if (/^[VEJGP]$/.test(firstChar)) {
            const letter = firstChar;
            const numbers = cleaned.slice(1);
            
            // Limitar números a máximo 8 dígitos
            const limitedNumbers = numbers.slice(0, 8);

            // Formatear con guión
            let formatted = letter;
            if (limitedNumbers.length > 0) {
                formatted += '-' + limitedNumbers;
            }

            // Actualizar valor del input
            this.input.value = formatted;

            // Validar formato completo
            this.validate(formatted);
            return;
        }
        
        // Caracter inválido, limpiar
        this.input.value = '';
        this.removeValidationClasses();
    }

    validate(value) {
        // Formato válido: Letra-6a8dígitos
        const isValid = /^[VEJGP]-\d{6,8}$/.test(value);
        
        if (isValid) {
            this.setValid();
        } else {
            // Si tiene letra y guión pero números insuficientes, mostrar como inválido
            if (/^[VEJGP]-\d{0,5}$/.test(value)) {
                this.setInvalid();
            } else if (/^[VEJGP]-\d{9,}$/.test(value)) {
                // Demasiados dígitos (esto no debería pasar por el límite, pero por seguridad)
                this.setInvalid();
            } else if (value.length > 1) {
                this.setInvalid();
            } else {
                this.removeValidationClasses();
            }
        }
    }

    setValid() {
        this.input.classList.remove('is-invalid');
        this.input.classList.add('is-valid');
    }

    setInvalid() {
        this.input.classList.remove('is-valid');
        this.input.classList.add('is-invalid');
    }

    removeValidationClasses() {
        this.input.classList.remove('is-valid', 'is-invalid');
    }

    getValue() {
        return this.input.value;
    }

    isValid() {
        return /^[VEJGP]-\d{6,8}$/.test(this.input.value);
    }
}

// Función helper para inicializar validador en un input
function initCedulaValidator(inputId) {
    return new CedulaValidator(inputId);
}

// Exportar para uso global
window.CedulaValidator = CedulaValidator;
window.initCedulaValidator = initCedulaValidator;
