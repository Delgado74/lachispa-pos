class User {
  final String id;
  final String nombre;
  final String rol;
  final String? lndhubUrl;
  final String? lndhubCreds;
  final DateTime createdAt;

  User({
    required this.id,
    required this.nombre,
    required this.rol,
    this.lndhubUrl,
    this.lndhubCreds,
    required this.createdAt,
  });

  bool get isJefe => rol == 'jefe';
  bool get isDependiente => rol == 'dependiente';
  bool get hasLndhub => lndhubUrl != null && lndhubCreds != null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'rol': rol,
      'lndhub_url': lndhubUrl,
      'lndhub_creds': lndhubCreds,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      nombre: map['nombre'] as String,
      rol: map['rol'] as String,
      lndhubUrl: map['lndhub_url'] as String?,
      lndhubCreds: map['lndhub_creds'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  User copyWith({
    String? id,
    String? nombre,
    String? rol,
    String? lndhubUrl,
    String? lndhubCreds,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      rol: rol ?? this.rol,
      lndhubUrl: lndhubUrl ?? this.lndhubUrl,
      lndhubCreds: lndhubCreds ?? this.lndhubCreds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
