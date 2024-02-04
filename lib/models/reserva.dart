class Reserva {
  String id;
  String marca;
  String modelo;
  String nome;
  String cpf;
  String contato;
  String endereco;
  double preco;
  Map<String, dynamic> horario;

  Reserva({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.nome,
    required this.cpf,
    required this.contato,
    required this.endereco,
    required this.preco,
    required this.horario,
  });
}
