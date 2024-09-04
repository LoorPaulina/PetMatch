import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pet_match/constants.dart';
import 'package:pet_match/models/evento.dart';

class AdoptionEventsScreen extends StatefulWidget {
  @override
  _AdoptionEventsScreenState createState() => _AdoptionEventsScreenState();
}

class _AdoptionEventsScreenState extends State<AdoptionEventsScreen> {
  List<Evento> eventos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _incrementLike(Evento evento) async {
    try {
      final response = await Dio().post(
        '${urlBack}darLike',
        data: {'evento_title': evento.title},
      );

      if (response.statusCode == 201) {
        print('Like registrado exitosamente');
      } else {
        print('Error al registrar el like: ${response.data}');
      }
    } catch (e) {
      print('Excepción al enviar like: $e');
    }
  }

  Future<void> _fetchEvents() async {
    try {
      final response = await Dio().get('${urlBack}getEventos');

      List<Evento> fetchedEventos = [];
      for (var item in response.data["data"]) {
        Evento evento = Evento.fromJson(item);
        fetchedEventos.add(evento);
      }

      setState(() {
        eventos = fetchedEventos;
        isLoading =
            false; // Se estableció isLoading a false después de cargar datos
      });
    } catch (e) {
      _showError('An error occurred while fetching events');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showError(String message) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos de Adopción'),
        backgroundColor: secundaryColor,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Próximos Eventos de Adopción',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: eventos.length,
                      itemBuilder: (context, index) {
                        final event = eventos[index];
                        return Card(
                          child: ListTile(
                            title: Text(event.title ?? 'No Title'),
                            subtitle: Text(
                                '${_formatDate(event.fecha)} en ${event.location}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.thumb_up),
                                  onPressed: () async {
                                    setState(() {
                                      eventos[index] = Evento(
                                        title: event.title,
                                        fecha: event.fecha,
                                        location: event.location,
                                        image: event.image,
                                        descripcion: event.descripcion,
                                        likes: event.likes + 1,
                                      );
                                    });

                                    // incrementa likes en el back
                                    await _incrementLike(event);
                                  },
                                ),
                                Text('${event.likes}'),
                              ],
                            ),
                            onTap: () =>
                                _showEventDetailsDialog(context, event),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _showEventDetailsDialog(BuildContext context, Evento event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(event.title ?? 'No Title'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/eventos/${event.image}.jpeg',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10),
              Text('Fecha: ${_formatDate(event.fecha)}'),
              Text('Ubicación: ${event.location}'),
              SizedBox(height: 10),
              Text(event.descripcion ?? 'No Description'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
