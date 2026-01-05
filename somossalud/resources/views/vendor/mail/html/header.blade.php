@props(['url'])
<tr>
<td class="header">
<a href="{{ $url }}" style="display: inline-block;">
@if (trim($slot) === 'Laravel')
<img src="{{ asset('images/saludsonrisa.jpg') }}" class="logo" alt="SaludSonrisa" style="max-height: 50px;">
@else
{{ $slot }}
@endif
</a>
</td>
</tr>
