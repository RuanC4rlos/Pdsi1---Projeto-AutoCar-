import 'package:auto_car/models/car.dart';
import 'package:auto_car/models/car_list.dart';
import 'package:auto_car/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReservaPage extends StatefulWidget {
  final Car product;
  const ReservaPage({required this.product, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ReservaPageState createState() => _ReservaPageState();
}

class _ReservaPageState extends State<ReservaPage> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy');
  int differenceInDays = 1;

  List<dynamic> reservedDates = [];

  DateTime findNextAvailableDate(DateTime startDate) {
    DateTime nextAvailableDate = startDate;

    // Ordena as datas reservadas
    reservedDates.sort((a, b) => DateFormat('dd/MM/yyyy')
        .parse(a['final'])
        .compareTo(DateFormat('dd/MM/yyyy').parse(b['final'])));

    // Encontra a última data reservada
    if (reservedDates.isNotEmpty) {
      DateTime lastReservedDate =
          DateFormat('dd/MM/yyyy').parse(reservedDates.last['final']);

      // Começa a procurar a partir do dia seguinte ao último dia reservado
      if (nextAvailableDate.isBefore(lastReservedDate) ||
          nextAvailableDate.isAtSameMomentAs(lastReservedDate)) {
        nextAvailableDate = lastReservedDate.add(const Duration(days: 1));
      }
    }

    // Continua procurando até encontrar uma data disponível
    while (isReserved(nextAvailableDate)) {
      nextAvailableDate = nextAvailableDate.add(const Duration(days: 1));
    }

    return nextAvailableDate;
  }

  @override
  void initState() {
    super.initState();
    loadReservaAndSetStartDate();
  }

  Future<void> loadReservaAndSetStartDate() async {
    final reserva = Provider.of<CarList>(context, listen: false);
    await reserva.loadReserva();
    reservedDates = reserva.horariosReservados;
    _startDate = findNextAvailableDate(DateTime.now());
    _endDate = _startDate.add(const Duration(days: 1));
    setState(() {}); // Chame setState para atualizar a interface do usuário
  }

  bool isReserved(DateTime date) {
    for (Map<String, dynamic> reservedDateMap in reservedDates) {
      DateTime startDate =
          DateFormat('dd/MM/yyyy').parse(reservedDateMap['inicio']);
      DateTime endDate =
          DateFormat('dd/MM/yyyy').parse(reservedDateMap['final']);
      if ((date.isAfter(startDate) || date.isAtSameMomentAs(startDate)) &&
          (date.isBefore(endDate) || date.isAtSameMomentAs(endDate))) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendário',
          style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/calendario.png',
              height: 200,
            ),
            const Center(
              child: Text(
                'Escolha os dias\n  para alugar',
                style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(height: 40),
            Text(
              'Data de Início: ${_dateFormatter.format(_startDate)}',
              style: const TextStyle(fontSize: 18, fontFamily: 'Lato'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Selecionar Data de Início'),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate:
                      findNextAvailableDate(DateTime.now()), //_startDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  selectableDayPredicate: (DateTime date) {
                    // Desabilita a seleção de datas reservadas
                    if (isReserved(date)) {
                      return false;
                    }
                    // Habilita a seleção de todas as outras datas
                    return true;
                  },
                );
                if (date != null) {
                  setState(() {
                    _startDate = date;
                    differenceInDays = _endDate.difference(_startDate).inDays;
                    // ignore: avoid_print
                    print('DDD1:$differenceInDays');

                    if (differenceInDays == 0) differenceInDays = 1;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Data de Fim: ${_dateFormatter.format(_endDate)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Selecionar Data de Fim'),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _endDate,
                  firstDate: _startDate,
                  lastDate: _startDate.add(const Duration(days: 365)),
                  selectableDayPredicate: (DateTime date) {
                    // Desabilita a seleção de datas reservadas
                    if (isReserved(date)) {
                      return false;
                    }
                    // Habilita a seleção de todas as outras datas
                    return true;
                  },
                );
                if (date != null) {
                  setState(() {
                    _endDate = date;
                    differenceInDays = _endDate.difference(_startDate).inDays;
                    // ignore: avoid_print
                    print('$_startDate $_endDate DDD2:$differenceInDays');

                    if (differenceInDays == 0) differenceInDays = 1;
                  });
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Preço: R\$ ${NumberFormat("#,##0.00", "pt_BR").format(widget.product.preco * differenceInDays)}',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.RESERVAR_FORM, arguments: {
                    'inicio': _dateFormatter.format(_startDate),
                    'final': _dateFormatter.format(_endDate),
                    'id': widget.product.id,
                    'marca': widget.product.marca,
                    'modelo': widget.product.modelo,
                    'preco': widget.product.preco,
                  });
                },
                child: const Text(
                  'Continuar',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
