# Guía de Uso - Sistema de Fiados y Dashboard Administrativo

## 📱 Acceso al Sistema

### Para Administradores
Los usuarios con rol `admin`, `administrador` o `superadmin` tendrán acceso a:
- ✅ Dashboard Administrativo
- ✅ Gestión de Fiados
- ✅ Todas las funcionalidades de vendedor

### Para Vendedores
Los usuarios con rol `vendedor` solo tendrán acceso a:
- ✅ Dashboard normal
- ✅ Panel de ventas
- ✅ Reporte de sus ventas

---

## 🎯 Dashboard Administrativo

### Cómo acceder:
1. Abrir el menú lateral (☰)
2. Seleccionar **"Dashboard Administrativo"**

### Funcionalidades:
- **Selector de Fecha**: Toca el calendario para ver datos de días anteriores
- **Tarjetas de Resumen**:
  - 💰 Total de Ventas (USD)
  - 📈 Ganancia Neta (Ventas - Costos)
  - 💼 Inversión Total en Inventario
  - 📊 Costos del Día

- **Gráfico de Ventas por Hora**: Visualiza las ventas a lo largo del día
- **Top 5 Productos**: Los productos más vendidos del día
- **Acciones Rápidas**: Botones para nueva venta y reportes

---

## 💳 Sistema de Fiados

### Cómo acceder:
1. Abrir el menú lateral (☰)
2. Seleccionar **"Gestión de Fiados"**

### Tab: CLIENTES

#### Ver Clientes
- Lista de todos los clientes registrados
- Muestra deuda total de cada cliente
- Buscador por nombre, cédula o teléfono

#### Agregar Cliente
1. Toca el botón flotante **+**
2. Completa el formulario:
   - **Nombre** (obligatorio)
   - Cédula
   - Teléfono
   - Dirección
3. Toca **"CREAR CLIENTE"**

#### Enviar Estado de Cuenta por WhatsApp
1. Busca el cliente en la lista
2. Toca el icono de WhatsApp (💬)
3. Se abrirá WhatsApp con un mensaje pre-cargado que incluye:
   - Saludo personalizado
   - Lista de todos los fiados pendientes
   - Total adeudado
   - Mensaje de cortesía

**Nota**: El cliente debe tener un número de teléfono registrado.

---

### Tab: FIADOS

#### Ver Fiados Pendientes
- Lista de todos los créditos con estado "pendiente"
- Muestra:
  - Nombre del cliente
  - Fecha del fiado
  - Total del fiado
  - Saldo pendiente

#### Crear Nuevo Fiado
1. Toca el botón flotante **+**
2. Selecciona el **cliente** del dropdown
3. Busca y selecciona los **productos**:
   - Usa el buscador para encontrar productos
   - Toca un producto para ingresar la cantidad
   - Los productos seleccionados se marcan con un badge azul
4. Revisa el resumen tocando el ícono del carrito (🛒)
5. Toca **"Guardar Fiado"**

**Importante**: Los precios se congelan al momento de crear el fiado. Si el producto sube de precio después, el cliente seguirá pagando el precio original.

#### Ver Detalle de Fiado
1. En la lista de fiados, toca cualquier fiado
2. Verás:
   - Información del cliente
   - Total y saldo pendiente
   - Estado (pendiente/pagado)
   - Lista de productos con precios
   - Historial de abonos

#### Registrar Abono (Pago)
1. Abre el detalle del fiado
2. Toca **"Registrar Abono"**
3. Ingresa:
   - **Monto** del pago
   - **Moneda** (USD o Bs)
   - Observaciones (opcional)
4. Toca **"Registrar"**

**El sistema automáticamente**:
- Convierte el monto a ambas monedas usando la tasa del día
- Actualiza el saldo pendiente
- Marca el fiado como "pagado" si el saldo llega a cero

---

## 🔄 Flujo Completo de Trabajo

### Ejemplo: Otorgar un Fiado

1. **Registrar Cliente** (si es nuevo)
   - Menú → Gestión de Fiados → Tab Clientes → Botón +
   - Completar datos y guardar

2. **Crear Fiado**
   - Tab Fiados → Botón +
   - Seleccionar cliente
   - Agregar productos (ej: 2 Coca-Cola, 1 Pan)
   - Revisar resumen
   - Guardar

3. **Cliente Realiza Pago Parcial**
   - Tab Fiados → Seleccionar el fiado
   - Registrar Abono
   - Ingresar monto (ej: $5 USD)
   - Guardar

4. **Enviar Recordatorio**
   - Tab Clientes → Buscar cliente
   - Toca ícono WhatsApp
   - Se abre WhatsApp con mensaje automático
   - Enviar mensaje

5. **Cliente Completa el Pago**
   - Registrar abono final
   - El sistema marca automáticamente como "pagado"

---

## 💡 Consejos y Mejores Prácticas

### Gestión de Clientes
- ✅ Registra el teléfono para usar WhatsApp
- ✅ Usa la cédula para identificar clientes únicos
- ✅ Actualiza la dirección para entregas

### Creación de Fiados
- ✅ Verifica el stock antes de crear el fiado
- ✅ Revisa el resumen antes de guardar
- ✅ Los precios quedan congelados, no se pueden cambiar después

### Registro de Abonos
- ✅ Puedes recibir pagos en USD o Bs
- ✅ Usa observaciones para notas importantes (ej: "Pago con transferencia")
- ✅ El sistema calcula automáticamente si el fiado está pagado

### Seguimiento
- ✅ Usa el buscador de clientes para encontrar rápidamente
- ✅ Revisa regularmente los fiados pendientes
- ✅ Envía recordatorios por WhatsApp de forma cortés

---

## ⚠️ Notas Importantes

### Precios Congelados
Los precios de los productos en un fiado **NO cambian** aunque el producto suba de precio en el inventario. Esto protege al cliente de aumentos inesperados.

### Descuento de Stock
Al crear un fiado, el stock se descuenta automáticamente del inventario, igual que en una venta normal.

### Conversión de Moneda
- Los abonos se pueden registrar en USD o Bs
- El sistema usa la tasa del día para convertir
- Ambos montos se guardan para referencia

### Estados de Fiado
- **Pendiente**: Tiene saldo por pagar
- **Pagado**: Saldo = 0, completamente pagado
- **Cancelado**: (futuro) Para fiados anulados

---

## 🆘 Solución de Problemas

### No veo el Dashboard Administrativo
- Verifica que tu rol sea `admin`, `administrador` o `superadmin`
- Cierra sesión y vuelve a iniciar

### No puedo crear un fiado
- Verifica que hayas seleccionado un cliente
- Asegúrate de haber agregado al menos un producto
- Revisa que los productos tengan stock disponible

### El WhatsApp no se abre
- Verifica que el cliente tenga teléfono registrado
- Asegúrate de estar en un dispositivo móvil con WhatsApp instalado
- El número debe estar en formato internacional (ej: 584121234567)

### El saldo no se actualiza
- Verifica que el abono se haya guardado correctamente
- Refresca la pantalla deslizando hacia abajo
- Si persiste, contacta al administrador del sistema

---

## 📞 Soporte

Para problemas técnicos o preguntas sobre el sistema, contacta al administrador de tu negocio.

**Versión**: 1.1.0  
**Última actualización**: Febrero 2026
