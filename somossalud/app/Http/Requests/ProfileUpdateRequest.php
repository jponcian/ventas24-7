<?php

namespace App\Http\Requests;

use App\Models\User;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class ProfileUpdateRequest extends FormRequest
{
    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'email' => [
                'required',
                'string',
                'email',
                'max:255',
                Rule::unique(User::class)->ignore($this->user()->id),
            ],
            'sexo' => ['required', 'in:M,F'],
            'fecha_nacimiento' => ['required', 'date'],
            'mpps' => ['nullable', 'string', 'max:50'],
            'colegio_bioanalista' => ['nullable', 'string', 'max:50'],
            'firma' => ['nullable', 'image', 'mimes:jpeg,png,jpg,gif,bmp,webp', 'max:10240'],
        ];
    }
}
