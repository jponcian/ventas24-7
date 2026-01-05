class UserModel {
  final int id;
  final String name;
  final String email;
  final String? cedula;
  final int? clinicaId;
  final String? sexo;
  final String? fechaNacimiento;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.cedula,
    this.clinicaId,
    this.sexo,
    this.fechaNacimiento,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? 'Usuario',
      email: json['email'] ?? '',
      cedula: json['cedula'],
      clinicaId: json['clinica_id'],
      sexo: json['sexo'],
      fechaNacimiento: json['fecha_nacimiento'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'cedula': cedula,
      'clinica_id': clinicaId,
      'sexo': sexo,
      'fecha_nacimiento': fechaNacimiento,
    };
  }
}
