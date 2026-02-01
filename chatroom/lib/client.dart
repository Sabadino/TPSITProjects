import 'dart:convert';
import 'dart:io';

void main() async {
  print("Ho iniziato");

  try {
    final socket = await Socket.connect("192.168.4.40", 3000);
    print('Connesso a ${socket.remoteAddress.address}:${socket.remotePort}\n');

    socket.listen(
      (data) {
        String message = utf8.decode(data).trim();
        print(message);
      },
      onDone: () {
        print('\nServer disconnesso');
        exit(0);
      },
      onError: (error) {
        print('Errore ricezione: $error');
        exit(1);
      },
    );

    print('Scrivi messaggi (digita "exit1" per uscire):');
    await for (var line
        in stdin.transform(utf8.decoder).transform(LineSplitter())) {
      if (line.toLowerCase() == 'exit1') {
        await socket.close();
        exit(0);
      }

      if (line.isNotEmpty) {
        socket.write('$line\n');
        await socket.flush();
      }
    }
  } catch (e) {
    print('Errore: $e');
    exit(1);
  }
}