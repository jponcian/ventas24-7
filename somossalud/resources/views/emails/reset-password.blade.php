@component('mail::message')
# ¡Hola!

Recibimos una solicitud para restablecer la contraseña de tu cuenta.

Si no realizaste esta solicitud, puedes ignorar este correo de forma segura.

@component('mail::button', ['url' => $url, 'color' => 'primary'])
Restablecer contraseña
@endcomponent

Este enlace de restablecimiento expirará en 60 minutos.

Por tu seguridad, te recomendamos usar una contraseña segura que incluya letras, números y símbolos.

Saludos cordiales,<br>
El equipo de SaludSonrisa

@slot('subcopy')
Si tienes problemas al hacer clic en el botón "Restablecer contraseña", copia y pega la siguiente URL en tu navegador web:

[{{ $url }}]({{ $url }})
@endslot
@endcomponent
