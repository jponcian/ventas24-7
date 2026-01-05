<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Credenciales de Acceso</title>
</head>
<body style="margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f4f4;">
    <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #f4f4f4; padding: 20px 0;">
        <tr>
            <td align="center">
                <table width="600" cellpadding="0" cellspacing="0" style="background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.1);">
                    <!-- Header -->
                    <tr>
                        <td style="background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%); padding: 40px 30px; text-align: center;">
                            <h1 style="color: #ffffff; margin: 0; font-size: 28px; font-weight: 600;">
                                ¡Bienvenido a Clínica SaludSonrisa!
                            </h1>
                            <p style="color: rgba(255,255,255,0.9); margin: 10px 0 0 0; font-size: 16px;">
                                Tu cuenta ha sido creada exitosamente
                            </p>
                        </td>
                    </tr>

                    <!-- Content -->
                    <tr>
                        <td style="padding: 40px 30px;">
                            <p style="color: #333333; font-size: 16px; line-height: 1.6; margin: 0 0 20px 0;">
                                Hola <strong>{{ $paciente->name }}</strong>,
                            </p>

                            <p style="color: #666666; font-size: 15px; line-height: 1.6; margin: 0 0 30px 0;">
                                Tu cuenta en nuestro portal de pacientes ha sido creada. Ahora puedes acceder para ver tus resultados de laboratorio, agendar citas y mucho más.
                            </p>

                            <!-- Credentials Box -->
                            <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #f8f9fa; border-left: 4px solid #0ea5e9; border-radius: 4px; margin: 0 0 30px 0;">
                                <tr>
                                    <td style="padding: 25px;">
                                        <h2 style="color: #0ea5e9; font-size: 18px; margin: 0 0 20px 0; font-weight: 600;">
                                            🔐 Tus Credenciales de Acceso
                                        </h2>
                                        
                                        <table width="100%" cellpadding="8" cellspacing="0">
                                            <tr>
                                                <td style="color: #666666; font-size: 14px; font-weight: 600; width: 140px;">Usuario:</td>
                                                <td style="color: #333333; font-size: 16px; font-weight: 600; font-family: 'Courier New', monospace;">
                                                    {{ $paciente->cedula }}
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="color: #666666; font-size: 14px; font-weight: 600;">Contraseña:</td>
                                                <td style="color: #333333; font-size: 16px; font-weight: 600; font-family: 'Courier New', monospace;">
                                                    {{ $password }}
                                                </td>
                                            </tr>
                                        </table>

                                        <p style="color: #dc3545; font-size: 13px; margin: 15px 0 0 0; font-style: italic;">
                                            ⚠️ Por seguridad, te recomendamos cambiar tu contraseña al iniciar sesión por primera vez.
                                        </p>
                                    </td>
                                </tr>
                            </table>

                            <!-- CTA Button -->
                            <table width="100%" cellpadding="0" cellspacing="0" style="margin: 0 0 30px 0;">
                                <tr>
                                    <td align="center">
                                        <a href="{{ url('/login') }}" style="display: inline-block; background: linear-gradient(135deg, #0ea5e9 0%, #10b981 100%); color: #ffffff; text-decoration: none; padding: 15px 40px; border-radius: 8px; font-size: 16px; font-weight: 600; box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);">
                                            Iniciar Sesión Ahora
                                        </a>
                                    </td>
                                </tr>
                            </table>

                            <!-- Instructions -->
                            <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #fff3cd; border-left: 4px solid #ffc107; border-radius: 4px; margin: 0 0 20px 0;">
                                <tr>
                                    <td style="padding: 20px;">
                                        <h3 style="color: #856404; font-size: 16px; margin: 0 0 15px 0; font-weight: 600;">
                                            📋 Pasos para acceder:
                                        </h3>
                                        <ol style="color: #856404; font-size: 14px; line-height: 1.8; margin: 0; padding-left: 20px;">
                                            <li>Visita: <strong>{{ url('/') }}</strong></li>
                                            <li>Haz clic en "Iniciar Sesión"</li>
                                            <li>Ingresa tu cédula y contraseña</li>
                                            <li>Cambia tu contraseña por una personal</li>
                                        </ol>
                                    </td>
                                </tr>
                            </table>

                            <p style="color: #666666; font-size: 14px; line-height: 1.6; margin: 0;">
                                Si tienes alguna pregunta o necesitas ayuda, no dudes en contactarnos.
                            </p>
                        </td>
                    </tr>

                    <!-- Footer -->
                    <tr>
                        <td style="background-color: #f8f9fa; padding: 30px; text-align: center; border-top: 1px solid #e9ecef;">
                            <p style="color: #666666; font-size: 14px; margin: 0 0 10px 0;">
                                <strong>Clínica SaludSonrisa</strong>
                            </p>
                            <p style="color: #999999; font-size: 12px; margin: 0;">
                                Este es un correo automático, por favor no respondas a este mensaje.
                            </p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
